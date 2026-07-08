import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/sweep_highlight_overlay.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/membership_agreement.dart';

/// L3 — 开通区：粉色渐变 CTA + 协议链接。
class MembershipPurchaseBar extends StatelessWidget {
  const MembershipPurchaseBar({
    super.key,
    required this.priceText,
    required this.agreementPrefix,
    required this.agreementSuffix,
    required this.agreements,
    required this.isPurchasing,
    this.onPurchase,
    this.onAgreementTap,
  });

  final String priceText;
  final String agreementPrefix;
  final String agreementSuffix;
  final List<MembershipAgreement> agreements;
  final bool isPurchasing;
  final VoidCallback? onPurchase;
  final ValueChanged<MembershipAgreement>? onAgreementTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GradientCta(
          priceText: priceText,
          isLoading: isPurchasing,
          onTap: onPurchase,
        ),
        const SizedBox(height: AppSpacing.md),
        _AgreementText(
          prefix: agreementPrefix,
          suffix: agreementSuffix,
          agreements: agreements,
          onAgreementTap: onAgreementTap,
        ),
      ],
    );
  }
}

class _GradientCta extends StatefulWidget {
  const _GradientCta({
    required this.priceText,
    required this.isLoading,
    this.onTap,
  });

  final String priceText;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  State<_GradientCta> createState() => _GradientCtaState();
}

class _GradientCtaState extends State<_GradientCta>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaBreath,
    );
    _breathScale = Tween<double>(
      begin: AppSizes.membershipCtaBreathScaleMin,
      end: AppSizes.membershipCtaBreathScaleMax,
    ).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: Curves.easeInOut,
      ),
    );
    _syncAnimations();
  }

  @override
  void didUpdateWidget(covariant _GradientCta oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      _syncAnimations();
    }
  }

  void _syncAnimations() {
    if (widget.isLoading) {
      _breathController
        ..stop()
        ..value = 0;
      return;
    }

    if (!_breathController.isAnimating) {
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxScale = AppSizes.membershipCtaBreathScaleMax;
    final ctaHeight = AppSizes.membershipCtaHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final horizontalInset = maxWidth * (maxScale - 1) / 2;
        final verticalInset = ctaHeight * (maxScale - 1) / 2;
        final innerWidth = maxWidth - horizontalInset * 2;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalInset,
            vertical: verticalInset,
          ),
          child: ScaleTransition(
            scale: _breathScale,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: widget.isLoading ? null : widget.onTap,
              behavior: HitTestBehavior.opaque,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.membershipCta),
                child: SizedBox(
                  width: innerWidth,
                  height: ctaHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppMembershipColors.ctaGradientStart,
                              AppMembershipColors.ctaGradientEnd,
                            ],
                          ),
                        ),
                        child: SizedBox.expand(),
                      ),
                      if (!widget.isLoading)
                        const Positioned.fill(
                          child: SweepHighlightOverlay(
                            highlightColor:
                                AppMembershipColors.ctaSweepHighlight,
                            edgeColor: AppMembershipColors.ctaSweepEdge,
                          ),
                        ),
                      if (widget.isLoading)
                        const SizedBox(
                          width: AppSizes.buttonLoadingIndicatorSize,
                          height: AppSizes.buttonLoadingIndicatorSize,
                          child: CircularProgressIndicator(
                            strokeWidth:
                                AppSizes.bookstoreLoadingIndicatorStrokeWidth,
                            color: AppMembershipColors.ctaText,
                          ),
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AppText(
                              '确认协议并开通',
                              style: AppTextStyles.membershipCtaLabel,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            AppText(
                              '¥',
                              style: AppTextStyles.membershipCtaPriceSymbol,
                            ),
                            const SizedBox(width: AppSpacing.xxsHalf),
                            AppText(
                              widget.priceText,
                              style: AppTextStyles.membershipCtaPriceValue,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AgreementText extends StatelessWidget {
  const _AgreementText({
    required this.prefix,
    required this.suffix,
    required this.agreements,
    this.onAgreementTap,
  });

  final String prefix;
  final String suffix;
  final List<MembershipAgreement> agreements;
  final ValueChanged<MembershipAgreement>? onAgreementTap;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.membershipAgreement.copyWith(
      color: AppColors.textOnDarkMuted,
    );
    final link = AppTextStyles.membershipAgreement.copyWith(
      color: AppMembershipColors.agreementLink,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: AppSpacing.xxs,
      children: [
        AppText(prefix, style: muted),
        for (var i = 0; i < agreements.length; i++) ...[
          if (i > 0) AppText('｜', style: muted),
          GestureDetector(
            onTap: () => onAgreementTap?.call(agreements[i]),
            behavior: HitTestBehavior.opaque,
            child: AppText(agreements[i].title, style: link),
          ),
        ],
        AppText(suffix, style: muted),
      ],
    );
  }
}
