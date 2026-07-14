import '../../domain/entities/dress_up_page_content.dart';
import '../../domain/repositories/dress_up_repository.dart';
import '../datasources/dress_up_data_source.dart';

class DressUpRepositoryImpl implements DressUpRepository {
  const DressUpRepositoryImpl(this._dataSource);

  final DressUpDataSource _dataSource;

  @override
  Future<DressUpPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
