import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/features/welfare/domain/entities/welfare_models.dart';
import 'package:diandian_chuanshu/features/welfare/presentation/components/welfare_task_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('时间轴底轨和进度线从内容区左边界开始', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelfareTaskTimeline(
          progress: 0.5,
          nodes: [
            WelfareTaskTimelineNode(label: '1次', rewards: []),
            WelfareTaskTimelineNode(label: '2次', rewards: []),
          ],
        ),
      ),
    );

    const lineTop =
        (AppSizes.welfareTaskTimelineProgressHeight -
            AppSizes.welfareTaskTimelineLineHeight) /
        2;
    final leftAlignedLines = find.byWidgetPredicate(
      (widget) =>
          widget is Positioned && widget.left == 0 && widget.top == lineTop,
    );

    expect(leftAlignedLines, findsNWidgets(2));
  });

  testWidgets('时间轴底部文案由节点状态决定', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelfareTaskTimeline(
          progress: 0.5,
          nodes: [
            WelfareTaskTimelineNode(
              label: '12',
              rewards: [],
              isReached: true,
              showVideoIcon: true,
            ),
            WelfareTaskTimelineNode(
              label: '1800',
              rewards: [],
              isActive: true,
              showVideoIcon: true,
            ),
            WelfareTaskTimelineNode(label: '90分钟', rewards: []),
          ],
        ),
      ),
    );

    expect(find.text('已领取'), findsOneWidget);
    expect(find.text('去领取'), findsOneWidget);
    expect(find.text('90分钟'), findsOneWidget);
    expect(find.text('12'), findsNothing);
    expect(find.text('1800'), findsNothing);
    expect(find.byIcon(Icons.play_circle_fill_rounded), findsNothing);
  });
}
