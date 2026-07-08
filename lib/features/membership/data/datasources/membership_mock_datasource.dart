import '../../domain/entities/membership_agreement.dart';
import '../../domain/entities/membership_benefit.dart';
import '../../domain/entities/membership_hero_slide.dart';
import '../../domain/entities/membership_plan.dart';

/// 会员页静态内容 mock 数据源（套餐 / 权益 / 轮播 / 协议 / 声明）。
///
/// 用户账户与 VIP 状态不在此处，由 `core/services` 的共享服务提供。
class MembershipMockDataSource {
  const MembershipMockDataSource();

  static const String _benefitIconBase = 'assets/icons/membership';
  static const String _heroImageBase = 'assets/images/membership';

  List<MembershipHeroSlide> heroSlides() => const [
    MembershipHeroSlide(
      titlePrefix: '每月',
      titleHighlight: '3000',
      titleSuffix: '能量',
      subtitlePrefix: '每天只要',
      subtitleValue: '0.2元',
      imageAsset: '$_heroImageBase/hero_slide_crown.png',
    ),
    MembershipHeroSlide(
      titlePrefix: '阅读',
      titleHighlight: '8.5',
      titleSuffix: '折',
      subtitlePrefix: '全场图书',
      subtitleValue: '享专属折扣',
      imageAsset: '$_heroImageBase/hero_slide_discount.png',
    ),
    MembershipHeroSlide(
      titlePrefix: '签到',
      titleHighlight: '翻倍',
      titleSuffix: '奖励',
      subtitlePrefix: '每日签到',
      subtitleValue: '能量更多',
      imageAsset: '$_heroImageBase/hero_slide_reward.png',
    ),
    MembershipHeroSlide(
      titlePrefix: '会员',
      titleHighlight: '专属服装',
      titleSuffix: '',
      subtitlePrefix: '200+ 会员专属服装',
      subtitleValue: '',
      imageAsset: '$_heroImageBase/hero_slide_identity.png',
    ),
  ];

  List<MembershipPlan> plans() => const [
    MembershipPlan(
      id: 'auto_monthly',
      title: '连续包月首月',
      priceText: '6.80',
      secondaryText: '次月起¥12.0/月',
      cumulativeEnergy: 13710,
      isAutoRenew: true,
      renewHint: '首月仅要4.9元，到期按8.8元自动续费',
      durationDays: 30,
    ),
    MembershipPlan(
      id: 'monthly',
      title: '月卡',
      priceText: '15.0',
      secondaryText: '¥ 30.0',
      cumulativeEnergy: 13710,
      durationDays: 30,
    ),
    MembershipPlan(
      id: 'yearly',
      title: '年卡',
      priceText: '108.0',
      secondaryText: '¥ 256.0',
      cumulativeEnergy: 151060,
      durationDays: 365,
    ),
    MembershipPlan(
      id: 'quarterly',
      title: '季卡',
      priceText: '36.0',
      secondaryText: '¥ 78.0',
      cumulativeEnergy: 39130,
      durationDays: 90,
    ),
  ];

  String defaultPlanId() => 'auto_monthly';

  List<MembershipBenefit> benefits() => const [
    MembershipBenefit(
      id: 'check_in',
      iconAsset: '$_benefitIconBase/benefit_check_in.svg',
      label: '签到奖励',
    ),
    MembershipBenefit(
      id: 'first_recharge',
      iconAsset: '$_benefitIconBase/benefit_first_recharge.svg',
      label: '首充加赠',
    ),
    MembershipBenefit(
      id: 'reading_discount',
      iconAsset: '$_benefitIconBase/benefit_reading_discount.svg',
      label: '阅读85折',
    ),
    MembershipBenefit(
      id: 'costume',
      iconAsset: '$_benefitIconBase/benefit_costume.svg',
      label: '专属服装',
    ),
    MembershipBenefit(
      id: 'theater',
      iconAsset: '$_benefitIconBase/benefit_theater.svg',
      label: '专属小剧场',
    ),
    MembershipBenefit(
      id: 'gold_name',
      iconAsset: '$_benefitIconBase/benefit_gold_name.svg',
      label: '金色昵称',
    ),
    MembershipBenefit(
      id: 'vip_badge',
      iconAsset: '$_benefitIconBase/benefit_vip_badge.svg',
      label: '会员标识',
    ),
  ];

  String agreementPrefix() => '购买即同意';

  String agreementSuffix() => '协议';

  List<MembershipAgreement> agreements() => const [
    MembershipAgreement(title: '《会员条款》', url: 'https://example.com/vip/terms'),
    MembershipAgreement(
      title: '《会员连续订阅说明（EULA）》',
      url: 'https://example.com/vip/eula',
    ),
    MembershipAgreement(title: '《隐私政策》', url: 'https://example.com/vip/privacy'),
  ];

  String statementTitle() => '自动续费服务声明';

  List<String> statementParagraphs() => const [
    '付款：用户确认购买并付款后计入iTunes账户',
    '取消订阅：如需取消订阅，请在当前订阅周期到期24小时以前，手动在iTunes/Apple ID设置管理中关闭自动续订功能',
    '续费：苹果iTunes账户会在到期前24小时内扣费，扣费成功后订阅周期顺延一个订阅周期',
    '自动续费有效期：本服务由您自主选择是否取消，若不选择取消，将为您开通下一个计费周期的会员服务',
  ];
}
