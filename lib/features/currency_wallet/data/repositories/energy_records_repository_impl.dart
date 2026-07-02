import '../../domain/entities/energy_records_page_content.dart';
import '../../domain/repositories/energy_records_repository.dart';
import '../datasources/energy_records_mock_datasource.dart';

class EnergyRecordsRepositoryImpl implements EnergyRecordsRepository {
  const EnergyRecordsRepositoryImpl(this._dataSource);

  final EnergyRecordsMockDataSource _dataSource;

  @override
  Future<EnergyRecordsPageContent> fetchPageContent() {
    return _dataSource.fetchPageContent();
  }
}
