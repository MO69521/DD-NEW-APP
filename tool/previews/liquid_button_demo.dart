import 'package:diandian_chuanshu/core/theme/app_brand_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_membership_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_spacing.dart';
import 'package:diandian_chuanshu/core/theme/app_text_styles.dart';
import 'package:diandian_chuanshu/features/membership/presentation/components/membership_cta_button.dart';
import 'package:diandian_chuanshu/features/welfare/presentation/components/check_in_cta_button.dart';
import 'package:diandian_chuanshu/shared/widgets/app_text.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LiquidButtonDemoApp());
}

class LiquidButtonDemoApp extends StatelessWidget {
  const LiquidButtonDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _LiquidButtonDemoPage(),
    );
  }
}

class _LiquidButtonDemoPage extends StatelessWidget {
  const _LiquidButtonDemoPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppBrandColors.backgroundDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                '真实 CTA 源头预览',
                style: AppTextStyles.titleMediumDark,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              _PreviewBlock(
                label: 'VIP / 会员付费按钮',
                child: SizedBox(
                  width: 280,
                  child: MembershipCtaButton(
                    child: AppText(
                      '立即开通 VIP',
                      style: AppTextStyles.buttonLabel16.copyWith(
                        color: AppMembershipColors.ctaText,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const _PreviewBlock(
                label: '福利签到按钮',
                child: SizedBox(
                  width: 280,
                  child: CheckInCtaButton(
                    leadingLabel: '立即签到',
                    trailingLabel: '+20能量',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText(
                '以上按钮直接来自真实组件源头：AppGradientCtaButton。',
                style: AppTextStyles.bodyMediumDarkMuted,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewBlock extends StatelessWidget {
  const _PreviewBlock({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          label,
          style: AppTextStyles.labelMediumDark,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        DefaultTextStyle.merge(
          style: AppTextStyles.buttonLabel16.copyWith(
            color: AppMembershipColors.ctaText,
          ),
          child: child,
        ),
      ],
    );
  }
}
