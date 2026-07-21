import 'package:diandian_chuanshu/features/welfare/data/datasources/welfare_mock_datasource.dart';
import 'package:diandian_chuanshu/features/welfare/domain/entities/welfare_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('进度到第 4 个节点时节点状态和领取动作保持一致', () async {
    final content = await const WelfareMockDataSource().fetchPageContent();
    final tasks = content.taskListSummary.tasks;

    for (final taskId in ['watch_video', 'reading_duration_reward']) {
      final task = tasks.singleWhere((item) => item.id == taskId);

      expect(task.action.type, WelfareTaskActionType.claimReward);
      expect(task.action.label, '去领取');
      expect(
        task.timelineNodes.take(3).every((node) => node.isReached),
        isTrue,
      );
      expect(task.timelineNodes[3].isActive, isTrue);
      expect(
        task.timelineNodes.skip(4).every((node) => !node.isActive),
        isTrue,
      );
    }
  });
}
