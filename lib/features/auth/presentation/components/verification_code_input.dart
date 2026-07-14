import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// 短信验证码输入：隐藏 TextField 承接输入，上层渲染分格光标框。
class VerificationCodeInput extends StatefulWidget {
  const VerificationCodeInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _requestKeyboard();
    });
  }

  @override
  void didUpdateWidget(covariant VerificationCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == _controller.text) return;
    _controller.text = widget.value;
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _requestKeyboard,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, textEditingValue, child) {
              final code = textEditingValue.text;
              return Row(
                children: [
                  for (
                    var index = 0;
                    index < AppConstants.smsCodeLength;
                    index++
                  ) ...[
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _VerificationCodeBox(
                          value: index < code.length ? code[index] : '',
                          isActive: index == code.length,
                        ),
                      ),
                    ),
                    if (index < AppConstants.smsCodeLength - 1)
                      const SizedBox(width: AppSpacing.xs),
                  ],
                ],
              );
            },
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLength: AppConstants.smsCodeLength,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: widget.onChanged,
                onTapOutside: (_) => _focusNode.unfocus(),
                decoration: const InputDecoration(counterText: ''),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFocusChanged() {
    if (!_focusNode.hasFocus) return;
    _showKeyboard();
  }

  void _requestKeyboard() {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    WidgetsBinding.instance.addPostFrameCallback((_) => _showKeyboard());
  }

  Future<void> _showKeyboard() async {
    await SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    await Future<void>.delayed(AppDurations.keyboardShowRetryDelay);
    if (!mounted || !_focusNode.hasFocus) return;
    await SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }
}

class _VerificationCodeBox extends StatelessWidget {
  const _VerificationCodeBox({required this.value, required this.isActive});

  final String value;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.transparent : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isActive
            ? Border.all(
                color: AppColors.accentYellow,
                width: AppSizes.borderWidthEmphasis,
              )
            : null,
      ),
      child: Center(
        child: value.isEmpty && isActive
            ? const _VerificationCursor()
            : AppText(value, style: AppTextStyles.titleMediumDark, maxLines: 1),
      ),
    );
  }
}

class _VerificationCursor extends StatefulWidget {
  const _VerificationCursor();

  @override
  State<_VerificationCursor> createState() => _VerificationCursorState();
}

class _VerificationCursorState extends State<_VerificationCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.normal,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: AppSizes.borderWidthEmphasis,
        height: AppSpacing.lg,
        decoration: BoxDecoration(
          color: AppColors.accentYellow,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}
