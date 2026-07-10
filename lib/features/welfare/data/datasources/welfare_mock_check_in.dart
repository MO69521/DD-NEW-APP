part of 'welfare_mock_datasource.dart';

const CheckInSummary _checkInSummary = CheckInSummary(
  totalDays: 9,
  daysUntilNextReward: 6,
  todayRewardEnergy: 20,
  vipExtraEnergy: 1000,
  videoExtraStardust: 500,
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

const ReadingWelfareSummary _readingWelfareSummary = ReadingWelfareSummary(
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

const MealCheckInSummary _mealCheckInSummary = MealCheckInSummary(
  title: 'VIP 签到奖励',
  progressLabel: '(0/1)',
  subtitle: '每日多奖励100能量',
  rewardAmount: 100,
);
