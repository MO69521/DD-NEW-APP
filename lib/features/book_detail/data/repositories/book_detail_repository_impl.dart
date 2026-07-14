import '../../domain/entities/book_detail.dart';
import '../../domain/repositories/book_detail_repository.dart';
import '../datasources/book_detail_data_source.dart';

/// data 层仓储实现，仅做数据获取与映射。
class BookDetailRepositoryImpl implements BookDetailRepository {
  const BookDetailRepositoryImpl(this._dataSource);

  final BookDetailDataSource _dataSource;

  @override
  Future<BookDetail> fetchDetail(String bookId) =>
      _dataSource.fetchDetail(bookId);
}
