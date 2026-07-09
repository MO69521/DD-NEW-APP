import 'package:flutter/widgets.dart';

import '../../core/theme/app_durations.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_text.dart';

/// L1 — 跑马灯文本：文本溢出可用宽度时横向循环滚动（首端停顿），否则静态省略。
///
/// 适合 now-playing 类窄槽位的长标题（如「继续阅读」书名）。滚动速度 /
/// 间隔 / 停顿分别取自 [AppSizes.marqueeSpeed]、[AppSizes.marqueeGap]、
/// [AppDurations.marqueePause]。
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
        final total = AppDurations.marqueePause.inMilliseconds + scrollMs;
        final totalDuration = Duration(milliseconds: total);

        if (_controller.duration != totalDuration) {
          _controller.duration = totalDuration;
        }
        if (!_controller.isAnimating) {
          _controller.repeat();
        }

        final pauseFraction =
            AppDurations.marqueePause.inMilliseconds / total;

        return SizedBox(
          height: textHeight,
          child: ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value;
              final progress = t <= pauseFraction
                  ? 0.0
                  : (t - pauseFraction) / (1 - pauseFraction);
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
        );
      },
    );
  }
}
