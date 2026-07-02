import 'package:equatable/equatable.dart';

enum CurrencyWalletPhase { loading, loaded, empty }

class CurrencyWalletUiState extends Equatable {
  const CurrencyWalletUiState({
    this.phase = CurrencyWalletPhase.loading,
    this.errorMessage,
    this.feedbackMessage,
  });

  final CurrencyWalletPhase phase;
  final String? errorMessage;
  final String? feedbackMessage;

  CurrencyWalletUiState copyWith({
    CurrencyWalletPhase? phase,
    String? errorMessage,
    String? feedbackMessage,
    bool clearError = false,
    bool clearFeedback = false,
  }) {
    return CurrencyWalletUiState(
      phase: phase ?? this.phase,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      feedbackMessage: clearFeedback
          ? null
          : feedbackMessage ?? this.feedbackMessage,
    );
  }

  @override
  List<Object?> get props => [phase, errorMessage, feedbackMessage];
}
