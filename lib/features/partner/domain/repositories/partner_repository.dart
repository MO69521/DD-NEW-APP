import '../entities/partner_page_content.dart';

/// 伙伴页仓储契约。
abstract interface class PartnerRepository {
  Future<PartnerPageContent> fetchPageContent();
}
