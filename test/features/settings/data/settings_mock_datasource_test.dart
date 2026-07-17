import 'package:diandian_chuanshu/core/services/teen_mode_service.dart';
import 'package:diandian_chuanshu/features/settings/data/datasources/settings_mock_datasource.dart';
import 'package:diandian_chuanshu/features/settings/domain/entities/settings_menu_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('青少年模式开启后设置菜单显示已开启', () async {
    final teenModeService = TeenModeService();
    final dataSource = SettingsMockDataSource(teenModeService);

    var content = await dataSource.fetchPageContent();
    expect(_teenModeItem(content.menuItems).trailingText, '未开启');

    teenModeService.enable();
    content = await dataSource.fetchPageContent();
    expect(_teenModeItem(content.menuItems).trailingText, '已开启');
  });
}

SettingsMenuItem _teenModeItem(List<SettingsMenuItem> items) {
  return items.singleWhere(
    (item) => item.action == SettingsMenuAction.teenMode,
  );
}
