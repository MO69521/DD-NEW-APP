import '../../../../core/domain/entities/member_account.dart';
import '../entities/membership_page_content.dart';

/// 会员页数据仓储抽象。
abstract interface class MembershipRepository {
  Future<MembershipPageContent> fetchPageContent();

  /// 开通指定套餐（mock），返回更新后的会员账户。
  Future<MemberAccount> purchase(String planId);
}
