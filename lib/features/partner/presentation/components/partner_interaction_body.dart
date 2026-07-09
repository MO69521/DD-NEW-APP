import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../shared/components/empty_state.dart';
import '../../application/partner_cubit.dart';
import '../../application/partner_state.dart';
import 'partner_interaction_page_physics.dart';
import 'partner_interaction_scene_page.dart';

/// L3 — 互动 Tab 竖滑 Feed（PageView）。
class PartnerInteractionBody extends StatefulWidget {
  const PartnerInteractionBody({super.key});

  @override
  State<PartnerInteractionBody> createState() => _PartnerInteractionBodyState();
}

class _PartnerInteractionBodyState extends State<PartnerInteractionBody> {
  PageController? _pageController;
  bool _isPaging = false;
  DateTime? _lastPageTriggerAt;
  Timer? _wheelUnlockTimer;
  bool _isWheelGestureLocked = false;

  /// 手势起始页锚点：拖拽/惯性期间限制最多翻一页（供 [PartnerInteractionPagePhysics]）。
  int? _anchorPage;

  @override
  void dispose() {
    _wheelUnlockTimer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  PageController _ensureController(int initialPage) {
    return _pageController ??= PageController(initialPage: initialPage);
  }

  Duration get _pageTriggerInterval => AppDurations.slow + AppDurations.fast;
  Duration get _wheelUnlockQuietPeriod => AppDurations.slow;

  void _armWheelGestureUnlock() {
    _wheelUnlockTimer?.cancel();
    _wheelUnlockTimer = Timer(_wheelUnlockQuietPeriod, () {
      _isWheelGestureLocked = false;
    });
  }

  Future<void> _animateToAdjacentPage(int delta) async {
    final controller = _pageController;
    if (controller == null || !controller.hasClients || _isPaging) return;

    final now = DateTime.now();
    if (_lastPageTriggerAt != null &&
        now.difference(_lastPageTriggerAt!) < _pageTriggerInterval) {
      return;
    }

    final current = controller.page?.round() ?? 0;
    final scenes = context
        .read<PartnerCubit>()
        .state
        .domain
        .visibleInteractionScenes;
    final target = current + delta;
    if (target < 0 || target >= scenes.length) return;

    _lastPageTriggerAt = now;
    _isPaging = true;
    try {
      await controller.animateToPage(
        target,
        duration: AppDurations.normal,
        curve: Curves.easeOutCubic,
      );
    } finally {
      _isPaging = false;
    }
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || _isPaging) return;

    final dy = event.scrollDelta.dy;
    if (dy.abs() < 1) return;

    _armWheelGestureUnlock();
    if (_isWheelGestureLocked) return;
    _isWheelGestureLocked = true;

    _animateToAdjacentPage(dy > 0 ? 1 : -1);
  }

  /// 拖拽开始记录锚点页、结束清除，使物理层把单次手势限制在 ±1 页。
  bool _handleScrollNotification(ScrollNotification notification) {
    final controller = _pageController;
    if (notification is ScrollStartNotification) {
      if (notification.dragDetails != null &&
          controller != null &&
          controller.hasClients) {
        _anchorPage = controller.page?.round();
      }
    } else if (notification is ScrollEndNotification) {
      _anchorPage = null;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartnerCubit, PartnerState>(
      listenWhen: (previous, current) =>
          previous.interaction.interactionSceneIndex !=
          current.interaction.interactionSceneIndex,
      listener: (context, state) {
        final controller = _pageController;
        if (controller == null || !controller.hasClients || _isPaging) return;
        final target = state.interaction.interactionSceneIndex;
        if (controller.page?.round() != target) {
          controller.animateToPage(
            target,
            duration: AppDurations.fast,
            curve: Curves.easeOutCubic,
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.domain.visibleInteractionScenes !=
              current.domain.visibleInteractionScenes ||
          previous.interaction.interactionSceneIndex !=
              current.interaction.interactionSceneIndex,
      builder: (context, state) {
        final scenes = state.domain.visibleInteractionScenes;
        if (scenes.isEmpty) {
          return const EmptyState(title: '暂无互动场景');
        }

        final controller = _ensureController(
          state.interaction.interactionSceneIndex.clamp(0, scenes.length - 1),
        );

        return Listener(
          onPointerSignal: _handlePointerSignal,
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: SizedBox.expand(
              child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.vertical,
                physics: PartnerInteractionPagePhysics(
                  getGestureAnchorPage: () => _anchorPage,
                ),
                allowImplicitScrolling: false,
                itemCount: scenes.length,
                onPageChanged: context
                    .read<PartnerCubit>()
                    .onInteractionPageChanged,
                itemBuilder: (context, index) {
                  return PartnerInteractionScenePage(scene: scenes[index]);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
