import '../../../../core/domain/entities/member_account.dart';
import '../entities/membership_benefit_detail.dart';
import '../entities/membership_page_content.dart';

/// 会员页数据仓储抽象。
abstract interface class MembershipRepository {
  Future<MembershipPageContent> fetchPageContent();

  /// 会员权益详情列表（含说明与示例图），用于特权详情页。
  Future<List<MembershipBenefitDetail>> fetchBenefitDetails();

  /// 开通指定套餐（mock），返回更新后的会员账户。
  Future<MemberAccount> purchase(String planId);
}
