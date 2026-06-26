import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/bookstore/application/bookstore_cubit.dart';
import '../../features/bookstore/index.dart';
import '../../features/bookshelf/application/bookshelf_cubit.dart';
import '../../features/bookshelf/index.dart';
import '../../features/partner/application/partner_cubit.dart';
import '../../features/partner/index.dart';
import '../../features/profile/application/profile_cubit.dart';
import '../../features/profile/index.dart';
import '../../features/welfare/application/welfare_cubit.dart';
import '../../features/welfare/index.dart';
import '../../shared/layouts/main_tab_controller.dart';
import '../../shared/layouts/main_tab_shell.dart';

/// 主 Tab Shell 页面：在 application 层注入各 Tab Cubit。
class MainTabShellPage extends StatefulWidget {
  const MainTabShellPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainTabShellPage> createState() => _MainTabShellPageState();
}

class _MainTabShellPageState extends State<MainTabShellPage> {
  final _mainTabController = MainTabController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BookstoreCubit()..load()),
        BlocProvider(create: (_) => WelfareCubit()..load()),
        BlocProvider(create: (_) => PartnerCubit()..load()),
        BlocProvider(create: (_) => BookshelfCubit()..load()),
        BlocProvider(create: (_) => ProfileCubit()..load()),
      ],
      child: MainTabShell(
        initialIndex: widget.initialIndex,
        controller: _mainTabController,
        pages: [
          const BookstorePage(),
          const WelfarePage(),
          const PartnerPage(),
          BookshelfPage(mainTabController: _mainTabController),
          ProfilePage(mainTabController: _mainTabController),
        ],
      ),
    );
  }
}
