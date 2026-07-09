import 'package:flutter/widgets.dart';

import '../../core/theme/app_durations.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_text.dart';

/// L1 — 数字滚动文本：数值变化时从旧值平滑滚动到新值。
///
/// 用于余额 / 能量 / 星尘 / 阅读时长等数值展示；首帧不滚动（直接显示初值），
/// 之后每次 [value] 变化都会用 [AppDurations.numberRoll] 时长滚动过渡。
class AnimatedCountText extends StatelessWidget {
  const AnimatedCountText({
    super.key,
    required this.value,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.textAlign,
    this.maxLines,
  });

  final int value;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value.toDouble()),
      duration: AppDurations.numberRoll,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return AppText(
          '$prefix${animatedValue.round()}$suffix',
          style: style ?? AppTextStyles.bodyLarge,
          textAlign: textAlign,
          maxLines: maxLines,
        );
      },
    );
  }
}
