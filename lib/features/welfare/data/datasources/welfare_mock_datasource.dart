import '../../../../core/constants/currency_mock_data.dart';
import '../../domain/entities/welfare_models.dart';
import '../../domain/entities/welfare_page_content.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class WelfareMockDataSource {
  const WelfareMockDataSource();

  Future<WelfarePageContent> fetchPageContent() async {
    return const WelfarePageContent(
      currencyBalances: CurrencyMockData.welfareBalances,
      vipMonthlyEnergy: _vipMonthlyEnergy,
      vipPriceYuan: _vipPriceYuan,
      rechargePackages: _rechargePackages,
      checkInSummary: _checkInSummary,
      readingWelfareSummary: _readingWelfareSummary,
      mealCheckInSummary: _mealCheckInSummary,
      featuredReadingReward: _featuredReadingReward,
      taskListSummary: _taskListSummary,
    );
  }

  static const int _vipMonthlyEnergy = 1000;
  static const double _vipPriceYuan = 4.9;

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

  static const CheckInSummary _checkInSummary = CheckInSummary(
    totalDays: 9,
    daysUntilNextReward: 6,
    todayRewardEnergy: 20,
    milestones: [
      CheckInMilestone(requiredDays: 15, rewardAmount: 100),
      CheckInMilestone(requiredDays: 22, rewardAmount: 150),
      CheckInMilestone(requiredDays: 30, rewardAmount: 200),
    ],
    weekDays: [
      // 第 1 天：双奖励（能量 + 星尘）
      CheckInDay(
        dayIndex: 1,
        status: CheckInDayStatus.claimed,
        rewards: [
          CheckInReward(type: CheckInRewardType.energy, amount: 40),
          CheckInReward(type: CheckInRewardType.stardust, amount: 500),
        ],
      ),
      // 第 2 天：今日可领，单列宽卡片
      CheckInDay(
        dayIndex: 2,
        status: CheckInDayStatus.today,
        headerLabel: '今日可领',
        rewards: [CheckInReward(type: CheckInRewardType.energy, amount: 30)],
      ),
      CheckInDay(
        dayIndex: 3,
        status: CheckInDayStatus.locked,
        rewards: [
          CheckInReward(type: CheckInRewardType.energy, amount: 40),
          CheckInReward(type: CheckInRewardType.stardust, amount: 500),
        ],
      ),
      CheckInDay(
        dayIndex: 4,
        status: CheckInDayStatus.locked,
        rewards: [CheckInReward(type: CheckInRewardType.energy, amount: 40)],
      ),
      CheckInDay(
        dayIndex: 5,
        status: CheckInDayStatus.locked,
        rewards: [CheckInReward(type: CheckInRewardType.energy, amount: 40)],
      ),
      CheckInDay(
        dayIndex: 6,
        status: CheckInDayStatus.locked,
        rewards: [CheckInReward(type: CheckInRewardType.energy, amount: 40)],
      ),
      // 第 7 天：宽卡，三种奖励（含限免卡）
      CheckInDay(
        dayIndex: 7,
        status: CheckInDayStatus.locked,
        rewards: [
          CheckInReward(type: CheckInRewardType.energy, amount: 40),
          CheckInReward(type: CheckInRewardType.stardust, amount: 500),
          CheckInReward(
            type: CheckInRewardType.freeCard,
            amount: 180,
            label: '180min',
          ),
        ],
      ),
    ],
  );

  static const ReadingWelfareSummary _readingWelfareSummary =
      ReadingWelfareSummary(
        dateRangeText: '4月1日-4月7日',
        targetHours: 5,
        totalReadingMinutes: 120,
        cumulativeDisplayHours: 2,
        minutesUntilNextReward: 60,
        milestones: [
          ReadingWelfareMilestone(
            requiredMinutes: 180,
            rewardAmount: 100,
            label: '能量+40',
          ),
          ReadingWelfareMilestone(
            requiredMinutes: 240,
            rewardAmount: 150,
            label: '能量+40',
          ),
          ReadingWelfareMilestone(
            requiredMinutes: 300,
            rewardAmount: 200,
            label: '能量+40',
          ),
        ],
        weekDays: [
          ReadingWelfareDay(
            dayIndex: 1,
            status: CheckInDayStatus.claimed,
            rewardMinutes: 30,
          ),
          ReadingWelfareDay(
            dayIndex: 2,
            status: CheckInDayStatus.today,
            headerLabel: '今日可领',
            rewardMinutes: 30,
          ),
          ReadingWelfareDay(
            dayIndex: 3,
            status: CheckInDayStatus.locked,
            rewardMinutes: 30,
          ),
          ReadingWelfareDay(
            dayIndex: 4,
            status: CheckInDayStatus.locked,
            rewardMinutes: 30,
          ),
          ReadingWelfareDay(
            dayIndex: 5,
            status: CheckInDayStatus.locked,
            rewardMinutes: 30,
          ),
          ReadingWelfareDay(
            dayIndex: 6,
            status: CheckInDayStatus.locked,
            rewardMinutes: 30,
          ),
          ReadingWelfareDay(
            dayIndex: 7,
            status: CheckInDayStatus.locked,
            rewardMinutes: 30,
          ),
        ],
      );

  static const MealCheckInSummary _mealCheckInSummary = MealCheckInSummary(
    title: '吃饭签到',
    progressLabel: '(2/15)',
    subtitle: '每日多奖励100能量',
    rewardAmount: 100,
  );

  static const WelfareTaskItem _featuredReadingReward = WelfareTaskItem(
    id: 'featured_seven_day_reading',
    layoutType: WelfareTaskLayoutType.timeline,
    title: '7日阅读福利',
    tagLabel: 'VIP翻倍中',
    description: '4月1日-4月7日，阅读时长满5小时，获得选项限免卡',
    action: WelfareTaskAction(type: WelfareTaskActionType.goRead, label: '去阅读'),
    timelineProgress: 0.17,
    timelineBadgeLabel: '1.6',
    timelineNodes: [
      WelfareTaskTimelineNode(
        label: '1小时',
        rewards: [],
        isReached: true,
        isActive: true,
      ),
      WelfareTaskTimelineNode(label: '2小时', rewards: []),
      WelfareTaskTimelineNode(label: '3小时', rewards: []),
      WelfareTaskTimelineNode(label: '4小时', rewards: []),
      WelfareTaskTimelineNode(
        label: '限免卡',
        rewards: [
          WelfareTaskReward(type: CheckInRewardType.freeCard, label: '24h'),
        ],
      ),
    ],
  );

  static const WelfareTaskListSummary _taskListSummary = WelfareTaskListSummary(
    vipEntry: WelfareTaskVipEntry(
      title: '今日福利中心最高可领200能量',
      tagLabel: 'VIP每日能量x2',
      actionLabel: '领取翻倍',
    ),
    tasks: [
      WelfareTaskItem(
        id: 'watch_video',
        layoutType: WelfareTaskLayoutType.timeline,
        title: '看视频得奖励',
        progressLabel: '(2/15)',
        description: '每看完一个即可领取奖励，最多可领5次',
        showPopularIcon: true,
        rewards: [
          WelfareTaskReward(type: CheckInRewardType.energy, label: '12'),
          WelfareTaskReward(type: CheckInRewardType.freeCard, label: '20min'),
        ],
        action: WelfareTaskAction(
          type: WelfareTaskActionType.watchVideo,
          label: '看视频',
          showVideoIcon: true,
        ),
        timelineProgress: 0.58,
        timelineNodes: [
          WelfareTaskTimelineNode(
            label: '已领取',
            rewards: [
              WelfareTaskReward(
                type: CheckInRewardType.stardust,
                label: '20',
                isMuted: true,
              ),
            ],
            isReached: true,
          ),
          WelfareTaskTimelineNode(
            label: '领取',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.energy, label: '40'),
              WelfareTaskReward(type: CheckInRewardType.stardust, label: '800'),
            ],
            isActive: true,
          ),
          WelfareTaskTimelineNode(
            label: '已领取',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.energy, label: '40'),
              WelfareTaskReward(type: CheckInRewardType.stardust, label: '800'),
            ],
            isReached: true,
          ),
          WelfareTaskTimelineNode(
            label: '4次',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.energy, label: '40'),
              WelfareTaskReward(type: CheckInRewardType.stardust, label: '800'),
            ],
          ),
          WelfareTaskTimelineNode(
            label: '5次',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.stardust, label: '20'),
            ],
          ),
          WelfareTaskTimelineNode(
            label: '6次',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.energy, label: '60'),
              WelfareTaskReward(
                type: CheckInRewardType.stardust,
                label: '1000',
              ),
            ],
          ),
          WelfareTaskTimelineNode(
            label: '7次',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.stardust, label: '30'),
            ],
          ),
        ],
      ),
      WelfareTaskItem(
        id: 'reading_duration_reward',
        layoutType: WelfareTaskLayoutType.timeline,
        title: '阅读时长奖励',
        tagLabel: 'VIP翻倍中',
        description: '每日多奖励100能量',
        rewards: [
          WelfareTaskReward(type: CheckInRewardType.energy, label: '100'),
          WelfareTaskReward(type: CheckInRewardType.freeCard, label: '20min'),
        ],
        action: WelfareTaskAction(
          type: WelfareTaskActionType.goRead,
          label: '去阅读',
        ),
        timelineProgress: 0.58,
        timelineNodes: [
          WelfareTaskTimelineNode(
            label: '已领取',
            rewards: [
              WelfareTaskReward(
                type: CheckInRewardType.stardust,
                label: '20',
                isMuted: true,
              ),
            ],
            isReached: true,
          ),
          WelfareTaskTimelineNode(
            label: '已领取',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.energy, label: '40'),
              WelfareTaskReward(type: CheckInRewardType.stardust, label: '800'),
            ],
            isReached: true,
          ),
          WelfareTaskTimelineNode(
            label: '12',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.energy, label: '40'),
              WelfareTaskReward(
                type: CheckInRewardType.stardust,
                label: '1000',
              ),
            ],
            isActive: true,
            showVideoIcon: true,
          ),
          WelfareTaskTimelineNode(
            label: '1800',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.energy, label: '40'),
              WelfareTaskReward(
                type: CheckInRewardType.stardust,
                label: '1800',
              ),
            ],
            showVideoIcon: true,
          ),
          WelfareTaskTimelineNode(
            label: '90分钟',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.stardust, label: '80'),
            ],
          ),
          WelfareTaskTimelineNode(
            label: '120min',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.energy, label: '60'),
              WelfareTaskReward(
                type: CheckInRewardType.stardust,
                label: '2000',
              ),
            ],
          ),
          WelfareTaskTimelineNode(
            label: '240min',
            rewards: [
              WelfareTaskReward(type: CheckInRewardType.freeCard, label: '24h'),
            ],
          ),
        ],
      ),
      WelfareTaskItem(
        id: 'meal_check_in',
        layoutType: WelfareTaskLayoutType.simple,
        title: '吃饭签到',
        progressLabel: '(1/1)',
        description: '吃饭时间来打卡，立即领取能量 ',
        descriptionHighlight: '03:59:50',
        rewards: [
          WelfareTaskReward(type: CheckInRewardType.energy, label: '12'),
        ],
        action: WelfareTaskAction(
          type: WelfareTaskActionType.checkIn,
          label: '去签到',
        ),
      ),
      WelfareTaskItem(
        id: 'sleep_check_in',
        layoutType: WelfareTaskLayoutType.simple,
        title: '睡觉打卡',
        progressLabel: '(1/1)',
        description: '睡前来打卡，立即领取能量，打卡时间',
        descriptionHighlight: '20:24:00',
        rewards: [
          WelfareTaskReward(type: CheckInRewardType.energy, label: '12'),
        ],
        action: WelfareTaskAction(
          type: WelfareTaskActionType.claimReward,
          label: '去领取',
          isPrimary: true,
        ),
      ),
      WelfareTaskItem(
        id: 'open_notification',
        layoutType: WelfareTaskLayoutType.simple,
        title: '打开通知权限',
        progressLabel: '(0/1)',
        description: '开启通知立即领取能量奖励',
        rewards: [
          WelfareTaskReward(type: CheckInRewardType.energy, label: '12'),
          WelfareTaskReward(type: CheckInRewardType.freeCard, label: '20min'),
        ],
        action: WelfareTaskAction(
          type: WelfareTaskActionType.open,
          label: '去开启',
        ),
      ),
      WelfareTaskItem(
        id: 'first_recharge',
        layoutType: WelfareTaskLayoutType.simple,
        title: '首次充值奖励',
        progressLabel: '(0/1)',
        description: '充值任意金额立即领取能量奖励',
        rewards: [
          WelfareTaskReward(type: CheckInRewardType.energy, label: '12'),
        ],
        action: WelfareTaskAction(
          type: WelfareTaskActionType.recharge,
          label: '去充值',
        ),
      ),
      WelfareTaskItem(
        id: 'read_whole_book',
        layoutType: WelfareTaskLayoutType.simple,
        title: '阅读整本书奖励',
        progressLabel: '(0/1)',
        description: '完整阅读任意一本书即可获取奖励',
        rewards: [
          WelfareTaskReward(type: CheckInRewardType.energy, label: '12'),
          WelfareTaskReward(type: CheckInRewardType.freeCard, label: '20min'),
        ],
        action: WelfareTaskAction(
          type: WelfareTaskActionType.goRead,
          label: '去阅读',
        ),
      ),
    ],
  );
}
