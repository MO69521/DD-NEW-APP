import 'package:equatable/equatable.dart';

import 'currency_wallet_page_content.dart';

class EnergyRecordsPageContent extends Equatable {
  const EnergyRecordsPageContent({
    this.rechargeRecords = const [],
    this.otherRecords = const [],
  });

  final List<CurrencyLedgerRecord> rechargeRecords;
  final List<CurrencyLedgerRecord> otherRecords;

  @override
  List<Object?> get props => [rechargeRecords, otherRecords];
}
