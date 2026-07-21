import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../shared/widgets/app_text.dart';

/// 福利任务横幅标题：每 3 秒向上滚动切换一条文案。
class WelfareVipTitleRotator extends StatefulWidget {
  const WelfareVipTitleRotator({
    super.key,
    required this.titles,
    required this.textStyle,
  });

  final List<String> titles;
  final TextStyle textStyle;

  @override
  State<WelfareVipTitleRotator> createState() => _WelfareVipTitleRotatorState();
}

class _WelfareVipTitleRotatorState extends State<WelfareVipTitleRotator> {
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant WelfareVipTitleRotator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.titles != widget.titles) {
      _currentIndex = 0;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.titles.length < 2) return;
    _timer = Timer.periodic(AppDurations.slow * 6, (_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.titles.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.titles.isEmpty) return const SizedBox.shrink();

    final title = widget.titles[_currentIndex];
    final currentKey = ValueKey<String>(title);

    return ClipRect(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // 所有候选文案透明参与布局，让轮播区域始终保持最大文案尺寸，
          // 避免 AnimatedSwitcher 移除旧文案后触发 IntrinsicWidth 跳变。
          for (final sizingTitle in widget.titles)
            Opacity(
              opacity: 0,
              child: AppText(
                sizingTitle,
                style: widget.textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          AnimatedSwitcher(
            duration: AppDurations.normal,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final isIncoming = child.key == currentKey;
              final offset = Tween<Offset>(
                begin: Offset(0, isIncoming ? 1 : -1),
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(position: offset, child: child);
            },
            child: AppText(
              title,
              key: currentKey,
              style: widget.textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
