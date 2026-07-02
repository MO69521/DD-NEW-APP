import 'package:equatable/equatable.dart';

import '../domain/entities/currency_wallet_page_content.dart';

class CurrencyWalletDomainState extends Equatable {
  const CurrencyWalletDomainState({this.content});

  final CurrencyWalletPageContent? content;

  CurrencyWalletDomainState copyWith({
    CurrencyWalletPageContent? content,
    bool clearContent = false,
  }) {
    return CurrencyWalletDomainState(
      content: clearContent ? null : content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [content];
}
