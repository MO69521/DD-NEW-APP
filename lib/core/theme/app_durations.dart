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

  /// 礼花彩带庆祝动效喷发窗口（仅迸发一下，粒子随后自行飘落）。
  static const Duration confettiBurst = Duration(milliseconds: 200);

  /// 通用按压反馈——缩小（被按下）阶段时长。
  static const Duration tapPressDown = Duration(milliseconds: 70);

  /// 通用按压反馈——反弹（overshoot 放大再回落）阶段时长。
  static const Duration tapPressRebound = Duration(milliseconds: 170);

  /// 通用按压反馈——点击后延迟触发动作/跳转的时长，
  /// 用于让「按下 → 反弹」峰值先可见，再执行跳转（跳转会盖住其后的回落）。
  static const Duration tapPressActionDelay = Duration(milliseconds: 150);

  /// 骨架屏高光扫过一轮的时长。
  static const Duration shimmerSweep = Duration(milliseconds: 1200);

  /// 数字滚动（数值变化时从旧值滚到新值）的时长。
  static const Duration numberRoll = Duration(milliseconds: 600);

  /// 跑马灯滚动一轮后、下一轮开始前的静止间隔（滚过一次即停 6 秒再滚）。
  static const Duration marqueeInterval = Duration(seconds: 6);

  /// 讨论区新发评论淡黄高亮停留时长。
  static const Duration discussionNewCommentHighlight = Duration(seconds: 5);

  /// 底栏选中路径动效（相对 Figma 时间轴加速；`yellow_dark` 四 Tab）。
  static const Duration bottomNavSelectMotion = Duration(milliseconds: 700);
}
