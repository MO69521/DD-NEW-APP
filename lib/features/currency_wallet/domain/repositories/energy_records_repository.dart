import '../entities/energy_records_page_content.dart';

abstract interface class EnergyRecordsRepository {
  Future<EnergyRecordsPageContent> fetchPageContent();
}
