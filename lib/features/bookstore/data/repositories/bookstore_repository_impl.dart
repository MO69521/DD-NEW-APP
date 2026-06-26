import '../../domain/entities/bookstore_page_content.dart';
import '../../domain/repositories/bookstore_repository.dart';
import '../datasources/bookstore_mock_datasource.dart';

/// data 层仓储实现，仅做数据获取与映射。
class BookstoreRepositoryImpl implements BookstoreRepository {
  const BookstoreRepositoryImpl(this._dataSource);

  final BookstoreMockDataSource _dataSource;

  @override
  Future<BookstorePageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
