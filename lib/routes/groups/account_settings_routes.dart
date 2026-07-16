import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/account_settings/index.dart';
import '../../features/card_pack/index.dart';
import '../../features/dress_up/index.dart';
import '../../features/help_feedback/index.dart';
import '../../features/my_messages/index.dart';
import '../../features/settings/data/datasources/settings_document_mock_datasource.dart';
import '../../features/settings/domain/entities/settings_document.dart';
import '../../features/settings/index.dart';
import '../app_routes.dart';

/// 账户与设置路由：账号设置、消息、卡包、帮助反馈、设置及其子页。
List<RouteBase> accountSettingsRoutes() => [
  GoRoute(
    path: AppRoutes.accountSettings,
    name: AppRoutes.accountSettingsName,
    builder: (context, state) => BlocProvider(
      create: (_) => AccountSettingsCubit()..load(),
      child: const AccountSettingsPage(),
    ),
  ),
  GoRoute(
    path: AppRoutes.dressUp,
    name: AppRoutes.dressUpName,
    builder: (context, state) => BlocProvider(
      create: (_) => DressUpCubit()..load(),
      child: const DressUpPage(),
    ),
  ),
  GoRoute(
    path: AppRoutes.editNickname,
    name: AppRoutes.editNicknameName,
    builder: (context, state) {
      final nickname = state.extra is String ? state.extra as String : '';
      return BlocProvider(
        create: (_) => EditNicknameCubit(originalNickname: nickname),
        child: const EditNicknamePage(),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.myMessages,
    name: AppRoutes.myMessagesName,
    builder: (context, state) => BlocProvider(
      create: (_) => MyMessagesCubit()..load(),
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
      final type = SettingsDocumentType.fromSlug(state.pathParameters['type']);
      final document = const SettingsDocumentMockDataSource().fetchDocument(
        type,
      );
      return SettingsDocumentPage(document: document);
    },
  ),
];
