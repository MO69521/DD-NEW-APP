import 'package:diandian_chuanshu/features/welfare/domain/entities/welfare_models.dart';
import 'package:diandian_chuanshu/features/welfare/presentation/components/meal_check_in_section.dart';
import 'package:diandian_chuanshu/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('VIP领取按钮与内容列顶端对齐', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MealCheckInSection(
            summary: MealCheckInSummary(
              title: 'VIP 签到奖励',
              progressLabel: '(0/1)',
              subtitle: '每日多奖励100能量',
              rewardAmount: 100,
            ),
          ),
        ),
      ),
    );

    final row = tester.widget<Row>(
      find
          .descendant(
            of: find.byType(MealCheckInSection),
            matching: find.byType(Row),
          )
          .first,
    );
    expect(row.crossAxisAlignment, CrossAxisAlignment.start);
    expect(find.byType(AppButton), findsOneWidget);
  });
}
