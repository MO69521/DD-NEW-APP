import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_switch.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/notification_settings_cubit.dart';
import '../../application/notification_settings_state.dart';

/// L3 页面 — 消息通知设置（深色主题）。
class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '消息通知',
          onBack: AppRouter.pop,
        ),
        body: BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
          builder: (context, state) {
            final cubit = context.read<NotificationSettingsCubit>();

            return ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.insetMd,
                AppLayout.chromeTopHeight(context) + AppSpacing.md,
                AppSpacing.insetMd,
                AppSpacing.xl,
              ),
              children: [
                _NotificationSection(
                  children: [
                    _NotificationSwitchRow(
                      title: '接收消息通知',
                      subtitle: '接收消息需手机的 系统设置-通知中心-点点穿书 已打开',
                      value: state.receiveMessages,
                      onChanged: cubit.setReceiveMessages,
                      hasSubtitle: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _NotificationSection(
                  children: [
                    _NotificationSwitchRow(
                      title: '书籍更新通知',
                      value: state.bookUpdates,
                      onChanged: cubit.setBookUpdates,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.borderGlass,
                      indent: AppSpacing.md,
                      endIndent: AppSpacing.md,
                    ),
                    _NotificationSwitchRow(
                      title: '福利领取提醒',
                      value: state.welfareReminders,
                      onChanged: cubit.setWelfareReminders,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(children: children),
    );
  }
}

class _NotificationSwitchRow extends StatelessWidget {
  const _NotificationSwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.hasSubtitle = false,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool hasSubtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: hasSubtitle
              ? AppSizes.settingsNotificationRowWithSubtitleMinHeight
              : AppSizes.settingsNotificationRowMinHeight,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textOnDark,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    AppText(
                      subtitle!,
                      style: AppTextStyles.captionMdDarkMuted,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
