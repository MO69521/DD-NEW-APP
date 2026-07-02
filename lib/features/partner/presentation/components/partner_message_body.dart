import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../application/partner_cubit.dart';
import '../../application/partner_state.dart';
import '../../domain/entities/partner_conversation.dart';
import 'partner_message_list.dart';

/// L3 — 消息 Tab 主体（会话列表，顶栏下方直接接列表）。
class PartnerMessageBody extends StatelessWidget {
  const PartnerMessageBody({
    super.key,
    required this.onConversationTap,
  });

  static const double _bottomNavReserve =
      AppBottomNav.barHeight + AppSpacing.xl;

  final ValueChanged<PartnerConversation> onConversationTap;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        BlocBuilder<PartnerCubit, PartnerState>(
          buildWhen: (previous, current) =>
              previous.domain.visibleConversations !=
                  current.domain.visibleConversations ||
              previous.ui.isLoadingMore != current.ui.isLoadingMore,
          builder: (context, state) {
            return PartnerMessageList(
              conversations: state.domain.visibleConversations,
              isLoadingMore: state.ui.isLoadingMore,
              onConversationTap: onConversationTap,
            );
          },
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: _bottomNavReserve),
        ),
      ],
    );
  }
}
