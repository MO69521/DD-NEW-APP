import '../entities/account_settings_page_content.dart';

abstract interface class AccountSettingsRepository {
  Future<AccountSettingsPageContent> fetchPageContent();
}
