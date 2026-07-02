import '../../../../core/domain/entities/commerce_entities.dart';
import '../../domain/entities/currency_wallet_page_content.dart';

class CurrencyWalletMockDataSource {
  const CurrencyWalletMockDataSource();

  Future<CurrencyWalletPageContent> fetchPageContent(CurrencyType type) async {
    return switch (type) {
      CurrencyType.energy => _energyContent,
      CurrencyType.wishStar => _wishStarContent,
      CurrencyType.love => _loveContent,
      CurrencyType.stardust => _stardustContent,
    };
  }

  static const List<RechargePackage> _rechargePackages = [
    RechargePackage(
      id: 'rp1',
      energyAmount: 250,
      originalAmount: 200,
      priceYuan: 2,
      illustrationAsset: 'assets/images/welfare/recharge_tier_1.png',
    ),
    RechargePackage(
      id: 'rp2',
      energyAmount: 700,
      originalAmount: 500,
      priceYuan: 15,
      badgeLabel: '热销',
      illustrationAsset: 'assets/images/welfare/recharge_tier_2.png',
    ),
    RechargePackage(
      id: 'rp3',
      energyAmount: 4000,
      originalAmount: 2000,
      priceYuan: 20,
      illustrationAsset: 'assets/images/welfare/recharge_tier_3.png',
    ),
    RechargePackage(
      id: 'rp4',
      energyAmount: 10000,
      originalAmount: 5000,
      priceYuan: 50,
      illustrationAsset: 'assets/images/welfare/recharge_tier_4.png',
    ),
    RechargePackage(
      id: 'rp5',
      energyAmount: 25000,
      originalAmount: 15000,
      priceYuan: 100,
      badgeLabel: '热销',
      illustrationAsset: 'assets/images/welfare/recharge_tier_5.png',
    ),
    RechargePackage(
      id: 'rp6',
      energyAmount: 82800,
      originalAmount: 32800,
      priceYuan: 328,
      illustrationAsset: 'assets/images/welfare/recharge_tier_6.png',
    ),
  ];

  static const CurrencyWalletPageContent _energyContent =
      CurrencyWalletPageContent(
        type: CurrencyType.energy,
        balance: 40,
        rechargePackages: _rechargePackages,
      );

  static const CurrencyWalletPageContent
  _wishStarContent = CurrencyWalletPageContent(
    type: CurrencyType.wishStar,
    balance: 10,
    obtainWays: [
      CurrencyObtainWay(
        id: 'wish',
        title: '祈愿获得',
        actionLabel: '去祈愿',
        action: CurrencyWalletAction.wish,
      ),
      CurrencyObtainWay(
        id: 'shop',
        title: '去商店购买',
        actionLabel: '去看看',
        action: CurrencyWalletAction.viewShop,
      ),
    ],
    infoSections: [
      CurrencyInfoSection(
        title: '祈愿星的用途？',
        body: '可用于单书祈愿池内进行祈愿，每次祈愿消耗10个祈愿星。',
      ),
      CurrencyInfoSection(
        title: '什么是单书祈愿池？',
        body: '可以获得特定作品角色卡的祈愿池为单书祈愿池，单书祈愿池内含SP、SSR、SR、R、N五个等级的角色卡。',
      ),
      CurrencyInfoSection(
        title: '含单书祈愿池的作品有哪些？',
        body:
            '1. 被病娇囚禁后：我混成了团宠\n2. 将军，王妃有喜了\n3. 帝女风华：病娇饲养指南\n4. 顶级囚宠：被五个疯批怪物强占了！\n5. 养鱼手册：长公主她风华绝代',
      ),
    ],
    primaryActionLabel: '去祈愿',
  );

  static const CurrencyWalletPageContent _loveContent =
      CurrencyWalletPageContent(
        type: CurrencyType.love,
        balance: 1,
        obtainWays: [
          CurrencyObtainWay(
            id: 'gift',
            title: '爱心礼包',
            actionLabel: '去查看',
            action: CurrencyWalletAction.viewGift,
          ),
          CurrencyObtainWay(
            id: 'confess',
            title: '表白爱心不足时自动用能量兑换',
            actionLabel: '去表白',
            action: CurrencyWalletAction.confess,
          ),
        ],
        infoSections: [
          CurrencyInfoSection(
            title: '爱心的用途？',
            body: '可用于向喜欢的角色表白或赠送心意，爱心不足时可按规则用能量兑换。',
          ),
          CurrencyInfoSection(
            title: '如何获得爱心？',
            body: '可通过爱心礼包、福利活动和后续表白相关任务获得。',
          ),
        ],
        ledgerRecords: [
          CurrencyLedgerRecord(
            id: 'love_bonus_1',
            title: '惊喜福利获得',
            timeLabel: '2026-06-24 15:22:45',
            amountDelta: 1,
          ),
        ],
        primaryActionLabel: '去表白',
      );

  static const CurrencyWalletPageContent _stardustContent =
      CurrencyWalletPageContent(
        type: CurrencyType.stardust,
        balance: 550,
        stardustOptions: [
          StardustExchangeOption(
            id: 'stardust_5',
            energyAmount: 5,
            stardustCost: 455,
            badgeLabel: '新手福利',
          ),
          StardustExchangeOption(
            id: 'stardust_10',
            energyAmount: 10,
            stardustCost: 910,
          ),
          StardustExchangeOption(
            id: 'stardust_20',
            energyAmount: 20,
            stardustCost: 1820,
          ),
        ],
        ruleDescriptions: [
          '兑换机制：您需要手动将星尘兑换为能量。能量价值根据广告收入波动进行动态调整，实际兑换以档位为准。',
          '星尘有效期：星尘有效期为30个自然日，自获得之日起计算。若未在有效期内使用，星尘将自动失效。',
          '兑换次数：每日仅可兑换一次。',
        ],
        infoSections: [
          CurrencyInfoSection(
            title: '星尘的用途？',
            body: '星尘可在本页兑换为能量，兑换比例以页面展示档位为准。',
          ),
          CurrencyInfoSection(
            title: '星尘有效期',
            body: '星尘有效期为30个自然日，自获得之日起计算。若未在有效期内使用，星尘将自动失效。',
          ),
        ],
        primaryActionLabel: '兑换5能量',
        secondaryActionLabel: '去【福利页】赚更多',
      );
}
