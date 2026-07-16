import 'package:flutter/material.dart';

/// L3 — 互动 Feed 分页物理：以手势起始页为锚，拖拽/惯性均最多翻一页。
class PartnerInteractionPagePhysics extends PageScrollPhysics {
  const PartnerInteractionPagePhysics({
    super.parent,
    this.getGestureAnchorPage,
  });

  final int? Function()? getGestureAnchorPage;

  @override
  PartnerInteractionPagePhysics applyTo(ScrollPhysics? ancestor) {
    return PartnerInteractionPagePhysics(
      parent: buildParent(ancestor),
      getGestureAnchorPage: getGestureAnchorPage,
    );
  }

  @override
  SpringDescription get spring =>
      const SpringDescription(mass: 1, stiffness: 650, damping: 42);

  int _maxPageIndex(ScrollMetrics position) {
    final pageSize = position.viewportDimension;
    if (pageSize <= 0) return 0;
    return (position.maxScrollExtent / pageSize).round();
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    final anchorPage = getGestureAnchorPage?.call();
    if (anchorPage == null) {
      return super.applyPhysicsToUserOffset(position, offset);
    }

    final pageSize = position.viewportDimension;
    if (pageSize <= 0) return offset;

    final maxPage = _maxPageIndex(position);
    final minPage = (anchorPage - 1).clamp(0, maxPage);
    final maxPageAllowed = (anchorPage + 1).clamp(0, maxPage);
    final minPixels = minPage * pageSize;
    final maxPixels = maxPageAllowed * pageSize;

    final proposed = position.pixels - offset;
    final clamped = proposed.clamp(minPixels, maxPixels);
    return position.pixels - clamped;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final pageSize = position.viewportDimension;
    if (pageSize <= 0) {
      return super.createBallisticSimulation(position, velocity);
    }

    final page = position.pixels / pageSize;
    final maxPage = _maxPageIndex(position);
    final anchorPage = (getGestureAnchorPage?.call() ?? page.round()).clamp(
      0,
      maxPage,
    );
    final tol = toleranceFor(position);

    int targetPage;
    if (velocity.abs() < tol.velocity) {
      targetPage = page.round();
    } else {
      targetPage = velocity > 0 ? page.floor() + 1 : page.ceil() - 1;
    }

    if (targetPage > anchorPage + 1) targetPage = anchorPage + 1;
    if (targetPage < anchorPage - 1) targetPage = anchorPage - 1;
    targetPage = targetPage.clamp(0, maxPage);

    final targetPixels = targetPage * pageSize;
    if ((targetPixels - position.pixels).abs() < tol.distance) {
      return null;
    }

    final cappedVelocity = velocity.sign * velocity.abs().clamp(0.0, pageSize);

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      targetPixels,
      cappedVelocity,
      tolerance: tol,
    );
  }
}
