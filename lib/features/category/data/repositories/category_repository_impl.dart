import '../../domain/entities/category_page_content.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_data_source.dart';

/// data 层仓储实现，仅做数据获取与映射。
/// 依赖抽象 [CategoryDataSource]：注入 Mock 或 Remote 均可，无需改动本类。
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._dataSource);

  final CategoryDataSource _dataSource;

  @override
  Future<CategoryPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
