import '../../domain/entities/settings_page_content.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_mock_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._dataSource);

  final SettingsMockDataSource _dataSource;

  @override
  Future<SettingsPageContent> fetchPageContent() => _dataSource.fetchPageContent();
}
