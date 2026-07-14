import '../../domain/entities/help_feedback_page_content.dart';

/// 帮助与反馈数据源抽象。Mock 与 Remote 实现同一契约，
/// Repository 只依赖此接口——接入真实接口时仅替换注入的实现，无需改动上层。
abstract interface class HelpFeedbackDataSource {
  Future<HelpFeedbackPageContent> fetchPageContent();

  /// 提交意见反馈；Phase 2 接入接口，Mock 直接成功返回。
  Future<void> submitFeedback({
    required String? issueTypeId,
    required String description,
    String? bookName,
    String? phone,
    String? qq,
    List<String> screenshotPaths,
  });
}
