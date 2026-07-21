import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/welfare_models.dart';
import 'welfare_task_action_button.dart';
import 'welfare_task_row.dart';
import 'welfare_task_text_block.dart';

/// L3 — 任务行主区（文案 + 动作）；持有 `HH:MM:SS` 倒计时 tick。
class WelfareTaskPrimaryRow extends StatefulWidget {
  const WelfareTaskPrimaryRow({
    super.key,
    required this.task,
    this.onActionTap,
  });

  final WelfareTaskItem task;
  final ValueChanged<WelfareTaskItem>? onActionTap;

  @override
  State<WelfareTaskPrimaryRow> createState() => _WelfareTaskPrimaryRowState();
}

class _WelfareTaskPrimaryRowState extends State<WelfareTaskPrimaryRow> {
  Timer? _timer;
  Duration? _remaining;

  static final RegExp _countdownPattern = RegExp(r'^\d{2}:\d{2}:\d{2}$');

  bool get _isCountdownPending =>
      _remaining != null && _remaining!.inSeconds > 0;

  @override
  void initState() {
    super.initState();
    _syncCountdown();
  }

  @override
  void didUpdateWidget(covariant WelfareTaskPrimaryRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.descriptionHighlight !=
        widget.task.descriptionHighlight) {
      _syncCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _syncCountdown() {
    _timer?.cancel();
    _remaining = _parseCountdown(widget.task.descriptionHighlight);
    if (_remaining == null || _remaining!.inSeconds <= 0) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = _remaining;
      if (current == null) {
        _timer?.cancel();
        return;
      }
      if (current.inSeconds <= 1) {
        _timer?.cancel();
        setState(() => _remaining = Duration.zero);
        return;
      }
      setState(() {
        _remaining = current - const Duration(seconds: 1);
      });
    });
  }

  Duration? _parseCountdown(String? value) {
    if (value == null || !_countdownPattern.hasMatch(value)) return null;
    final parts = value.split(':').map(int.parse).toList(growable: false);
    return Duration(hours: parts[0], minutes: parts[1], seconds: parts[2]);
  }

  String _formatCountdown(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes
        .remainder(Duration.minutesPerHour)
        .toString()
        .padLeft(2, '0');
    final seconds = duration.inSeconds
        .remainder(Duration.secondsPerMinute)
        .toString()
        .padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final highlight = _remaining == null
        ? widget.task.descriptionHighlight
        : _formatCountdown(_remaining!);
    final action = _isCountdownPending
        ? WelfareTaskAction(
            type: widget.task.action.type,
            label: WelfareTaskRow.countdownPendingActionLabel,
            isPrimary: widget.task.action.isPrimary,
          )
        : widget.task.action;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: WelfareTaskTextBlock(
            task: widget.task,
            descriptionHighlight: highlight,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        WelfareTaskActionButton(
          action: action,
          onTap: _isCountdownPending || widget.onActionTap == null
              ? null
              : () => widget.onActionTap!(widget.task),
        ),
      ],
    );
  }
}
