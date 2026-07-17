import 'dart:async';

import 'package:diandian_chuanshu/core/domain/entities/book.dart';
import 'package:diandian_chuanshu/core/theme/app_durations.dart';
import 'package:diandian_chuanshu/features/bookstore/application/bookstore_cubit.dart';
import 'package:diandian_chuanshu/features/bookstore/domain/entities/bookstore_page_content.dart';
import 'package:diandian_chuanshu/features/bookstore/domain/repositories/bookstore_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _SequencedBookstoreRepository implements BookstoreRepository {
  _SequencedBookstoreRepository(this.responses);

  final List<Future<BookstorePageContent> Function()> responses;
  int callCount = 0;

  @override
  Future<BookstorePageContent> fetchPageContent() {
    final index = callCount.clamp(0, responses.length - 1);
    callCount += 1;
    return responses[index]();
  }
}

void main() {
  group('BookstoreCubit.refresh', () {
    const initialBook = Book(
      id: 'initial',
      title: '刷新前',
      category: '测试',
      coverAsset: 'assets/covers/cover_01.png',
    );
    const refreshedBook = Book(
      id: 'refreshed',
      title: '刷新后',
      category: '测试',
      coverAsset: 'assets/covers/cover_02.png',
    );
    const initialContent = BookstorePageContent(
      searchPlaceholder: '刷新前',
      rankingBooksByTab: {},
      editorPicks: [],
      guessLikeBooks: [initialBook],
    );
    const refreshedContent = BookstorePageContent(
      searchPlaceholder: '刷新后',
      rankingBooksByTab: {},
      editorPicks: [],
      guessLikeBooks: [refreshedBook],
    );

    test('刷新时保留页面，完成后替换内容并重置猜你喜欢分页', () async {
      final refreshCompleter = Completer<BookstorePageContent>();
      final repository = _SequencedBookstoreRepository([
        () async => initialContent,
        () => refreshCompleter.future,
      ]);
      final cubit = BookstoreCubit(repository: repository);
      addTearDown(cubit.close);

      await cubit.load();
      await cubit.loadMoreGuessLike();
      final refreshFuture = cubit.refresh();

      expect(cubit.state.ui.isLoading, isFalse);
      expect(cubit.state.ui.isRefreshing, isTrue);
      expect(cubit.state.domain.content, initialContent);

      refreshCompleter.complete(refreshedContent);
      await refreshFuture;

      expect(cubit.state.domain.content, refreshedContent);
      expect(cubit.state.ui.isRefreshing, isFalse);
      expect(cubit.state.guessLikeBooks, [refreshedBook]);
      expect(cubit.state.ui.guessLikePage, 0);
    });

    test('重复刷新复用同一请求', () async {
      final refreshCompleter = Completer<BookstorePageContent>();
      final repository = _SequencedBookstoreRepository([
        () async => initialContent,
        () => refreshCompleter.future,
      ]);
      final cubit = BookstoreCubit(repository: repository);
      addTearDown(cubit.close);

      await cubit.load();
      final firstRefresh = cubit.refresh();
      final secondRefresh = cubit.refresh();

      expect(repository.callCount, 2);
      refreshCompleter.complete(refreshedContent);
      await Future.wait([firstRefresh, secondRefresh]);
      expect(repository.callCount, 2);
    });

    testWidgets('快速刷新也会完整展示两轮动画时长', (tester) async {
      final repository = _SequencedBookstoreRepository([
        () async => initialContent,
        () async => refreshedContent,
      ]);
      final cubit = BookstoreCubit(repository: repository);
      addTearDown(cubit.close);

      await cubit.load();
      final refreshFuture = cubit.refresh();
      await tester.pump();

      final twoAnimationCycles = (AppDurations.slow + AppDurations.normal) * 2;
      await tester.pump(twoAnimationCycles - const Duration(milliseconds: 1));
      expect(cubit.state.ui.isRefreshing, isTrue);

      await tester.pump(const Duration(milliseconds: 1));
      await refreshFuture;
      expect(cubit.state.ui.isRefreshing, isFalse);
      expect(cubit.state.domain.content, refreshedContent);
    });
  });
}
