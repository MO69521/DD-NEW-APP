import 'package:equatable/equatable.dart';

/// 会员页 UI 状态。
class MembershipUiState extends Equatable {
  const MembershipUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  MembershipUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MembershipUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
