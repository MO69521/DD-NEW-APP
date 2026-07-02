import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/bookshelf_cubit.dart';
import '../../application/bookshelf_state.dart';
import '../../domain/entities/bookshelf_tab.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import 'bookshelf_delete_confirm_dialog.dart';
import 'bookshelf_manage_action_bar.dart';

class BookshelfManageActionOverlay extends StatelessWidget {
  const BookshelfManageActionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      BookshelfCubit,
      BookshelfState,
      ({
        bool isManaging,
        BookshelfTab selectedTab,
        int selectedCount,
        bool isAllSelected,
      })
    >(
      selector: (state) {
        final selectedTab = state.interaction.selectedTab;
        final tabBookCount = state.domain.bookSeedFor(selectedTab).length;
        final selectedCount = state.interaction.selectedBookIds.length;
        return (
          isManaging: state.interaction.isManaging,
          selectedTab: selectedTab,
          selectedCount: selectedCount,
          isAllSelected: tabBookCount > 0 && selectedCount == tabBookCount,
        );
      },
      builder: (context, data) {
        if (!data.isManaging) {
          return const SizedBox.shrink();
        }

        return BookshelfManageActionBar(
          selectedCount: data.selectedCount,
          isAllSelected: data.isAllSelected,
          onSelectAllTap: context.read<BookshelfCubit>().toggleSelectAll,
          onDeleteTap: () =>
              _confirmDelete(context, data.selectedTab, data.selectedCount),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    BookshelfTab selectedTab,
    int selectedCount,
  ) async {
    if (selectedCount <= 0) return;
    final cubit = context.read<BookshelfCubit>();
    final confirmed = await showAppBlurredDialog<bool>(
      context: context,
      builder: (_) => BookshelfDeleteConfirmDialog(
        selectedTab: selectedTab,
        selectedCount: selectedCount,
      ),
    );
    if (confirmed == true) {
      cubit.deleteSelectedBooks();
    }
  }
}
