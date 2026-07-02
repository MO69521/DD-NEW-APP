enum SettingsDocumentType {
  userAgreement('user-agreement', '用户协议'),
  privacyPolicy('privacy-policy', '隐私政策'),
  thirdPartySharing('third-party-sharing', '第三方服务共享清单');

  const SettingsDocumentType(this.slug, this.title);

  final String slug;
  final String title;

  static SettingsDocumentType fromSlug(String? slug) {
    return SettingsDocumentType.values.firstWhere(
      (type) => type.slug == slug,
      orElse: () => SettingsDocumentType.userAgreement,
    );
  }
}

class SettingsDocument {
  const SettingsDocument({
    required this.type,
    required this.heading,
    required this.updatedAt,
    required this.sections,
  });

  final SettingsDocumentType type;
  final String heading;
  final String updatedAt;
  final List<SettingsDocumentSection> sections;
}

class SettingsDocumentSection {
  const SettingsDocumentSection({required this.title, required this.body});

  final String title;
  final String body;
}
