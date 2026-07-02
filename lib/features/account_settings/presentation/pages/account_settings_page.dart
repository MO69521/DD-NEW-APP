import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
        context.read<AccountSettingsCubit>().consumeActionMessage();
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
                onPressed: () => context.read<AccountSettingsCubit>().load(),
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
            AppSpacing.insetMd,
            AppLayout.chromeTopHeight(context) + AppSpacing.md,
            AppSpacing.insetMd,
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
