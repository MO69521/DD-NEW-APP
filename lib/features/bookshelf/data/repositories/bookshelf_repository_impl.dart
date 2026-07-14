import '../../domain/entities/bookshelf_page_content.dart';
import '../../domain/repositories/bookshelf_repository.dart';
import '../datasources/bookshelf_data_source.dart';

/// 依赖抽象 [BookshelfDataSource]：注入 Mock 或 Remote 均可，无需改动本类。
class BookshelfRepositoryImpl implements BookshelfRepository {
  const BookshelfRepositoryImpl(this._dataSource);

  final BookshelfDataSource _dataSource;

  @override
  Future<BookshelfPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
