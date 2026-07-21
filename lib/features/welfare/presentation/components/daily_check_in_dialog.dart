import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/app_dialog_top_texture.dart';
import '../../../../shared/components/dialog_close_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'check_in_calendar.dart';
import 'check_in_cta_button.dart';
import 'check_in_dialog_decor.dart';
import 'check_in_milestone_progress.dart';
import 'check_in_subtitle.dart';

/// L3 — 每日签到弹窗（首页首启，新手信息收集后弹出）。
///
/// 内容与「每日签到」区块一致：累计里程碑进度 + 7 日日历 + 立即签到 CTA。
/// 装饰与签到成功弹窗统一：[CheckInDialogTopAccent] / 侧纹 / 外飘星 / 标题星。
/// 遵循弹窗规范：`showAppBlurredDialog`（80% 纯黑遮罩、无背景模糊）、标题
/// `titleMedium`、右上角统一 `DialogCloseButton`（距顶/右 24px）。
/// 点击「立即签到」关闭本弹窗并回调 [onCheckIn]（外层弹出签到成功弹窗）。
class DailyCheckInDialog extends StatelessWidget {
  const DailyCheckInDialog({super.key, required this.summary, this.onCheckIn});

  final CheckInSummary summary;
  final VoidCallback? onCheckIn;

  static Future<void> show(
    BuildContext context, {
    required CheckInSummary summary,
    VoidCallback? onCheckIn,
  }) {
    return showAppBlurredDialog<void>(
      context: context,
      builder: (_) =>
          DailyCheckInDialog(summary: summary, onCheckIn: onCheckIn),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          CheckInDialogTitleSparkles(
                            child: AppText(
                              '每日签到',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.textOnDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
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
                          CheckInCtaButton(
                            leadingLabel: '立即签到',
                            trailingLabel: '+${summary.todayRewardEnergy}能量',
                            onTap: () {
                              Navigator.of(context).pop();
                              onCheckIn?.call();
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
