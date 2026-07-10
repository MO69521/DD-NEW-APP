import 'package:equatable/equatable.dart';

/// 福利页 UI 状态。
class WelfareUiState extends Equatable {
  const WelfareUiState({
    this.isLoading = false,
    this.errorMessage,
    this.hasCheckedInToday = false,
  });

  final bool isLoading;
  final String? errorMessage;

  /// 今日是否已签到；为 true 时签到按钮切换为「看视频再领星辰」，一天仅可签到一次。
  final bool hasCheckedInToday;

  WelfareUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? hasCheckedInToday,
  }) {
    return WelfareUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      hasCheckedInToday: hasCheckedInToday ?? this.hasCheckedInToday,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, hasCheckedInToday];
}
