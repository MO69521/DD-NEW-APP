import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'welfare_task_action_button.dart';
import 'welfare_task_reward_chip.dart';
import 'welfare_task_timeline.dart';
import 'welfare_vip_badge.dart';

/// L3 组件 — 福利任务行，支持简行与时间轴两种形态。
class WelfareTaskRow extends StatelessWidget {
  const WelfareTaskRow({super.key, required this.task, this.onActionTap});

  final WelfareTaskItem task;
  final ValueChanged<WelfareTaskItem>? onActionTap;

  @override
  Widget build(BuildContext context) {
    return task.layoutType == WelfareTaskLayoutType.timeline
        ? _TimelineTaskRow(task: task, onActionTap: onActionTap)
        : _SimpleTaskRow(task: task, onActionTap: onActionTap);
  }
}

class _SimpleTaskRow extends StatelessWidget {
  const _SimpleTaskRow({required this.task, this.onActionTap});

  final WelfareTaskItem task;
  final ValueChanged<WelfareTaskItem>? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _TaskTextBlock(task: task)),
        const SizedBox(width: AppSpacing.sm),
        WelfareTaskActionButton(
          action: task.action,
          onTap: onActionTap == null ? null : () => onActionTap!(task),
        ),
      ],
    );
  }
}

class _TimelineTaskRow extends StatelessWidget {
  const _TimelineTaskRow({required this.task, this.onActionTap});

  final WelfareTaskItem task;
  final ValueChanged<WelfareTaskItem>? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _TaskTextBlock(task: task)),
            const SizedBox(width: AppSpacing.sm),
            WelfareTaskActionButton(
              action: task.action,
              onTap: onActionTap == null ? null : () => onActionTap!(task),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        WelfareTaskTimeline(
          nodes: task.timelineNodes,
          progress: task.timelineProgress,
        ),
      ],
    );
  }
}

class _TaskTextBlock extends StatelessWidget {
  const _TaskTextBlock({required this.task});

  final WelfareTaskItem task;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.showPopularIcon) ...[
              _PopularIcon(),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: AppText(
                task.title,
                style: AppTextStyles.welfareSectionTitle.copyWith(
                  color: AppColors.textOnDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (task.progressLabel != null) ...[
              const SizedBox(width: AppSpacing.xs),
              AppText(
                task.progressLabel!,
                style: AppTextStyles.welfareTaskProgressLabel.copyWith(
                  color: AppWelfareColors.taskProgressLabel,
                ),
              ),
            ],
            if (task.tagLabel != null) ...[
              const SizedBox(width: AppSpacing.xs),
              WelfareVipBadge(label: task.tagLabel!),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _TaskDescription(
          description: task.description,
          highlight: task.descriptionHighlight,
        ),
        if (task.rewards.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final reward in task.rewards)
                WelfareTaskRewardChip(
                  reward: reward,
                  variant: WelfareTaskRewardChipVariant.surface,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PopularIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.welfareTaskPopularIconSize,
      height: AppSizes.welfareTaskPopularIconSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppWelfareColors.taskPopularGradientStart,
            AppWelfareColors.taskPopularGradientEnd,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.local_fire_department,
          size: AppSizes.welfareTaskRewardIconSize,
          color: AppColors.textOnDark,
        ),
      ),
    );
  }
}

class _TaskDescription extends StatefulWidget {
  const _TaskDescription({required this.description, this.highlight});

  final String description;
  final String? highlight;

  @override
  State<_TaskDescription> createState() => _TaskDescriptionState();
}

class _TaskDescriptionState extends State<_TaskDescription> {
  Timer? _timer;
  Duration? _remaining;

  static final RegExp _countdownPattern = RegExp(r'^\d{2}:\d{2}:\d{2}$');

  @override
  void initState() {
    super.initState();
    _syncCountdown();
  }

  @override
  void didUpdateWidget(covariant _TaskDescription oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.highlight != widget.highlight) {
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
    _remaining = _parseCountdown(widget.highlight);
    if (_remaining == null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = _remaining;
      if (current == null || current.inSeconds <= 0) {
        _timer?.cancel();
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
        ? widget.highlight
        : _formatCountdown(_remaining!);

    if (highlight == null || highlight.isEmpty) {
      return AppText(
        widget.description,
        style: AppTextStyles.welfareSubtitle.copyWith(
          color: AppWelfareColors.subtitleMuted,
          height: 1.0,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text.rich(
      TextSpan(
        style: AppTextStyles.welfareSubtitle.copyWith(
          color: AppWelfareColors.subtitleMuted,
          height: 1.45,
        ),
        children: [
          TextSpan(text: widget.description),
          TextSpan(
            text: highlight,
            style: AppTextStyles.welfareSubtitle.copyWith(
              color: AppWelfareColors.taskTimelineFill,
              height: 1.45,
            ),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
