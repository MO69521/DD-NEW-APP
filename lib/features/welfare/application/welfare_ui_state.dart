import 'package:equatable/equatable.dart';

/// 福利页 UI 状态。
class WelfareUiState extends Equatable {
  const WelfareUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  WelfareUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WelfareUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
