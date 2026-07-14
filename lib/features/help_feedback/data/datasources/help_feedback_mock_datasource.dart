import '../../domain/entities/help_feedback_issue_type.dart';
import '../../domain/entities/help_feedback_page_content.dart';
import 'help_feedback_data_source.dart';

/// 帮助与反馈 Mock 数据源；真实接口实现请照 bookstore/search 范例补 remote datasource。
class HelpFeedbackMockDataSource implements HelpFeedbackDataSource {
  const HelpFeedbackMockDataSource();

  @override
  Future<void> submitFeedback({
    required String? issueTypeId,
    required String description,
    String? bookName,
    String? phone,
    String? qq,
    List<String> screenshotPaths = const [],
  }) async {
    // Mock：直接成功返回；Phase 2 由 remote datasource POST 到后端。
  }

  @override
  Future<HelpFeedbackPageContent> fetchPageContent() async {
    return const HelpFeedbackPageContent(
      issueTypes: [
        HelpFeedbackIssueType(id: 'content', label: '作品和内容问题'),
        HelpFeedbackIssueType(id: 'energy_ad', label: '能量或广告问题'),
        HelpFeedbackIssueType(id: 'account', label: '账号问题'),
        HelpFeedbackIssueType(id: 'activity', label: '活动问题'),
        HelpFeedbackIssueType(id: 'feature', label: '功能问题'),
        HelpFeedbackIssueType(id: 'suggestion', label: '其他优化建议'),
      ],
      faqGroups: [
        HelpFeedbackFaqGroup(title: '登录问题', questions: ['登录方式', '如何退出当前账号']),
        HelpFeedbackFaqGroup(
          title: '账号问题',
          questions: [
            '什么是《点点穿书》账号',
            '账号异常',
            '如何解除账号异常',
            '如何查看自己ID',
            '如何注销账号',
            'QQ或微信绑定账号问题',
            '如何解绑QQ号或微信号',
          ],
        ),
        HelpFeedbackFaqGroup(title: '阅读问题', questions: ['立绘或背景图加载异常']),
        HelpFeedbackFaqGroup(title: '广告问题', questions: ['广告充值', '广告内容反馈']),
        HelpFeedbackFaqGroup(
          title: '虚拟能量',
          questions: [
            '什么是虚拟能量',
            '获取虚拟能量',
            '未成年人获取虚拟能量',
            '虚拟能量退费',
            '未成年人虚拟能量退费',
            '虚拟能量使用规则',
            '开具发票',
          ],
        ),
        HelpFeedbackFaqGroup(
          title: '《点点穿书》内容公约',
          questions: [
            '内容管理',
            '内容价值观',
            '内容基本遵守原则',
            '《点点穿书》不良信息处置原则和方式',
            '不良信息投诉方式',
            '作品交流群说明',
            '作品涉嫌抄袭的投诉指引',
          ],
        ),
      ],
    );
  }
}
