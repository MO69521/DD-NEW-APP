/// 全局动画时长 token。
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration splashHold = Duration(milliseconds: 1600);
  static const Duration keyboardShowRetryDelay = Duration(milliseconds: 80);

  /// 轻提示 Toast 停留时长（不含淡入淡出）。
  static const Duration toastVisible = Duration(milliseconds: 1500);

  /// 容器转换（卡片放大为全屏）转场时长，兼顾丝滑与不拖沓。
  static const Duration containerTransform = Duration(milliseconds: 450);

  /// 会员页开通 CTA 呼吸动画单周期（放大 + 缩小）。
  static const Duration membershipCtaBreath = Duration(milliseconds: 1400);

  /// 会员页开通 CTA 扫光动画单周期（左 → 右）。
  static const Duration membershipCtaSweep = Duration(milliseconds: 2200);
}
