import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/book_discussion_detail_cubit.dart';
import '../../application/book_discussion_detail_state.dart';
import '../../domain/entities/book_discussion_post.dart';
import '../components/book_discussion_detail_content.dart';
import '../components/book_discussion_reply_input_bar.dart';

/// 书评详情页：展示主贴与全部回复。
class BookDiscussionDetailPage extends StatelessWidget {
  const BookDiscussionDetailPage({super.key, required this.post});

  final BookDiscussionPost? post;

  @override
  Widget build(BuildContext context) {
    final discussionPost = post;
    if (discussionPost == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundDark,
          title: AppText('书评详情', style: AppTextStyles.titleMediumDark),
          centerTitle: true,
        ),
        backgroundColor: AppColors.backgroundDark,
        body: const EmptyState(title: '帖子不存在', description: '请返回讨论页重试'),
      );
    }

    return BlocListener<BookDiscussionDetailCubit, BookDiscussionDetailState>(
      listenWhen: (previous, current) =>
          previous.sendSuccessTick != current.sendSuccessTick,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('回复已发送')));
      },
      child: BlocListener<BookDiscussionDetailCubit, BookDiscussionDetailState>(
        listenWhen: (previous, current) =>
            previous.errorTick != current.errorTick,
        listener: (context, state) {
          final message = state.errorMessage;
          if (message == null) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        },
        child:
            BlocBuilder<BookDiscussionDetailCubit, BookDiscussionDetailState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: AppColors.backgroundDark,
                  appBar: AppBar(
                    backgroundColor: AppColors.backgroundDark,
                    elevation: 0,
                    centerTitle: true,
                    title: AppText(
                      '书评详情',
                      style: AppTextStyles.titleMediumDark,
                    ),
                    leading: IconButton(
                      onPressed: AppRouter.pop,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ),
                  body: BookDiscussionDetailContent(
                    post: state.post,
                    onPostLikeTap: () => context
                        .read<BookDiscussionDetailCubit>()
                        .togglePostLike(),
                    isPostLikePending: state.isPostLikePending,
                    onReplyLikeTap: (replyId) => context
                        .read<BookDiscussionDetailCubit>()
                        .toggleReplyLike(replyId),
                    replyLikePendingIds: state.replyLikePendingIds,
                  ),
                  bottomNavigationBar: BookDiscussionReplyInputBar(
                    authorName: state.post.authorName,
                    draft: state.replyDraft,
                    draftRevision: state.draftRevision,
                    canSend: state.canSend,
                    isSubmitting: state.isSubmittingReply,
                    onDraftChanged: context
                        .read<BookDiscussionDetailCubit>()
                        .updateReplyDraft,
                    onSend: () =>
                        context.read<BookDiscussionDetailCubit>().submitReply(),
                  ),
                );
              },
            ),
      ),
    );
  }
}
