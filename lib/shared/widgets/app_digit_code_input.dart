import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_text.dart';

/// L1 — 分格数字输入，适用于短信验证码、独立密码等短数字代码。
class AppDigitCodeInput extends StatefulWidget {
  const AppDigitCodeInput({
    super.key,
    required this.value,
    required this.onChanged,
    required this.length,
    this.obscureText = false,
    this.autoFocus = true,
  }) : assert(length > 0);

  final String value;
  final ValueChanged<String> onChanged;
  final int length;
  final bool obscureText;
  final bool autoFocus;

  @override
  State<AppDigitCodeInput> createState() => _AppDigitCodeInputState();
}

class _AppDigitCodeInputState extends State<AppDigitCodeInput> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  late final FocusNode _focusNode = FocusNode();
  Timer? _keyboardRetryTimer;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _requestKeyboard();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AppDigitCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == _controller.text) return;
    _controller.text = widget.value;
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _keyboardRetryTimer?.cancel();
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
              return LayoutBuilder(
                builder: (context, constraints) {
                  final totalGap = AppSpacing.xs * (widget.length - 1);
                  final availableBoxSize = constraints.hasBoundedWidth
                      ? (constraints.maxWidth - totalGap) / widget.length
                      : AppSizes.digitCodeBoxMaxSize;
                  final boxSize = math.min(
                    availableBoxSize,
                    AppSizes.digitCodeBoxMaxSize,
                  );

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var index = 0; index < widget.length; index++)
                        SizedBox.square(
                          dimension: boxSize,
                          child: _DigitCodeBox(
                            value: index < code.length ? code[index] : '',
                            isActive:
                                code.length < widget.length &&
                                index == code.length,
                            obscureText: widget.obscureText,
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLength: widget.length,
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
    if (_focusNode.hasFocus) _showKeyboard();
  }

  void _requestKeyboard() {
    if (!_focusNode.hasFocus) _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    WidgetsBinding.instance.addPostFrameCallback((_) => _showKeyboard());
  }

  void _showKeyboard() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    _keyboardRetryTimer?.cancel();
    _keyboardRetryTimer = Timer(AppDurations.keyboardShowRetryDelay, () {
      if (!mounted || !_focusNode.hasFocus) return;
      SystemChannels.textInput.invokeMethod<void>('TextInput.show');
    });
  }
}

class _DigitCodeBox extends StatelessWidget {
  const _DigitCodeBox({
    required this.value,
    required this.isActive,
    required this.obscureText,
  });

  final String value;
  final bool isActive;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.transparent : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isActive
            ? Border.all(
                color: AppColors.primary,
                width: AppSizes.borderWidthEmphasis,
              )
            : null,
      ),
      child: Center(
        child: value.isEmpty && isActive
            ? const _DigitCodeCursor()
            : AppText(
                value.isEmpty ? '' : (obscureText ? '•' : value),
                style: AppTextStyles.titleMediumDark.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
              ),
      ),
    );
  }
}

class _DigitCodeCursor extends StatefulWidget {
  const _DigitCodeCursor();

  @override
  State<_DigitCodeCursor> createState() => _DigitCodeCursorState();
}

class _DigitCodeCursorState extends State<_DigitCodeCursor>
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
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}
