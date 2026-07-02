import 'package:equatable/equatable.dart';

import 'settings_menu_item.dart';

/// 设置页聚合数据。
class SettingsPageContent extends Equatable {
  const SettingsPageContent({
    required this.appVersion,
    required this.menuItems,
    required this.icpRecord,
  });

  final String appVersion;
  final List<SettingsMenuItem> menuItems;
  final String icpRecord;

  @override
  List<Object?> get props => [appVersion, menuItems, icpRecord];
}
