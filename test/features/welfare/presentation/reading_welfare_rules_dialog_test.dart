import 'package:diandian_chuanshu/features/welfare/presentation/components/reading_welfare_rules_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('展示完整的 7 日阅读福利活动规则', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ReadingWelfareRulesDialog()),
    );

    expect(find.text('7日福利活动说明'), findsOneWidget);
    expect(find.text('1.活动时间和规则：'), findsOneWidget);
    expect(find.textContaining('每轮活动期间总阅读时长达到4小时'), findsOneWidget);
    expect(find.textContaining('上一轮时长不计入本轮活动中'), findsOneWidget);
    expect(find.text('知道了'), findsOneWidget);
    expect(find.text('活动说明内容待补充'), findsNothing);
  });
}
