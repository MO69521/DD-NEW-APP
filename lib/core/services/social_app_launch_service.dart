import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// 第三方登录对应的宿主 App。
enum SocialAppTarget {
  wechat,
  qq,
  douyin;

  String get displayName => switch (this) {
    SocialAppTarget.wechat => '微信',
    SocialAppTarget.qq => 'QQ',
    SocialAppTarget.douyin => '抖音',
  };
}

/// 拉起第三方 App 做授权登录的结果。
enum SocialAppLaunchOutcome {
  /// 已跳转到对应 App（正式环境需接各厂商 SDK 完成授权回跳）。
  launched,

  /// 未检测到已安装，应弹窗引导下载。
  notInstalled,

  /// 已安装但拉起失败。
  failed,
}

/// 检测 / 拉起微信、QQ、抖音，并提供应用商店下载入口。
///
/// 正式 OAuth 需接入各厂商 SDK 与 AppID；本服务负责安装检测、跳转与下载引导。
class SocialAppLaunchService {
  const SocialAppLaunchService();

  Future<bool> isInstalled(SocialAppTarget target) async {
    for (final uri in _probeUris(target)) {
      if (await canLaunchUrl(uri)) return true;
    }
    return false;
  }

  /// 若已安装则跳转对应 App；未安装返回 [SocialAppLaunchOutcome.notInstalled]。
  Future<SocialAppLaunchOutcome> openForAuthorization(
    SocialAppTarget target,
  ) async {
    if (!await isInstalled(target)) {
      return SocialAppLaunchOutcome.notInstalled;
    }

    for (final uri in _authLaunchUris(target)) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return SocialAppLaunchOutcome.launched;
      } catch (_) {
        // 尝试下一个 scheme。
      }
    }
    return SocialAppLaunchOutcome.failed;
  }

  /// 打开应用商店 / 下载页，引导安装对应 App。
  Future<bool> openDownloadStore(SocialAppTarget target) async {
    final candidates = _downloadUris(target);
    for (final uri in candidates) {
      try {
        if (!await canLaunchUrl(uri)) continue;
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return true;
      } catch (_) {
        // 尝试下一个下载链接。
      }
    }
    return false;
  }

  List<Uri> _probeUris(SocialAppTarget target) {
    return switch (target) {
      SocialAppTarget.wechat => [
        Uri.parse('weixin://'),
        Uri.parse('wechat://'),
      ],
      SocialAppTarget.qq => [
        Uri.parse('mqqapi://'),
        Uri.parse('mqq://'),
      ],
      SocialAppTarget.douyin => [
        Uri.parse('snssdk1128://'),
        Uri.parse('aweme://'),
      ],
    };
  }

  List<Uri> _authLaunchUris(SocialAppTarget target) {
    // 无 SDK AppID 时先打开宿主 App；接入官方 SDK 后可替换为带授权参数的 deep link。
    return _probeUris(target);
  }

  List<Uri> _downloadUris(SocialAppTarget target) {
    final isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    return switch (target) {
      SocialAppTarget.wechat => [
        if (isAndroid) Uri.parse('market://details?id=com.tencent.mm'),
        Uri.parse('https://apps.apple.com/cn/app/id414478124'),
        Uri.parse('https://weixin.qq.com/'),
      ],
      SocialAppTarget.qq => [
        if (isAndroid) Uri.parse('market://details?id=com.tencent.mobileqq'),
        Uri.parse('https://apps.apple.com/cn/app/id444934666'),
        Uri.parse('https://im.qq.com/'),
      ],
      SocialAppTarget.douyin => [
        if (isAndroid)
          Uri.parse('market://details?id=com.ss.android.ugc.aweme'),
        Uri.parse('https://apps.apple.com/cn/app/id1142110895'),
        Uri.parse('https://www.douyin.com/download'),
      ],
    };
  }
}
