import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/features/welfare/presentation/components/welfare_rules_dialog.dart';
import 'package:diandian_chuanshu/shared/components/app_dialog_top_texture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('规则弹窗顶部使用120px主题渐隐彩头', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelfareRulesDialog()));

    expect(find.byType(AppDialogTopTexture), findsOneWidget);

    final texture = find.byWidgetPredicate(
      (widget) =>
          widget is Positioned &&
          widget.height == AppSizes.dialogTopTextureHeight,
    );
    expect(texture, findsOneWidget);

    final decoration =
        tester
                .widgetList<DecoratedBox>(
                  find.descendant(
                    of: texture,
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .single
                .decoration
            as BoxDecoration;
    final gradient = decoration.gradient! as LinearGradient;
    expect(gradient.colors, const [
      AppColors.dialogTopHeaderGradientStart,
      AppColors.dialogTopHeaderGradientEnd,
    ]);
  });
}
