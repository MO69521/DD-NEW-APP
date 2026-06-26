import 'package:flutter_test/flutter_test.dart';

import 'package:diandian_chuanshu/app.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('点点穿书'), findsOneWidget);
  });
}
