/// 角色收集状态。
enum PartnerCollectionStatus {
  collected('已收集'),
  uncollected('未收集');

  const PartnerCollectionStatus(this.label);

  final String label;
}
