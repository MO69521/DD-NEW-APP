import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_async_page_body.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../application/account_settings_cubit.dart';
import '../../application/account_settings_state.dart';
import '../../domain/entities/account_settings_page_content.dart';
import '../components/account_settings_info_row.dart';
import '../components/account_settings_section.dart';
import '../components/account_settings_security_row.dart';

/// L3 页面 — 账号设置（深色主题）。
class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
      listenWhen: (previous, current) =>
          previous.ui.actionMessage != current.ui.actionMessage,
      listener: (context, state) {
        final message = state.ui.actionMessage;
        if (message == null) return;
        AppToast.show(context, message);
        context.read<AccountSettingsCubit>().consumeActionMessage();
      },
      builder: (context, state) {
        final content = state.domain.content;
        if (state.ui.isLoading ||
            state.ui.errorMessage != null ||
            content == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: AppAsyncPageBody(
              isLoading: state.ui.isLoading,
              errorMessage: state.ui.errorMessage,
              onRetry: () => context.read<AccountSettingsCubit>().load(),
              isEmpty: content == null,
              child: const SizedBox.shrink(),
            ),
          );
        }

        return _AccountSettingsView(content: content);
      },
    );
  }
}

class _AccountSettingsView extends StatelessWidget {
  const _AccountSettingsView({required this.content});

  final AccountSettingsPageContent content;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AccountSettingsCubit>();
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '账号设置',
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
                AccountSettingsSection(
                  title: '个人信息',
                  children: [
                    AccountSettingsInfoRow(
                      label: '头像',
                      avatarUrl: content.avatarUrl,
                      onTap: cubit.onAvatarTap,
                    ),
                    AccountSettingsInfoRow(
                      label: '昵称',
                      value: content.nickname,
                      onTap: cubit.onNicknameTap,
                    ),
                    AccountSettingsInfoRow(
                      label: '用户 ID',
                      value: content.userId,
                      showChevron: false,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AccountSettingsSection(
                  title: '安全设置',
                  children: [
                    for (final binding in content.securityBindings)
                      AccountSettingsSecurityRow(
                        binding: binding,
                        onTap: () =>
                            cubit.onSecurityBindingTap(binding.type),
                      ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
