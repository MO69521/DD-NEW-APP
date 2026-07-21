import 'package:diandian_chuanshu/features/category/application/category_cubit.dart';
import 'package:diandian_chuanshu/features/category/presentation/components/category_tab_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('滑出完整筛选区后显示摘要，点击回到顶部', (tester) async {
    final cubit = CategoryCubit();
    await cubit.load();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const CategoryTabBody(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    const summary = '全部 · 全部 · 全部 · 综合';
    expect(find.text(summary), findsNothing);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text(summary), findsOneWidget);

    await tester.tap(find.text(summary));
    await tester.pumpAndSettle();
    expect(find.text(summary), findsNothing);

    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scrollable.position.pixels, 0);
  });
}
