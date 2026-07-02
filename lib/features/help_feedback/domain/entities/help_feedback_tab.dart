/// 帮助与反馈页顶部 Tab。
enum HelpFeedbackTab {
  faq,
  feedback;

  String get label => switch (this) {
    HelpFeedbackTab.faq => '常见问题',
    HelpFeedbackTab.feedback => '意见反馈',
  };
}
