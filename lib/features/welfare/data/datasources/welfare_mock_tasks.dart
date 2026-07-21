part of 'welfare_mock_datasource.dart';

const WelfareTaskItem _featuredReadingReward = WelfareTaskItem(
  id: 'featured_seven_day_reading',
  layoutType: WelfareTaskLayoutType.timeline,
  title: '7日阅读福利',
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

const WelfareTaskListSummary _taskListSummary = WelfareTaskListSummary(
  vipEntry: WelfareTaskVipEntry(
    titles: ['今日福利中心最高可领200能量', '今日福利中心最高可领1200星辰'],
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
        type: WelfareTaskActionType.claimReward,
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
          label: '已领取',
          rewards: [
            WelfareTaskReward(type: CheckInRewardType.energy, label: '40'),
            WelfareTaskReward(type: CheckInRewardType.stardust, label: '800'),
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
          label: '4次',
          rewards: [
            WelfareTaskReward(type: CheckInRewardType.energy, label: '40'),
            WelfareTaskReward(type: CheckInRewardType.stardust, label: '800'),
          ],
          isActive: true,
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
            WelfareTaskReward(type: CheckInRewardType.stardust, label: '1000'),
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
      description: '每日多奖励100能量',
      rewards: [
        WelfareTaskReward(type: CheckInRewardType.energy, label: '100'),
        WelfareTaskReward(type: CheckInRewardType.freeCard, label: '20min'),
      ],
      action: WelfareTaskAction(
        type: WelfareTaskActionType.claimReward,
        label: '去领取',
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
            WelfareTaskReward(type: CheckInRewardType.stardust, label: '1000'),
          ],
          isReached: true,
          showVideoIcon: true,
        ),
        WelfareTaskTimelineNode(
          label: '1800',
          rewards: [
            WelfareTaskReward(type: CheckInRewardType.energy, label: '40'),
            WelfareTaskReward(type: CheckInRewardType.stardust, label: '1800'),
          ],
          isActive: true,
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
            WelfareTaskReward(type: CheckInRewardType.stardust, label: '2000'),
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
      description: '吃饭时间打卡，立即领取能量 ',
      descriptionHighlight: '03:59:50',
      rewards: [WelfareTaskReward(type: CheckInRewardType.energy, label: '12')],
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
      description: '睡前打卡，立即领取能量，打卡时间',
      descriptionHighlight: '20:24:00',
      rewards: [WelfareTaskReward(type: CheckInRewardType.energy, label: '12')],
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
      action: WelfareTaskAction(type: WelfareTaskActionType.open, label: '去开启'),
    ),
    WelfareTaskItem(
      id: 'first_recharge',
      layoutType: WelfareTaskLayoutType.simple,
      title: '首次充值奖励',
      progressLabel: '(0/1)',
      description: '充值任意金额立即领取能量奖励',
      rewards: [WelfareTaskReward(type: CheckInRewardType.energy, label: '12')],
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
