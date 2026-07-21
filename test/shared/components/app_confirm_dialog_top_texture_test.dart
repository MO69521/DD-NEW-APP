import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/shared/components/app_confirm_dialog.dart';
import 'package:diandian_chuanshu/shared/components/app_dialog_top_texture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('确认弹窗壳包含顶部彩头层', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppConfirmDialog(title: '删除提示', message: '确认删除吗？'),
      ),
    );

    expect(find.byType(AppDialogTopTexture), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Positioned &&
            widget.height == AppSizes.dialogTopTextureHeight,
      ),
      findsOneWidget,
    );
    // 非 yellow_light 构建下起色为透明，不改变深色/浅粉外观。
    expect(AppColors.dialogTopHeaderGradientEnd, AppColors.white00);
  });
}
