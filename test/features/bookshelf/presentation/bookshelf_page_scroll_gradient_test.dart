import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/features/bookshelf/presentation/components/bookshelf_page_scroll_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('书架白渐变高度与起止色符合 token，并随滚动位移', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              BookshelfPageScrollGradient(scrollController: controller),
              ListView(
                controller: controller,
                children: List.generate(
                  20,
                  (index) => SizedBox(height: 80, child: Text('item $index')),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final sized = tester.widget<SizedBox>(
      find.descendant(
        of: find.byType(BookshelfPageScrollGradient),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox &&
              widget.height == AppSizes.bookshelfPageGradientHeight,
        ),
      ),
    );
    expect(sized.height, AppSizes.bookshelfPageGradientHeight);
    expect(AppColors.bookshelfPageGradientStart, AppColors.white100);
    expect(AppColors.bookshelfPageGradientEnd, AppColors.white00);
    expect(AppColors.bookshelfPageBackground, AppColors.backgroundDark);

    final before = tester
        .widget<Transform>(
          find.descendant(
            of: find.byType(BookshelfPageScrollGradient),
            matching: find.byType(Transform),
          ),
        )
        .transform;
    expect(before.getTranslation().y, 0);

    await tester.drag(find.byType(ListView), const Offset(0, -120));
    await tester.pumpAndSettle();

    final after = tester
        .widget<Transform>(
          find.descendant(
            of: find.byType(BookshelfPageScrollGradient),
            matching: find.byType(Transform),
          ),
        )
        .transform;
    expect(after.getTranslation().y, -controller.offset);
    expect(controller.offset, greaterThan(0));
  });
}
