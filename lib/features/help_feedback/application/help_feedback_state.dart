import 'package:equatable/equatable.dart';

import '../domain/entities/help_feedback_page_content.dart';
import '../domain/entities/help_feedback_tab.dart';

enum HelpFeedbackPhase { loading, loaded, failure }

class HelpFeedbackState extends Equatable {
  const HelpFeedbackState({
    this.phase = HelpFeedbackPhase.loading,
    this.content,
    this.selectedTab = HelpFeedbackTab.faq,
    this.selectedIssueTypeId,
    this.description = '',
    this.bookName = '',
    this.phone = '',
    this.qq = '',
    this.errorMessage,
    this.submitMessage,
  });

  final HelpFeedbackPhase phase;
  final HelpFeedbackPageContent? content;
  final HelpFeedbackTab selectedTab;
  final String? selectedIssueTypeId;
  final String description;
  final String bookName;
  final String phone;
  final String qq;
  final String? errorMessage;
  final String? submitMessage;

  int get descriptionLength => description.length;

  HelpFeedbackState copyWith({
    HelpFeedbackPhase? phase,
    HelpFeedbackPageContent? content,
    HelpFeedbackTab? selectedTab,
    String? selectedIssueTypeId,
    String? description,
    String? bookName,
    String? phone,
    String? qq,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? submitMessage,
    bool clearSubmitMessage = false,
  }) {
    return HelpFeedbackState(
      phase: phase ?? this.phase,
      content: content ?? this.content,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedIssueTypeId: selectedIssueTypeId ?? this.selectedIssueTypeId,
      description: description ?? this.description,
      bookName: bookName ?? this.bookName,
      phone: phone ?? this.phone,
      qq: qq ?? this.qq,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      submitMessage: clearSubmitMessage
          ? null
          : submitMessage ?? this.submitMessage,
    );
  }

  @override
  List<Object?> get props => [
    phase,
    content,
    selectedTab,
    selectedIssueTypeId,
    description,
    bookName,
    phone,
    qq,
    errorMessage,
    submitMessage,
  ];
}
