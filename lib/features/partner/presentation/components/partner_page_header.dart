import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/app_top_bar_icon_button.dart';
import '../../domain/entities/partner_top_tab.dart';
import 'partner_top_tabs.dart';

/// L3 — 探索页顶栏：探索 / 消息 / 互动同级 Tab + 搜索。
///
/// [AppTopBar] 的「左对齐 Tab + 右侧图标」变体；blur/statusBar 由页面外层负责。
class PartnerPageHeader extends StatelessWidget {
  const PartnerPageHeader({
    super.key,
    required this.selectedTopTab,
    required this.messageUnreadCount,
    this.interactionUnreadCount = 0,
    this.onTopTabSelected,
    this.onSearchTap,
  });

  final PartnerTopTab selectedTopTab;
  final int messageUnreadCount;
  final int interactionUnreadCount;
  final ValueChanged<PartnerTopTab>? onTopTabSelected;
  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      height: AppSizes.partnerHeaderHeight,
      horizontalPadding: AppSpacing.sm,
      chromeBlurEnabled: false,
      leading: PartnerTopTabs(
        selected: selectedTopTab,
        messageUnreadCount: messageUnreadCount,
        interactionUnreadCount: interactionUnreadCount,
        onSelected: onTopTabSelected,
      ),
      trailing: _SearchButton(onTap: onSearchTap),
    );
  }
}

class _SearchButton extends StatefulWidget {
  const _SearchButton({this.onTap});

  final VoidCallback? onTap;

  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AppTopBarIconButton(
        iconAsset: 'assets/icons/search.svg',
        iconWidth: AppSizes.partnerSearchIconSize,
        iconHeight: AppSizes.partnerSearchIconSize,
        iconColor: _pressed
            ? AppPartnerColors.primaryLight
            : AppPartnerColors.iconMuted,
      ),
    );
  }
}
