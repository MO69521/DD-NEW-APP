import '../../domain/entities/category_page_content.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_mock_datasource.dart';

/// data 层仓储实现，仅做数据获取与映射。
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._dataSource);

  final CategoryMockDataSource _dataSource;

  @override
  Future<CategoryPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
