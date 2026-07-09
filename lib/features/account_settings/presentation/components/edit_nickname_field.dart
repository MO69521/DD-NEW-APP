import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 账号设置「新昵称」输入行：标签 + 单行输入框。
class EditNicknameField extends StatefulWidget {
  const EditNicknameField({
    super.key,
    required this.label,
    required this.hintText,
    required this.maxLength,
    required this.onChanged,
    this.initialValue = '',
  });

  final String label;
  final String hintText;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  State<EditNicknameField> createState() => _EditNicknameFieldState();
}

class _EditNicknameFieldState extends State<EditNicknameField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSizes.listRowMinHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            AppText(
              widget.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textOnDark,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLength: widget.maxLength,
                onChanged: widget.onChanged,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                cursorColor: AppColors.accentYellow,
                style: AppTextStyles.bodyMediumDark,
                decoration: InputDecoration(
                  isCollapsed: true,
                  filled: false,
                  hintText: widget.hintText,
                  hintStyle: AppTextStyles.bodyMediumDarkMuted,
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
