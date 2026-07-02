import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/bookshelf_cubit.dart';
import '../../application/bookshelf_state.dart';
import '../../domain/entities/bookshelf_tab.dart';
import 'bookshelf_manage_action_bar.dart';

class BookshelfManageActionOverlay extends StatelessWidget {
  const BookshelfManageActionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      BookshelfCubit,
      BookshelfState,
      ({bool isManaging, int selectedCount, bool isAllSelected})
    >(
      selector: (state) {
        final shelfCount = state.domain.bookSeedFor(BookshelfTab.shelf).length;
        final selectedCount = state.interaction.selectedBookIds.length;
        return (
          isManaging: state.interaction.isManaging,
          selectedCount: selectedCount,
          isAllSelected: shelfCount > 0 && selectedCount == shelfCount,
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
          onDeleteTap: context.read<BookshelfCubit>().deleteSelectedBooks,
        );
      },
    );
  }
}
