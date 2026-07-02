import '../entities/settings_page_content.dart';

abstract interface class SettingsRepository {
  Future<SettingsPageContent> fetchPageContent();
}
