import '../../domain/entities/settings_menu_item.dart';
import '../../domain/entities/settings_page_content.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class SettingsMockDataSource {
  const SettingsMockDataSource();

  Future<SettingsPageContent> fetchPageContent() async {
    return const SettingsPageContent(
      appVersion: '3.9.6.7',
      icpRecord: '琼ICP备2023000195号-5A',
      menuItems: _menuItems,
    );
  }

  static const List<SettingsMenuItem> _menuItems = [
    SettingsMenuItem(
      action: SettingsMenuAction.notifications,
      label: '消息通知',
      subtitle: '去打开通知，书籍更新第一时间提醒你哦～',
    ),
    SettingsMenuItem(
      action: SettingsMenuAction.personalizedAds,
      label: '个性化广告',
    ),
    SettingsMenuItem(
      action: SettingsMenuAction.readingPreferences,
      label: '阅读偏好',
    ),
    SettingsMenuItem(
      action: SettingsMenuAction.teenMode,
      label: '青少年模式',
      trailingText: '未开启',
    ),
    SettingsMenuItem(action: SettingsMenuAction.userAgreement, label: '用户协议'),
    SettingsMenuItem(action: SettingsMenuAction.privacyPolicy, label: '隐私政策'),
    SettingsMenuItem(
      action: SettingsMenuAction.thirdPartySharing,
      label: '第三方服务共享清单',
    ),
    SettingsMenuItem(action: SettingsMenuAction.versionUpdate, label: '版本更新'),
  ];
}
