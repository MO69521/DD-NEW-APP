import '../../domain/entities/bookstore_page_content.dart';
import '../../domain/repositories/bookstore_repository.dart';
import '../datasources/bookstore_data_source.dart';

/// data 层仓储实现，仅做数据获取与映射。
/// 依赖抽象 [BookstoreDataSource]：注入 Mock 或 Remote 均可，无需改动本类。
class BookstoreRepositoryImpl implements BookstoreRepository {
  const BookstoreRepositoryImpl(this._dataSource);

  final BookstoreDataSource _dataSource;

  @override
  Future<BookstorePageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
