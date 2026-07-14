import '../../domain/entities/help_feedback_page_content.dart';
import '../../domain/repositories/help_feedback_repository.dart';
import '../datasources/help_feedback_data_source.dart';

/// data 层仓储实现，仅做数据获取与提交桥接。
/// 依赖抽象 [HelpFeedbackDataSource]：注入 Mock 或 Remote 均可，无需改动本类。
class HelpFeedbackRepositoryImpl implements HelpFeedbackRepository {
  const HelpFeedbackRepositoryImpl(this._dataSource);

  final HelpFeedbackDataSource _dataSource;

  @override
  Future<HelpFeedbackPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();

  @override
  Future<void> submitFeedback({
    required String? issueTypeId,
    required String description,
    String? bookName,
    String? phone,
    String? qq,
    List<String> screenshotPaths = const [],
  }) => _dataSource.submitFeedback(
    issueTypeId: issueTypeId,
    description: description,
    bookName: bookName,
    phone: phone,
    qq: qq,
    screenshotPaths: screenshotPaths,
  );
}
