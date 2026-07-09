import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/app_confetti.dart';
import '../../../../shared/components/dialog_close_button.dart';
import '../../../../shared/components/sweep_highlight_overlay.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'check_in_calendar.dart';
import 'check_in_milestone_progress.dart';
import 'check_in_subtitle.dart';

/// L3 — 签到成功弹窗（Figma 签到成功态）。
///
/// 复用累计里程碑进度 [CheckInMilestoneProgress]、7 日签到日历
/// [CheckInCalendar] 与签到副标题 [CheckInSubtitle]；底部两枚再领取按钮：
/// VIP 领取（粉色渐变 + 扫光 + 呼吸缩放）、看视频领取。
class CheckInSuccessDialog extends StatelessWidget {
  const CheckInSuccessDialog({
    super.key,
    required this.summary,
    this.onVipClaim,
    this.onWatchVideo,
  });

  final CheckInSummary summary;
  final VoidCallback? onVipClaim;
  final VoidCallback? onWatchVideo;

  static Future<void> show(
    BuildContext context, {
    required CheckInSummary summary,
    VoidCallback? onVipClaim,
    VoidCallback? onWatchVideo,
  }) {
    return showAppBlurredDialog<void>(
      context: context,
      builder: (_) => CheckInSuccessDialog(
        summary: summary,
        onVipClaim: onVipClaim,
        onWatchVideo: onWatchVideo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // 覆盖了 backdrop 的点击关闭，这里补回：点卡片外区域关闭。
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Center(child: _buildCard(context)),
          // 礼花彩带庆祝层（顶层，不拦截点击）。
          const Positioned.fill(child: IgnorePointer(child: AppConfetti())),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.dialogBackground,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.borderGlass),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        '签到成功',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textOnDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        '+${summary.todayRewardEnergy}能量',
                        style: AppTextStyles.welfareCurrencyAmount,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      CheckInSubtitle(
                        totalDays: summary.totalDays,
                        daysUntilNextReward: summary.daysUntilNextReward,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      CheckInMilestoneProgress(
                        totalDays: summary.totalDays,
                        milestones: summary.milestones,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      CheckInCalendar(days: summary.weekDays),
                      const SizedBox(height: AppSpacing.lg),
                      _VipRewardButton(
                        label: 'VIP 再领取${summary.vipExtraEnergy}能量',
                        onTap: () {
                          Navigator.of(context).pop();
                          onVipClaim?.call();
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: '看视频 再领${summary.videoExtraStardust}星辰',
                        variant: AppButtonVariant.secondary,
                        isExpanded: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onWatchVideo?.call();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DialogCloseButton(onTap: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

/// VIP 再领取按钮：粉色渐变胶囊 + 扫光高亮 + 呼吸缩放动画。
class _VipRewardButton extends StatefulWidget {
  const _VipRewardButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<_VipRewardButton> createState() => _VipRewardButtonState();
}

class _VipRewardButtonState extends State<_VipRewardButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaBreath,
    )..repeat(reverse: true);
    _breathScale =
        Tween<double>(
          begin: AppSizes.membershipCtaBreathScaleMin,
          end: AppSizes.membershipCtaBreathScaleMax,
        ).animate(
          CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _breathScale,
      child: AppPressable(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppWelfareColors.vipBannerGradientStart,
                  AppWelfareColors.vipBannerGradientEnd,
                ],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned.fill(child: SweepHighlightOverlay()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.buttonPaddingHNormal,
                      vertical: AppSizes.buttonPaddingVNormal,
                    ),
                    child: AppText(
                      widget.label,
                      style: AppTextStyles.buttonLabel16.copyWith(
                        color: AppWelfareColors.vipCtaText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
