import '../entities/profile_page_content.dart';

abstract class ProfileRepository {
  Future<ProfilePageContent> fetchPageContent();
}
