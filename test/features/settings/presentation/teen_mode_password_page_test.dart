import 'package:diandian_chuanshu/features/settings/presentation/pages/teen_mode_password_page.dart';
import 'package:diandian_chuanshu/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('4 位密码输满前禁用确定按钮，输满后启用并显示掩码', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TeenModePasswordPage()));
    await tester.pump();

    AppButton confirmButton() =>
        tester.widget<AppButton>(find.widgetWithText(AppButton, '确定'));

    expect(confirmButton().onPressed, isNull);

    await tester.enterText(find.byType(TextField), '123');
    await tester.pump();
    expect(confirmButton().onPressed, isNull);
    expect(find.text('•'), findsNWidgets(3));

    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();
    expect(confirmButton().onPressed, isNotNull);
    expect(find.text('•'), findsNWidgets(4));
  });
}
