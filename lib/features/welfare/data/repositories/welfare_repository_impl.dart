import '../../domain/entities/welfare_page_content.dart';
import '../../domain/repositories/welfare_repository.dart';
import '../datasources/welfare_mock_datasource.dart';

/// data 层仓储实现，仅做数据获取与映射。
class WelfareRepositoryImpl implements WelfareRepository {
  const WelfareRepositoryImpl(this._dataSource);

  final WelfareMockDataSource _dataSource;

  @override
  Future<WelfarePageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
