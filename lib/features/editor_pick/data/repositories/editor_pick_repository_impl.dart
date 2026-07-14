import '../../domain/entities/editor_pick_page_content.dart';
import '../../domain/repositories/editor_pick_repository.dart';
import '../datasources/editor_pick_data_source.dart';

/// data 层仓储实现，仅做数据获取与映射。
/// 依赖抽象 [EditorPickDataSource]：注入 Mock 或 Remote 均可，无需改动本类。
class EditorPickRepositoryImpl implements EditorPickRepository {
  const EditorPickRepositoryImpl(this._dataSource);

  final EditorPickDataSource _dataSource;

  @override
  Future<EditorPickPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
