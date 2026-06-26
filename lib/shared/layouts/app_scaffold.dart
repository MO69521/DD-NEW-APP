import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';


/// 通用页面脚手架布局。
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.floatingActionButton,
  });

  final String? title;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: title != null ? AppBar(title: Text(title!)) : null,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
