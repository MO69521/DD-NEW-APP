import '../../domain/entities/profile_page_content.dart';

/// 个人中心数据源抽象。Mock 与 Remote 实现同一契约，
/// Repository 只依赖此接口——接入真实接口时仅替换注入的实现，无需改动上层。
abstract interface class ProfileDataSource {
  Future<ProfilePageContent> fetchPageContent();
}
