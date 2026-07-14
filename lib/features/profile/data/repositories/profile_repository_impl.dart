import '../../domain/entities/profile_page_content.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileDataSource _dataSource;

  @override
  Future<ProfilePageContent> fetchPageContent() => _dataSource.fetchPageContent();
}
