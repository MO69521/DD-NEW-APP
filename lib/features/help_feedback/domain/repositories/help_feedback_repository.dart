import '../entities/help_feedback_page_content.dart';

/// 帮助与反馈仓储抽象（domain 契约）。
abstract interface class HelpFeedbackRepository {
  Future<HelpFeedbackPageContent> fetchPageContent();

  /// 提交意见反馈（问题类型 / 描述 / 联系方式 / 截图）。
  Future<void> submitFeedback({
    required String? issueTypeId,
    required String description,
    String? bookName,
    String? phone,
    String? qq,
    List<String> screenshotPaths,
  });
}
