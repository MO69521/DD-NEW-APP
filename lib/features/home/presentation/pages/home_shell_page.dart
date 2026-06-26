import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/home_cubit.dart';
import 'home_page.dart';

/// Home Shell：在 application 层注入 [HomeCubit]。
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..load(),
      child: const HomePage(),
    );
  }
}
