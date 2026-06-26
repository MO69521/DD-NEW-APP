import '../../domain/entities/profile_page_content.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_mock_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileMockDataSource _dataSource;

  @override
  Future<ProfilePageContent> fetchPageContent() => _dataSource.fetchPageContent();
}
