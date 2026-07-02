import '../../domain/entities/currency_wallet_page_content.dart';
import '../../domain/entities/energy_records_page_content.dart';

class EnergyRecordsMockDataSource {
  const EnergyRecordsMockDataSource();

  Future<EnergyRecordsPageContent> fetchPageContent() async {
    return const EnergyRecordsPageContent(
      otherRecords: [
        CurrencyLedgerRecord(
          id: 'welfare_check_in_1',
          title: '福利中心签到任务',
          timeLabel: '2026-06-24 14:38:42',
          amountDelta: 10,
        ),
      ],
    );
  }
}
