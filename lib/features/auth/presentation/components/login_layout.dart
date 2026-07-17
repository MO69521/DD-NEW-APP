import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_assets.dart';

/// 登录页布局常量（间距 / 资源），供登录页与各登录表单共用。
abstract final class LoginLayout {
  /// `yellow_light` 与「我的」页共用新版头图；其他主题保留原登录图。
  static const String topBackgroundAsset = AppThemeAssets.authLoginTopBg;
  static const String appIconAsset = 'assets/images/splash/app_icon.png';
  static const double contentHorizontalInset = AppSpacing.xl + AppSpacing.xs;
  static const double titleFrameTop =
      AppSizes.statusBarPlaceholderHeight +
      AppSpacing.xxl +
      AppSpacing.lg +
      AppSpacing.xxs;
  static const double titleToInputGap =
      AppSpacing.xxl + AppSpacing.lg + AppSpacing.xxsHalf;
  static const double inputToButtonGap = AppSpacing.xxl + AppSpacing.xl;
  static const double buttonToAgreementGap = AppSpacing.xl;
}

/// 手机号中间四位掩码：`138****5678`；长度不符时原样返回。
String maskLoginPhone(String phone) {
  if (phone.length != AppConstants.phoneNumberLength) return phone;
  return '${phone.substring(0, 3)}****${phone.substring(7)}';
}
