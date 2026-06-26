import 'package:equatable/equatable.dart';

export '../../../../core/domain/entities/commerce_entities.dart';

// ─────────────────────────────────────────────────────────────────────────────
// domain 层：纯 Dart 数据契约，不含 UI / 网络依赖。
// Phase 2 接入 API 时，由 data 层 DTO 映射为这些 entity。
// ─────────────────────────────────────────────────────────────────────────────

/// 签到日卡片状态，驱动不同视觉样式（普通 / 今日高亮 / 已领等）。
enum CheckInDayStatus { locked, today, claimed, expired }

/// 签到奖励类型，决定展示 icon 与文案格式。
enum CheckInRewardType { energy, stardust, freeCard }

/// 单日签到可获得的一项奖励。
class CheckInReward extends Equatable {
  const CheckInReward({required this.type, required this.amount, this.label});

  final CheckInRewardType type;
  final int amount;
  final String? label;

  @override
  List<Object?> get props => [type, amount, label];
}

/// 7 日签到周期中的单日配置。
class CheckInDay extends Equatable {
  const CheckInDay({
    required this.dayIndex,
    required this.status,
    required this.rewards,
    this.headerLabel,
  });

  final int dayIndex;
  final CheckInDayStatus status;
  final List<CheckInReward> rewards;
  final String? headerLabel;

  String get displayLabel => headerLabel ?? '第$dayIndex天';

  @override
  List<Object?> get props => [dayIndex, status, rewards, headerLabel];
}

/// 累计签到里程碑（15 / 22 / 30 天进度条上的气泡奖励）。
class CheckInMilestone extends Equatable {
  const CheckInMilestone({
    required this.requiredDays,
    required this.rewardAmount,
  });

  final int requiredDays;
  final int rewardAmount;

  @override
  List<Object?> get props => [requiredDays, rewardAmount];
}

/// 7 日阅读福利单日配置（Figma 519:8876）。
class ReadingWelfareDay extends Equatable {
  const ReadingWelfareDay({
    required this.dayIndex,
    required this.status,
    required this.rewardMinutes,
    this.headerLabel,
  });

  final int dayIndex;
  final CheckInDayStatus status;
  final int rewardMinutes;
  final String? headerLabel;

  String get displayLabel => headerLabel ?? '第$dayIndex天';

  @override
  List<Object?> get props => [dayIndex, status, rewardMinutes, headerLabel];
}

/// 阅读福利里程碑（进度条气泡奖励）。
class ReadingWelfareMilestone extends Equatable {
  const ReadingWelfareMilestone({
    required this.requiredMinutes,
    required this.rewardAmount,
    required this.label,
  });

  final int requiredMinutes;
  final int rewardAmount;
  final String label;

  CheckInMilestone toCheckInMilestone() => CheckInMilestone(
    requiredDays: requiredMinutes,
    rewardAmount: rewardAmount,
  );

  @override
  List<Object?> get props => [requiredMinutes, rewardAmount, label];
}

/// 7 日阅读福利模块聚合数据，供 [ReadingWelfareSection] 渲染。
class ReadingWelfareSummary extends Equatable {
  const ReadingWelfareSummary({
    required this.dateRangeText,
    required this.targetHours,
    required this.totalReadingMinutes,
    required this.cumulativeDisplayHours,
    required this.minutesUntilNextReward,
    required this.milestones,
    required this.weekDays,
  });

  final String dateRangeText;
  final int targetHours;
  final int totalReadingMinutes;
  final int cumulativeDisplayHours;
  final int minutesUntilNextReward;
  final List<ReadingWelfareMilestone> milestones;
  final List<ReadingWelfareDay> weekDays;

  List<CheckInMilestone> get progressMilestones =>
      milestones.map((m) => m.toCheckInMilestone()).toList();

  List<String> get milestoneLabels => milestones.map((m) => m.label).toList();

  @override
  List<Object?> get props => [
    dateRangeText,
    targetHours,
    totalReadingMinutes,
    cumulativeDisplayHours,
    minutesUntilNextReward,
    milestones,
    weekDays,
  ];
}

/// 签到模块聚合数据，供 [DailyCheckInSection] 一次性渲染。
class CheckInSummary extends Equatable {
  const CheckInSummary({
    required this.totalDays,
    required this.daysUntilNextReward,
    required this.milestones,
    required this.weekDays,
    required this.todayRewardEnergy,
  });

  final int totalDays;
  final int daysUntilNextReward;
  final List<CheckInMilestone> milestones;
  final List<CheckInDay> weekDays;
  final int todayRewardEnergy;

  @override
  List<Object?> get props => [
    totalDays,
    daysUntilNextReward,
    milestones,
    weekDays,
    todayRewardEnergy,
  ];
}

/// 福利任务按钮动作类型。业务跳转后续由 application/presentation 注入处理。
enum WelfareTaskActionType {
  vipClaim,
  watchVideo,
  goRead,
  checkIn,
  claimReward,
  open,
  recharge,
}

/// 福利任务奖励展示项，可复用签到奖励的资源类型。
class WelfareTaskReward extends Equatable {
  const WelfareTaskReward({
    required this.type,
    required this.label,
    this.isMuted = false,
  });

  final CheckInRewardType type;
  final String label;
  final bool isMuted;

  @override
  List<Object?> get props => [type, label, isMuted];
}

/// 福利任务右侧动作按钮。
class WelfareTaskAction extends Equatable {
  const WelfareTaskAction({
    required this.type,
    required this.label,
    this.isPrimary = false,
    this.showVideoIcon = false,
  });

  final WelfareTaskActionType type;
  final String label;
  final bool isPrimary;
  final bool showVideoIcon;

  @override
  List<Object?> get props => [type, label, isPrimary, showVideoIcon];
}

/// 时间轴中的单个节点。
class WelfareTaskTimelineNode extends Equatable {
  const WelfareTaskTimelineNode({
    required this.label,
    required this.rewards,
    this.isReached = false,
    this.isActive = false,
    this.showVideoIcon = false,
  });

  final String label;
  final List<WelfareTaskReward> rewards;
  final bool isReached;
  final bool isActive;
  final bool showVideoIcon;

  @override
  List<Object?> get props => [
    label,
    rewards,
    isReached,
    isActive,
    showVideoIcon,
  ];
}

/// 福利任务行展示形态。
enum WelfareTaskLayoutType { simple, timeline }

/// 福利任务列表中的一项。
class WelfareTaskItem extends Equatable {
  const WelfareTaskItem({
    required this.id,
    required this.layoutType,
    required this.title,
    required this.description,
    required this.action,
    this.progressLabel,
    this.tagLabel,
    this.rewards = const [],
    this.timelineNodes = const [],
    this.timelineProgress = 0,
    this.timelineBadgeLabel,
    this.showPopularIcon = false,
    this.descriptionHighlight,
  });

  final String id;
  final WelfareTaskLayoutType layoutType;
  final String title;

  /// 标题后的进度文案，例如 `(2/15)`、`(0/1)`。
  final String? progressLabel;
  final String description;

  /// 描述末尾高亮片段（如倒计时、打卡时间），橙色展示。
  final String? descriptionHighlight;
  final WelfareTaskAction action;
  final String? tagLabel;
  final List<WelfareTaskReward> rewards;
  final List<WelfareTaskTimelineNode> timelineNodes;
  final double timelineProgress;
  final String? timelineBadgeLabel;
  final bool showPopularIcon;

  @override
  List<Object?> get props => [
    id,
    layoutType,
    title,
    progressLabel,
    description,
    descriptionHighlight,
    action,
    tagLabel,
    rewards,
    timelineNodes,
    timelineProgress,
    timelineBadgeLabel,
    showPopularIcon,
  ];
}

/// 任务列表顶部 VIP 权益入口内容（Figma 559:23235）。
class WelfareTaskVipEntry extends Equatable {
  const WelfareTaskVipEntry({
    required this.title,
    required this.tagLabel,
    required this.actionLabel,
  });

  final String title;
  final String tagLabel;
  final String actionLabel;

  @override
  List<Object?> get props => [title, tagLabel, actionLabel];
}

/// 吃饭签到简行数据（Figma 559:23066）。
class MealCheckInSummary extends Equatable {
  const MealCheckInSummary({
    required this.title,
    required this.progressLabel,
    required this.subtitle,
    required this.rewardAmount,
  });

  final String title;
  final String progressLabel;
  final String subtitle;
  final int rewardAmount;

  @override
  List<Object?> get props => [title, progressLabel, subtitle, rewardAmount];
}

/// 福利页新增任务列表聚合数据。
class WelfareTaskListSummary extends Equatable {
  const WelfareTaskListSummary({required this.vipEntry, required this.tasks});

  final WelfareTaskVipEntry vipEntry;
  final List<WelfareTaskItem> tasks;

  @override
  List<Object?> get props => [vipEntry, tasks];
}
