import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/features/bookstore/application/bookstore_cubit.dart';
import 'package:diandian_chuanshu/features/bookstore/domain/entities/bookstore_top_tab.dart';
import 'package:diandian_chuanshu/features/bookstore/presentation/pages/bookstore_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('分类和排行 Tab 使用纯白页面背景', (tester) async {
    final cubit = BookstoreCubit();
    await cubit.load();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: BookstorePage(
            categoryTabBuilder: (_) => const SizedBox.expand(),
            rankingTabBuilder: (_) => const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    ColoredBox background() => tester.widget<ColoredBox>(
      find.byKey(const ValueKey('bookstore-tab-background')),
    );

    expect(background().color, AppColors.backgroundDark);

    cubit.switchTopTab(BookstoreTopTab.category);
    await tester.pumpAndSettle();
    expect(background().color, AppColors.categoryRankingPageBackground);

    cubit.switchTopTab(BookstoreTopTab.ranking);
    await tester.pumpAndSettle();
    expect(background().color, AppColors.categoryRankingPageBackground);
  });
}
