import '../../domain/entities/partner_page_content.dart';
import '../../domain/repositories/partner_repository.dart';
import '../datasources/partner_mock_datasource.dart';

/// data 层仓储实现，仅做数据获取与映射。
class PartnerRepositoryImpl implements PartnerRepository {
  const PartnerRepositoryImpl(this._dataSource);

  final PartnerMockDataSource _dataSource;

  @override
  Future<PartnerPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
