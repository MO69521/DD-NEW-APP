import '../../domain/entities/editor_pick_page_content.dart';
import '../../domain/repositories/editor_pick_repository.dart';
import '../datasources/editor_pick_mock_datasource.dart';

/// data 层仓储实现，仅做数据获取与映射。
class EditorPickRepositoryImpl implements EditorPickRepository {
  const EditorPickRepositoryImpl(this._dataSource);

  final EditorPickMockDataSource _dataSource;

  @override
  Future<EditorPickPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
