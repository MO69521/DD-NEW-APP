import '../../domain/entities/dress_up_page_content.dart';
import '../../domain/repositories/dress_up_repository.dart';
import '../datasources/dress_up_mock_datasource.dart';

class DressUpRepositoryImpl implements DressUpRepository {
  const DressUpRepositoryImpl(this._dataSource);

  final DressUpMockDataSource _dataSource;

  @override
  Future<DressUpPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
