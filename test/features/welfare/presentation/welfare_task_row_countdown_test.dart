import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/features/welfare/domain/entities/welfare_models.dart';
import 'package:diandian_chuanshu/features/welfare/presentation/components/welfare_task_row.dart';
import 'package:diandian_chuanshu/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WelfareTaskItem taskWithCountdown(String countdown) {
    return WelfareTaskItem(
      id: 'meal_check_in',
      layoutType: WelfareTaskLayoutType.simple,
      title: '吃饭签到',
      description: '吃饭时间打卡，立即领取能量 ',
      descriptionHighlight: countdown,
      rewards: const [
        WelfareTaskReward(type: CheckInRewardType.energy, label: '12'),
      ],
      action: const WelfareTaskAction(
        type: WelfareTaskActionType.checkIn,
        label: '去签到',
      ),
    );
  }

  testWidgets('倒计时未归零时按钮禁用且文案为暂未开启', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WelfareTaskRow(
            task: taskWithCountdown('00:00:03'),
            onActionTap: (_) => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text(WelfareTaskRow.countdownPendingActionLabel), findsOneWidget);
    expect(find.text('去签到'), findsNothing);

    final button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.onPressed, isNull);
    expect(button.label, WelfareTaskRow.countdownPendingActionLabel);
    expect(AppColors.buttonDisabledFill, isNotNull);

    await tester.tap(find.byType(AppButton), warnIfMissed: false);
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('倒计时归零后恢复可点与原本文案', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WelfareTaskRow(
            task: taskWithCountdown('00:00:01'),
            onActionTap: (_) => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text(WelfareTaskRow.countdownPendingActionLabel), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('去签到'), findsOneWidget);
    expect(find.text(WelfareTaskRow.countdownPendingActionLabel), findsNothing);

    final button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.onPressed, isNotNull);

    button.onPressed!();
    expect(tapped, isTrue);
  });
}
