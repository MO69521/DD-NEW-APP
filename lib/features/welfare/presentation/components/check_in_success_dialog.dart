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
import '../../../../shared/components/app_dialog_top_texture.dart';
import '../../../../shared/components/dialog_close_button.dart';
import '../../../../shared/components/liquid_sweep_cta_clip.dart';
import '../../../../shared/components/sweep_highlight_overlay.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';
import 'check_in_calendar.dart';
import 'check_in_dialog_decor.dart';
import 'check_in_milestone_progress.dart';
import 'check_in_subtitle.dart';

part 'check_in_success_vip_button.dart';

/// L3 — 签到成功弹窗（Figma 签到成功态）。
///
/// 复用累计里程碑进度 [CheckInMilestoneProgress]、7 日签到日历
/// [CheckInCalendar] 与签到副标题 [CheckInSubtitle]；底部两枚再领取按钮：
/// VIP 领取（粉色渐变 + 扫光 + 呼吸缩放）、看视频领取。
/// 面板装饰与每日签到弹窗统一（见 [check_in_dialog_decor.dart]）。
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
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Center(child: _buildCard(context)),
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.dialogBackground,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.borderGlass),
                ),
                child: Stack(
                  children: [
                    const AppDialogTopTexture(),
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.xl,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _EnergyBadge(),
                          const SizedBox(height: AppSpacing.sm),
                          CheckInDialogTitleSparkles(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  '签到成功',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.textOnDark,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                AppText(
                                  '+${summary.todayRewardEnergy}',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.textOnDark,
                                  ),
                                ),
                              ],
                            ),
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
                    const CheckInDialogSideStripes(),
                    const CheckInDialogTopAccent(),
                  ],
                ),
              ),
            ),
          ),
          const CheckInDialogOuterSparkles(),
          Positioned(
            top: AppSpacing.lg,
            right: AppSpacing.lg,
            child: DialogCloseButton(onTap: () => Navigator.of(context).pop()),
          ),
        ],
      ),
    );
  }
}

/// 头部能量图标：纯白 4% 圆底 + 居中能量图标（Figma 1568:2048）。
class _EnergyBadge extends StatelessWidget {
  const _EnergyBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.welfareCheckInSuccessBadgeSize,
      height: AppSizes.welfareCheckInSuccessBadgeSize,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        shape: BoxShape.circle,
      ),
      child: AppAssetImage(
        assetPath: WelfareAssetMapper.checkInMilestoneEnergyIconAsset(),
        width: AppSizes.welfareCheckInSuccessBadgeIconSize,
        height: AppSizes.welfareCheckInSuccessBadgeIconSize,
      ),
    );
  }
}
