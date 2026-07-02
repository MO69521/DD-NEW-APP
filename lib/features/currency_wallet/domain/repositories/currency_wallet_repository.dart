import '../../../../core/domain/entities/commerce_entities.dart';
import '../entities/currency_wallet_page_content.dart';

abstract interface class CurrencyWalletRepository {
  Future<CurrencyWalletPageContent> fetchPageContent(CurrencyType type);
}
