import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../application/settings_cubit.dart';
import '../../application/settings_state.dart';
import '../../domain/entities/settings_page_content.dart';
import '../components/settings_brand_header.dart';
import '../components/settings_logout_confirm_dialog.dart';
import '../components/settings_menu_section.dart';

/// L3 页面 — 设置（深色主题）。
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          previous.ui.actionMessage != current.ui.actionMessage,
      listener: (context, state) {
        final message = state.ui.actionMessage;
        if (message == null) return;
        AppToast.show(context, message);
        context.read<SettingsCubit>().consumeActionMessage();
      },
      builder: (context, state) {
        if (state.ui.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.ui.errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: EmptyState(
              title: '加载失败',
              description: state.ui.errorMessage,
              action: AppButton(
                label: '重试',
                onPressed: () => context.read<SettingsCubit>().load(),
              ),
            ),
          );
        }

        final content = state.domain.content;
        if (content == null) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: EmptyState(title: '暂无数据'),
          );
        }

        return _SettingsView(content: content);
      },
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView({required this.content});

  final SettingsPageContent content;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '设置',
          onBack: AppRouter.pop,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppLayout.chromeTopHeight(context) + AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            SettingsBrandHeader(appVersion: content.appVersion),
            const SizedBox(height: AppSpacing.lg),
            SettingsMenuSection(
              items: content.menuItems,
              onItemTap: cubit.onMenuItemTap,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: '退出登录',
              variant: AppButtonVariant.secondary,
              isExpanded: true,
              isLoading: context.select(
                (SettingsCubit cubit) => cubit.state.ui.isLoggingOut,
              ),
              onPressed: () => _confirmLogout(context, cubit),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: AppPressable(
                onTap: cubit.onDeleteAccountTap,
                child: AppText(
                  '不想用了？注销账号',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnDarkMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: AppText(
                content.icpRecord,
                style: AppTextStyles.captionMdDarkMuted.copyWith(
                  color: AppColors.textOnDarkPlaceholder,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, SettingsCubit cubit) async {
    final confirmed = await showAppBlurredDialog<bool>(
      context: context,
      builder: (_) => const SettingsLogoutConfirmDialog(),
    );
    if (!context.mounted || confirmed != true) return;
    await cubit.onLogoutTap();
  }
}
