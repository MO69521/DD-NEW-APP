import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.maxLength,
    this.keyboardType = TextInputType.text,
    this.initialValue = '',
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final int maxLength;
  final TextInputType keyboardType;
  final String initialValue;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );
  late final AnimationController _focusLineController = AnimationController(
    vsync: this,
    duration: AppDurations.normal,
    reverseDuration: AppDurations.normal,
  );
  late final Animation<double> _focusLineAnimation = CurvedAnimation(
    parent: _focusLineController,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant LoginTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_focusNode.hasFocus) return;
    if (widget.initialValue == _controller.text) return;
    _controller.text = widget.initialValue;
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    _controller.dispose();
    _focusLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.helpFeedbackInputMinHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                maxLength: widget.maxLength,
                keyboardType: widget.keyboardType,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: widget.onChanged,
                onTap: _requestKeyboard,
                onTapOutside: (_) => _focusNode.unfocus(),
                cursorColor: AppColors.searchCursor,
                style: AppTextStyles.bodyMediumDark,
                decoration: InputDecoration(
                  filled: false,
                  hintText: widget.hintText,
                  hintStyle: AppTextStyles.bodyMediumDarkMuted.copyWith(
                    color: AppColors.textOnDarkMuted,
                  ),
                  counterText: '',
                  contentPadding: const EdgeInsets.only(
                    top: AppSpacing.sm,
                    right: AppSpacing.xl,
                    bottom: AppSpacing.sm,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _LoginInputBaseLine(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _focusLineAnimation,
                  builder: (context, child) {
                    final isVisible =
                        _focusNode.hasFocus || _focusLineController.value > 0;
                    final lineWidth = isVisible
                        ? AppSizes.borderWidthEmphasis +
                              (constraints.maxWidth -
                                      AppSizes.borderWidthEmphasis) *
                                  _focusLineAnimation.value
                        : 0.0;

                    return Center(
                      child: Container(
                        width: lineWidth,
                        height: AppSizes.borderWidthEmphasis,
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return _ClearInputButton(onTap: _clearText);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleFocusChanged() {
    if (!_focusNode.hasFocus) {
      _focusLineController.reverse();
      return;
    }
    _focusLineController.forward(from: 0);
    _showKeyboard();
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged('');
    _requestKeyboard();
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

class _ClearInputButton extends StatelessWidget {
  const _ClearInputButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: const SizedBox(
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            child: Icon(
              Icons.close_rounded,
              size: AppSizes.iconSm,
              color: AppColors.textOnDarkMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginInputBaseLine extends StatelessWidget {
  const _LoginInputBaseLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.hairline,
      decoration: BoxDecoration(
        color: AppColors.borderGlass,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}
