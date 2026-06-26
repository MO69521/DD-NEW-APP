/// 顶栏「探索 / 消息 / 互动」同级切换。
enum PartnerTopTab {
  explore('探索'),
  message('消息'),
  interaction('互动');

  const PartnerTopTab(this.label);

  final String label;
}
