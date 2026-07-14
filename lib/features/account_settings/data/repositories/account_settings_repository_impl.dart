import '../../domain/entities/account_settings_page_content.dart';
import '../../domain/repositories/account_settings_repository.dart';
import '../datasources/account_settings_data_source.dart';

class AccountSettingsRepositoryImpl implements AccountSettingsRepository {
  const AccountSettingsRepositoryImpl(this._dataSource);

  final AccountSettingsDataSource _dataSource;

  @override
  Future<AccountSettingsPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
