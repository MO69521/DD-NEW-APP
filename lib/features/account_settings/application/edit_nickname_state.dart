import 'package:equatable/equatable.dart';

class EditNicknameState extends Equatable {
  const EditNicknameState({
    required this.originalNickname,
    this.draft = '',
    this.submitted = false,
  });

  final String originalNickname;
  final String draft;
  final bool submitted;

  static const int minLength = 2;
  static const int maxLength = 20;

  /// 按 Unicode 码点计数（中文与字母各计 1）。
  int get draftLength => draft.trim().runes.length;

  bool get canSubmit {
    final trimmed = draft.trim();
    final length = trimmed.runes.length;
    return length >= minLength &&
        length <= maxLength &&
        trimmed != originalNickname;
  }

  EditNicknameState copyWith({String? draft, bool? submitted}) {
    return EditNicknameState(
      originalNickname: originalNickname,
      draft: draft ?? this.draft,
      submitted: submitted ?? this.submitted,
    );
  }

  @override
  List<Object?> get props => [originalNickname, draft, submitted];
}
