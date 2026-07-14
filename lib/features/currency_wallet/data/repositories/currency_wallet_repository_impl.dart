import '../../../../core/domain/entities/commerce_entities.dart';
import '../../domain/entities/currency_wallet_page_content.dart';
import '../../domain/repositories/currency_wallet_repository.dart';
import '../datasources/currency_wallet_data_source.dart';

class CurrencyWalletRepositoryImpl implements CurrencyWalletRepository {
  const CurrencyWalletRepositoryImpl(this._dataSource);

  final CurrencyWalletDataSource _dataSource;

  @override
  Future<CurrencyWalletPageContent> fetchPageContent(CurrencyType type) {
    return _dataSource.fetchPageContent(type);
  }
}
