import 'package:equatable/equatable.dart';

import 'help_feedback_issue_type.dart';

/// 帮助与反馈页静态内容。
class HelpFeedbackPageContent extends Equatable {
  const HelpFeedbackPageContent({
    required this.faqGroups,
    required this.issueTypes,
  });

  final List<HelpFeedbackFaqGroup> faqGroups;
  final List<HelpFeedbackIssueType> issueTypes;

  @override
  List<Object?> get props => [faqGroups, issueTypes];
}

class HelpFeedbackFaqGroup extends Equatable {
  const HelpFeedbackFaqGroup({required this.title, required this.questions});

  final String title;
  final List<String> questions;

  @override
  List<Object?> get props => [title, questions];
}
