import 'package:diandian_chuanshu/features/welfare/data/datasources/welfare_mock_datasource.dart';
import 'package:diandian_chuanshu/features/welfare/domain/entities/welfare_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('进度到第 4 个节点时节点状态和领取动作保持一致', () async {
    final content = await const WelfareMockDataSource().fetchPageContent();
    final tasks = content.taskListSummary.tasks;

    final watchVideo = tasks.singleWhere((item) => item.id == 'watch_video');
    expect(watchVideo.action.type, WelfareTaskActionType.claimReward);
    expect(watchVideo.action.label, '看视频');
    expect(watchVideo.action.showVideoIcon, isTrue);
    expect(
      watchVideo.timelineNodes.take(3).every((node) => node.isReached),
      isTrue,
    );
    expect(watchVideo.timelineNodes[3].isActive, isTrue);
    expect(
      watchVideo.timelineNodes.skip(4).every((node) => !node.isActive),
      isTrue,
    );

    final reading = tasks.singleWhere(
      (item) => item.id == 'reading_duration_reward',
    );
    expect(reading.action.type, WelfareTaskActionType.claimReward);
    expect(reading.action.label, '去领取');
    expect(reading.action.showVideoIcon, isFalse);
    expect(
      reading.timelineNodes.take(3).every((node) => node.isReached),
      isTrue,
    );
    expect(reading.timelineNodes[3].isActive, isTrue);
    expect(
      reading.timelineNodes.skip(4).every((node) => !node.isActive),
      isTrue,
    );
  });
}
