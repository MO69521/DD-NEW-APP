import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/edit_nickname_cubit.dart';
import '../../application/edit_nickname_state.dart';
import '../components/account_settings_info_row.dart';
import '../components/account_settings_section.dart';
import '../components/edit_nickname_field.dart';

/// L3 页面 — 修改昵称（深色主题）。
class EditNicknamePage extends StatelessWidget {
  const EditNicknamePage({super.key});

  static const List<String> _rules = [
    '1、每180天可修改一次',
    '2、新昵称要符合注册规范哦，可使用汉字、字母、数字，请在 2-20 个字符内哦（1-10 个中文字符）',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNicknameCubit, EditNicknameState>(
      listenWhen: (previous, current) =>
          !previous.submitted && current.submitted,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('昵称修改已提交')));
        AppRouter.pop();
      },
      child: const _EditNicknameView(),
    );
  }
}

class _EditNicknameView extends StatelessWidget {
  const _EditNicknameView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditNicknameCubit>();
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '修改昵称',
          onBack: AppRouter.pop,
        ),
        body: BlocBuilder<EditNicknameCubit, EditNicknameState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppLayout.chromeTopHeight(context) + AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              children: [
                AccountSettingsSection(
                  title: '昵称设置',
                  children: [
                    AccountSettingsInfoRow(
                      label: '原昵称',
                      value: state.originalNickname,
                      showChevron: false,
                    ),
                    EditNicknameField(
                      label: '新昵称',
                      hintText: '请输入昵称（2-20个字符）',
                      maxLength: EditNicknameState.maxLength,
                      onChanged: cubit.onDraftChanged,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: '确认并提交',
                  variant: state.canSubmit
                      ? AppButtonVariant.accent
                      : AppButtonVariant.secondary,
                  isExpanded: true,
                  onPressed: state.canSubmit ? cubit.submit : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                for (final rule in EditNicknamePage._rules) ...[
                  AppText(
                    rule,
                    // 多行说明文本需宽松行高，避免换行相互挤压。
                    style: AppTextStyles.captionMdDarkMuted.copyWith(
                      height: AppLineHeights.loose,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
