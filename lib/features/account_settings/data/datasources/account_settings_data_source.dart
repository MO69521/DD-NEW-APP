import '../../domain/entities/account_settings_page_content.dart';

/// 账号设置数据源抽象。Mock 与 Remote 实现同一契约，
/// Repository 只依赖此接口——接入真实接口时仅替换注入的实现，无需改动上层。
abstract interface class AccountSettingsDataSource {
  Future<AccountSettingsPageContent> fetchPageContent();
}
