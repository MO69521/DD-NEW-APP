import '../../domain/entities/bookshelf_page_content.dart';
import '../../domain/repositories/bookshelf_repository.dart';
import '../datasources/bookshelf_mock_datasource.dart';

class BookshelfRepositoryImpl implements BookshelfRepository {
  const BookshelfRepositoryImpl(this._dataSource);

  final BookshelfMockDataSource _dataSource;

  @override
  Future<BookshelfPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
