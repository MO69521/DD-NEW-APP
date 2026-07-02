import 'package:equatable/equatable.dart';

/// 意见反馈问题类型。
class HelpFeedbackIssueType extends Equatable {
  const HelpFeedbackIssueType({required this.id, required this.label});

  final String id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}
