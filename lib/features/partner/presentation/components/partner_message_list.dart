import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state.dart';
import '../../domain/entities/partner_conversation.dart';
import 'partner_message_row.dart';

/// L3 — 消息 Tab 会话列表（Sliver 形态）。
class PartnerMessageList extends StatelessWidget {
  const PartnerMessageList({
    super.key,
    required this.conversations,
    this.isLoadingMore = false,
    this.onConversationTap,
  });

  final List<PartnerConversation> conversations;
  final bool isLoadingMore;
  final ValueChanged<PartnerConversation>? onConversationTap;

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(title: '暂无消息'),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index >= conversations.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(
              child: SizedBox(
                width: AppSizes.partnerLoadingIndicatorSize,
                height: AppSizes.partnerLoadingIndicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.partnerLoadingIndicatorStrokeWidth,
                  color: AppPartnerColors.primary,
                ),
              ),
            ),
          );
        }

        final conversation = conversations[index];
        return PartnerMessageRow(
          conversation: conversation,
          onTap: onConversationTap == null
              ? null
              : () => onConversationTap!(conversation),
        );
      }, childCount: conversations.length + (isLoadingMore ? 1 : 0)),
    );
  }
}
