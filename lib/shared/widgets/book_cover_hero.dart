import 'package:flutter/material.dart';

/// 书封 Hero 统一飞行参数（书卡封面 ↔ 详情头图）。
///
/// - 位置/尺寸：`MaterialRectCenterArcTween`，中心点走弧线，尺寸变化更自然；
/// - 外观：飞行途中在「来源外观」与「目标外观」间 easeInOut 交叉淡入淡出，
///   平滑抹平圆角、描边与裁切比例（竖版封面 ↔ 横版头图）的突变。
///
/// 两端 `Hero` 必须共用同一 `createRectTween` 与 `flightShuttleBuilder`，
/// push / pop 才能对称一致。
RectTween bookCoverHeroRectTween(Rect? begin, Rect? end) {
  return MaterialRectCenterArcTween(begin: begin, end: end);
}

Widget bookCoverHeroFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection direction,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final fromChild = (fromHeroContext.widget as Hero).child;
  final toChild = (toHeroContext.widget as Hero).child;

  return AnimatedBuilder(
    animation: animation,
    builder: (context, _) {
      final t = Curves.easeInOut.transform(animation.value.clamp(0.0, 1.0));
      return Stack(
        fit: StackFit.expand,
        children: [
          Opacity(opacity: 1 - t, child: fromChild),
          Opacity(opacity: t, child: toChild),
        ],
      );
    },
  );
}
