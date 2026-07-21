import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/welfare_models.dart';
import 'welfare_task_primary_row.dart';
import 'welfare_task_timeline.dart';

/// L3 组件 — 福利任务行，支持简行与时间轴两种形态。
///
/// 描述高亮为 `HH:MM:SS` 倒计时时：未归零按钮禁用文案「暂未开启」；归零后恢复可点。
class WelfareTaskRow extends StatelessWidget {
  const WelfareTaskRow({super.key, required this.task, this.onActionTap});

  final WelfareTaskItem task;
  final ValueChanged<WelfareTaskItem>? onActionTap;

  /// 倒计时未归零时的动作按钮文案。
  static const String countdownPendingActionLabel = '暂未开启';

  @override
  Widget build(BuildContext context) {
    return task.layoutType == WelfareTaskLayoutType.timeline
        ? _TimelineTaskRow(task: task, onActionTap: onActionTap)
        : WelfareTaskPrimaryRow(task: task, onActionTap: onActionTap);
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
        WelfareTaskPrimaryRow(task: task, onActionTap: onActionTap),
        const SizedBox(height: AppSpacing.md),
        WelfareTaskTimeline(
          nodes: task.timelineNodes,
          progress: task.timelineProgress,
        ),
      ],
    );
  }
}
