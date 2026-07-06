import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/currency_config.dart';
import '../core/constants/main_tab_config.dart';
import '../core/domain/entities/commerce_entities.dart';
import '../core/domain/entities/book.dart';
import '../features/account_settings/index.dart';
import '../features/auth/index.dart';
import '../features/book_detail/index.dart';
import '../features/card_pack/index.dart';
import '../features/category/index.dart';
import '../features/currency_wallet/index.dart';
import '../features/editor_pick/index.dart';
import '../features/help_feedback/index.dart';
import '../features/settings/index.dart';
import '../features/my_messages/index.dart';
import '../features/membership/index.dart';
import '../features/ranking/index.dart';
import '../features/search/index.dart';
import '../features/settings/data/datasources/settings_document_mock_datasource.dart';
import '../features/settings/domain/entities/settings_document.dart';
import '../features/splash/index.dart';
import 'app_routes.dart';
import 'pages/main_tab_shell_page.dart';

/// 集中式路由管理，禁止在 UI 中直接使用 Navigator.push。
abstract final class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static String _initialLocation = AppRoutes.splash;
  static GoRouter? _routerInstance;

  /// 在首次访问 [router] 前调用，用于预览入口指定初始 Tab（如 `/?tab=1`）。
  static void setInitialLocation(String location) {
    assert(
      _routerInstance == null,
      'AppRouter.setInitialLocation must be called before router is accessed',
    );
    _initialLocation = location;
  }

  static GoRouter get router => _routerInstance ??= _createRouter();

  static GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: _initialLocation,
      overridePlatformDefaultLocation: true,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splashName,
          builder: (context, state) => BlocProvider(
            create: (_) => SplashCubit()..start(),
            child: const SplashPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.loginName,
          builder: (context, state) => BlocProvider(
            create: (_) => LoginCubit(),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.homeName,
          builder: (context, state) {
            final tabParam = state.uri.queryParameters['tab'];
            final initialIndex = int.tryParse(tabParam ?? '') ?? 0;
            final maxIndex = MainTabConfig.items.length - 1;
            return MainTabShellPage(
              initialIndex: initialIndex.clamp(0, maxIndex),
              initialBookshelfTabIntent:
                  state.uri.queryParameters['bookshelfTab'],
            );
          },
        ),
        GoRoute(
          path: AppRoutes.ranking,
          name: AppRoutes.rankingName,
          builder: (context, state) {
            final extra = state.extra;
            final initialDimension = extra is RankingDimension
                ? extra
                : RankingDimension.recommend;
            return BlocProvider(
              create: (_) =>
                  RankingCubit(initialDimension: initialDimension)..load(),
              child: const RankingPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.search,
          name: AppRoutes.searchName,
          builder: (context, state) => BlocProvider(
            create: (_) => SearchCubit(),
            child: const SearchPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.category,
          name: AppRoutes.categoryName,
          builder: (context, state) => BlocProvider(
            create: (_) => CategoryCubit()..load(),
            child: const CategoryPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.editorPick,
          name: AppRoutes.editorPickName,
          builder: (context, state) => BlocProvider(
            create: (_) => EditorPickCubit()..load(),
            child: const EditorPickPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.membership,
          name: AppRoutes.membershipName,
          builder: (context, state) => BlocProvider(
            create: (_) => MembershipCubit()..load(),
            child: const MembershipPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.rechargeRecords,
          name: AppRoutes.rechargeRecordsName,
          builder: (context, state) => const RechargeRecordsPage(),
        ),
        GoRoute(
          path: AppRoutes.currencyWallet,
          name: AppRoutes.currencyWalletName,
          builder: (context, state) {
            final type =
                CurrencyConfig.fromSlug(state.pathParameters['type']) ??
                CurrencyType.energy;
            return BlocProvider(
              create: (_) => CurrencyWalletCubit(type)..load(),
              child: const CurrencyWalletPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.energyRecords,
          name: AppRoutes.energyRecordsName,
          builder: (context, state) => BlocProvider(
            create: (_) => EnergyRecordsCubit()..load(),
            child: const EnergyRecordsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.accountSettings,
          name: AppRoutes.accountSettingsName,
          builder: (context, state) => BlocProvider(
            create: (_) => AccountSettingsCubit()..load(),
            child: const AccountSettingsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.myMessages,
          name: AppRoutes.myMessagesName,
          builder: (context, state) => BlocProvider(
            create: (_) => MyMessagesCubit(),
            child: const MyMessagesPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.cardPack,
          name: AppRoutes.cardPackName,
          builder: (context, state) => const CardPackPage(),
        ),
        GoRoute(
          path: AppRoutes.helpFeedback,
          name: AppRoutes.helpFeedbackName,
          builder: (context, state) => BlocProvider(
            create: (_) => HelpFeedbackCubit()..load(),
            child: const HelpFeedbackPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.helpFeedbackFaqDetail,
          name: AppRoutes.helpFeedbackFaqDetailName,
          builder: (context, state) {
            final extra = state.extra;
            return HelpFeedbackFaqDetailPage(
              question: extra is String ? extra : '常见问题',
            );
          },
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: AppRoutes.settingsName,
          builder: (context, state) => BlocProvider(
            create: (_) => SettingsCubit()..load(),
            child: const SettingsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.notificationSettings,
          name: AppRoutes.notificationSettingsName,
          builder: (context, state) => BlocProvider(
            create: (_) => NotificationSettingsCubit(),
            child: const NotificationSettingsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.personalizedAds,
          name: AppRoutes.personalizedAdsName,
          builder: (context, state) => BlocProvider(
            create: (_) => PersonalizedAdsCubit(),
            child: const PersonalizedAdsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.readingPreferences,
          name: AppRoutes.readingPreferencesName,
          builder: (context, state) => BlocProvider(
            create: (_) => ReadingPreferencesCubit(),
            child: const ReadingPreferencesPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.teenMode,
          name: AppRoutes.teenModeName,
          builder: (context, state) => const TeenModePage(),
        ),
        GoRoute(
          path: AppRoutes.settingsDocument,
          name: AppRoutes.settingsDocumentName,
          builder: (context, state) {
            final type = SettingsDocumentType.fromSlug(
              state.pathParameters['type'],
            );
            final document = const SettingsDocumentMockDataSource()
                .fetchDocument(type);
            return SettingsDocumentPage(document: document);
          },
        ),
        GoRoute(
          path: AppRoutes.bookDetail,
          name: AppRoutes.bookDetailName,
          builder: (context, state) {
            final bookId = state.pathParameters['id'] ?? '';
            final extra = state.extra;
            final seed = switch (extra) {
              BookDetailRouteExtra(:final book) => book,
              Book() => extra,
              _ => null,
            };
            final isInShelf = switch (extra) {
              BookDetailRouteExtra(:final isInShelf) => isInShelf,
              _ => state.uri.queryParameters['inShelf'] == '1',
            };
            return BlocProvider(
              create: (_) => BookDetailCubit(
                bookId: bookId,
                seedBook: seed,
                initialIsInShelf: isInShelf,
              )..load(),
              child: const BookDetailPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.bookDiscussionDetail,
          name: AppRoutes.bookDiscussionDetailName,
          builder: (context, state) {
            final extra = state.extra;
            final post = extra is BookDiscussionPost ? extra : null;
            if (post == null) {
              return const BookDiscussionDetailPage(post: null);
            }
            return BlocProvider(
              create: (_) => BookDiscussionDetailCubit(post: post),
              child: BookDiscussionDetailPage(post: post),
            );
          },
        ),
      ],
    );
  }

  static void go(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }

  /// 书籍详情页跳转入口：所有书卡点击统一走此方法，携带书籍以渲染真实封面。
  static void goBookDetail(Book book, {bool isInShelf = false}) {
    router.pushNamed(
      AppRoutes.bookDetailName,
      pathParameters: {'id': book.id},
      extra: BookDetailRouteExtra(book: book, isInShelf: isInShelf),
    );
  }

  static void pushBookDiscussionDetail({
    required String bookId,
    required BookDiscussionPost post,
  }) {
    router.pushNamed(
      AppRoutes.bookDiscussionDetailName,
      pathParameters: {'id': bookId, 'postId': post.id},
      extra: post,
    );
  }

  static void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    router.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    router.pop(result);
  }
}

class BookDetailRouteExtra {
  const BookDetailRouteExtra({required this.book, this.isInShelf = false});

  final Book book;
  final bool isInShelf;
}
