import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/member_account.dart';
import 'membership_agreement.dart';
import 'membership_benefit.dart';
import 'membership_hero_slide.dart';
import 'membership_plan.dart';

/// 会员页聚合数据契约。
class MembershipPageContent extends Equatable {
  const MembershipPageContent({
    required this.account,
    required this.heroSlides,
    required this.plans,
    required this.defaultPlanId,
    required this.benefits,
    required this.agreementPrefix,
    required this.agreementSuffix,
    required this.agreements,
    required this.statementTitle,
    required this.statementParagraphs,
  });

  final MemberAccount account;
  final List<MembershipHeroSlide> heroSlides;
  final List<MembershipPlan> plans;
  final String defaultPlanId;
  final List<MembershipBenefit> benefits;

  /// 协议区：前缀（购买即同意）/ 后缀（协议）/ 中间链接。
  final String agreementPrefix;
  final String agreementSuffix;
  final List<MembershipAgreement> agreements;

  /// 自动续费服务声明。
  final String statementTitle;
  final List<String> statementParagraphs;

  @override
  List<Object?> get props => [
    account,
    heroSlides,
    plans,
    defaultPlanId,
    benefits,
    agreementPrefix,
    agreementSuffix,
    agreements,
    statementTitle,
    statementParagraphs,
  ];
}
