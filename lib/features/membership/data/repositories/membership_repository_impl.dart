import '../../../../core/domain/entities/member_account.dart';
import '../../../../core/services/membership_status_service.dart';
import '../../domain/entities/membership_page_content.dart';
import '../../domain/repositories/membership_repository.dart';
import '../datasources/membership_mock_datasource.dart';

/// 会员仓储实现：静态内容取自 mock 数据源，账户状态取自共享会员服务。
class MembershipRepositoryImpl implements MembershipRepository {
  const MembershipRepositoryImpl(
    this._statusService, [
    this._dataSource = const MembershipMockDataSource(),
  ]);

  final MembershipStatusService _statusService;
  final MembershipMockDataSource _dataSource;

  @override
  Future<MembershipPageContent> fetchPageContent() async {
    final account = await _statusService.fetchAccount();
    return MembershipPageContent(
      account: account,
      heroSlides: _dataSource.heroSlides(),
      plans: _dataSource.plans(),
      defaultPlanId: _dataSource.defaultPlanId(),
      benefits: _dataSource.benefits(),
      agreementPrefix: _dataSource.agreementPrefix(),
      agreementSuffix: _dataSource.agreementSuffix(),
      agreements: _dataSource.agreements(),
      statementTitle: _dataSource.statementTitle(),
      statementParagraphs: _dataSource.statementParagraphs(),
    );
  }

  @override
  Future<MemberAccount> purchase(String planId) async {
    final plan = _dataSource.plans().firstWhere(
      (p) => p.id == planId,
      orElse: () => _dataSource.plans().first,
    );
    return _statusService.activate(period: Duration(days: plan.durationDays));
  }
}
