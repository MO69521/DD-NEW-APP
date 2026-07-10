import 'package:flutter/widgets.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_text.dart';

/// L1 — 跑马灯文本：文本溢出可用宽度时，先在起点静止对齐
/// [AppDurations.marqueeInterval]（默认 6s），再横向滚动一轮回到起点，循环；
/// 未溢出则静态省略。起步即对齐（左边缘与同列其它文本严格对齐）。
///
/// 适合 now-playing 类窄槽位的长标题（如「继续阅读」书名）。滚动速度 /
/// 间距 / 间隔分别取自 [AppSizes.marqueeSpeed]、[AppSizes.marqueeGap]、
/// [AppDurations.marqueeInterval]。
class AppMarqueeText extends StatefulWidget {
  const AppMarqueeText({
    super.key,
    required this.text,
    this.style,
    this.velocity,
  });

  final String text;
  final TextStyle? style;

  /// 覆盖默认滚动速度（px/s）。
  final double? velocity;

  @override
  State<AppMarqueeText> createState() => _AppMarqueeTextState();
}

class _AppMarqueeTextState extends State<AppMarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? AppTextStyles.bodyLarge;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: 1,
          textDirection: Directionality.of(context),
        )..layout();
        final textWidth = painter.width;
        final textHeight = painter.height;

        if (!maxWidth.isFinite || textWidth <= maxWidth) {
          if (_controller.isAnimating) _controller.stop();
          return AppText(
            widget.text,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        final distance = textWidth + AppSizes.marqueeGap;
        final speed = widget.velocity ?? AppSizes.marqueeSpeed;
        final scrollMs = (distance / speed * 1000).round();
        final total = scrollMs + AppDurations.marqueeInterval.inMilliseconds;
        final totalDuration = Duration(milliseconds: total);

        if (_controller.duration != totalDuration) {
          _controller.duration = totalDuration;
        }
        if (!_controller.isAnimating) {
          _controller.repeat();
        }

        // 先在起点静止 [marqueeInterval]（占 [restFraction]，此时文本左边缘
        // 与同列其它文本严格对齐），再滚动一轮回到起点，无缝循环。
        final restFraction =
            AppDurations.marqueeInterval.inMilliseconds / total;

        return SizedBox(
          height: textHeight,
          // 右缘渐隐（替代硬切）：溢出文本在右侧平滑淡出，滚动时新文本也渐入。
          child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) {
            final stop = bounds.width <= 0
                ? 1.0
                : (1 - (AppSpacing.lg / bounds.width)).clamp(0.0, 1.0);
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                AppColors.white100,
                AppColors.white100,
                AppColors.white00,
              ],
              stops: [0.0, stop, 1.0],
            ).createShader(bounds);
          },
          child: ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value;
              final progress = t <= restFraction
                  ? 0.0
                  : (t - restFraction) / (1 - restFraction);
              return OverflowBox(
                alignment: Alignment.centerLeft,
                maxWidth: double.infinity,
                maxHeight: textHeight,
                child: Transform.translate(
                  offset: Offset(-distance * progress, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(widget.text, style: style, maxLines: 1),
                      const SizedBox(width: AppSizes.marqueeGap),
                      AppText(widget.text, style: style, maxLines: 1),
                    ],
                  ),
                ),
              );
            },
          ),
          ),
          ),
        );
      },
    );
  }
}
