import 'package:diandian_chuanshu/core/theme/app_welfare_colors.dart';
import 'package:diandian_chuanshu/features/welfare/domain/entities/welfare_models.dart';
import 'package:diandian_chuanshu/features/welfare/presentation/components/reading_vip_progress_section.dart';
import 'package:diandian_chuanshu/features/welfare/presentation/components/welfare_reward_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('七日阅读进度数值气泡使用橙色底', (tester) async {
    const task = WelfareTaskItem(
      id: 'reading',
      layoutType: WelfareTaskLayoutType.timeline,
      title: '7日阅读福利',
      description: '阅读满5小时获得限免卡',
      action: WelfareTaskAction(
        type: WelfareTaskActionType.goRead,
        label: '去阅读',
      ),
      timelineProgress: 0.17,
      timelineBadgeLabel: '1.6',
      timelineNodes: [
        WelfareTaskTimelineNode(label: '1小时', rewards: []),
        WelfareTaskTimelineNode(label: '2小时', rewards: []),
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ReadingVipProgressSection(task: task, onInfoTap: _noop),
        ),
      ),
    );

    final bubble = tester.widget<WelfareRewardBubble>(
      find.byType(WelfareRewardBubble),
    );
    final badgeTransform = tester.widget<Transform>(
      find.ancestor(
        of: find.byType(WelfareRewardBubble),
        matching: find.byType(Transform),
      ),
    );
    expect(bubble.background, AppWelfareColors.taskTimelineFill);
    expect(badgeTransform.transform.getTranslation().y, -2);
    expect(find.text('1.6'), findsOneWidget);
  });
}

void _noop() {}
