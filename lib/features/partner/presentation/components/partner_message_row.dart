import 'package:flutter/material.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/partner_conversation.dart';
import '../../domain/utils/partner_message_timestamp_formatter.dart';
import 'partner_affection_badge.dart';
import 'partner_message_avatar.dart';

/// L3 — 消息 Tab 单行会话。
class PartnerMessageRow extends StatefulWidget {
  const PartnerMessageRow({super.key, required this.conversation, this.onTap});

  final PartnerConversation conversation;
  final VoidCallback? onTap;

  @override
  State<PartnerMessageRow> createState() => _PartnerMessageRowState();
}

class _PartnerMessageRowState extends State<PartnerMessageRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;
    final timestamp = PartnerMessageTimestampFormatter.format(
      conversation.lastMessageAt,
    );

    return GestureDetector(
      onTapDown: widget.onTap == null
          ? null
          : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) => setState(() => _pressed = false),
      onTapCancel: widget.onTap == null
          ? null
          : () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        color: _pressed ? AppPartnerColors.chipPressedOverlay : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PartnerMessageAvatar(
                avatarAsset: conversation.avatarAsset,
                unreadCount: conversation.unreadCount,
              ),
              const SizedBox(width: AppSizes.partnerMessageAvatarToContentGap),
              Expanded(
                child: SizedBox(
                  height: AppSizes.partnerMessageAvatarSize,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: AppSizes.partnerMessageTimestampMinWidth,
                          child: AppText(
                            timestamp,
                            style: AppTextStyles.partnerMessageTimestamp,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right:
                              AppSizes.partnerMessageTimestampMinWidth +
                              AppSpacing.xs,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: AppText(
                                          conversation.characterName,
                                          style: AppTextStyles
                                              .partnerMessageCharacterName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      PartnerAffectionBadge(
                                        level: conversation.affectionLevel,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.partnerMessageNameToPreviewGap,
                            ),
                            AppText(
                              conversation.lastMessagePreview,
                              style: AppTextStyles.partnerMessagePreview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
