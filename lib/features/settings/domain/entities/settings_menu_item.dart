/// 设置页菜单项操作标识。
enum SettingsMenuAction {
  notifications,
  accountSettings,
  personalizedAds,
  readingPreferences,
  teenMode,
  userAgreement,
  privacyPolicy,
  thirdPartySharing,
  versionUpdate,
}

/// 设置页单行菜单配置。
class SettingsMenuItem {
  const SettingsMenuItem({
    required this.action,
    required this.label,
    this.subtitle,
    this.trailingText,
  });

  final SettingsMenuAction action;
  final String label;
  final String? subtitle;
  final String? trailingText;
}
