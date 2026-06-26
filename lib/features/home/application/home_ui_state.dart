import 'package:equatable/equatable.dart';

/// UI 状态：loading / error，与业务数据分离。
class HomeUiState extends Equatable {
  const HomeUiState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  HomeUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
