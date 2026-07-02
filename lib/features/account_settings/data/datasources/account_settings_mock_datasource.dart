import '../../domain/entities/account_security_binding.dart';
import '../../domain/entities/account_settings_page_content.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class AccountSettingsMockDataSource {
  const AccountSettingsMockDataSource();

  Future<AccountSettingsPageContent> fetchPageContent() async {
    return AccountSettingsPageContent(
      avatarUrl: _mockAvatarUrl,
      nickname: '宇宙无敌美少女',
      userId: '1013971429',
      securityBindings: _securityBindings,
    );
  }

  static const String _mockAvatarUrl =
      'https://www.figma.com/api/mcp/asset/c27ff5ed-ffc6-410c-aa1d-d24cd1f916d8';

  static const List<AccountSecurityBinding> _securityBindings = [
    AccountSecurityBinding(
      type: AccountSecurityBindingType.phone,
      label: '手机号',
      iconAsset: 'assets/icons/account_settings/phone.svg',
      displayValue: '152****9692',
      actionLabel: '去换绑',
      isBound: true,
    ),
    AccountSecurityBinding(
      type: AccountSecurityBindingType.qq,
      label: 'QQ',
      iconAsset: 'assets/icons/account_settings/qq.svg',
      actionLabel: '去绑定',
    ),
    AccountSecurityBinding(
      type: AccountSecurityBindingType.wechat,
      label: '微信',
      iconAsset: 'assets/icons/account_settings/wechat.svg',
      actionLabel: '去绑定',
    ),
    AccountSecurityBinding(
      type: AccountSecurityBindingType.douyin,
      label: '抖音',
      iconAsset: 'assets/icons/account_settings/douyin.svg',
      actionLabel: '去绑定',
    ),
  ];
}
