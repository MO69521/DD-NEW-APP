import 'package:diandian_chuanshu/features/home/application/home_cubit.dart';
import 'package:diandian_chuanshu/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 聚焦冒烟测试：隔离渲染 HomePage（本地数据源，无网络），
  // 避免 pump 整个 App 路由 + 循环动画导致 pumpAndSettle 挂起。
  testWidgets('HomePage 加载后渲染标题与应用名', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => HomeCubit()..load(),
          child: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('点点穿书'), findsOneWidget);
  });
}
