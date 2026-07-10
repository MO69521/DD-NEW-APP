import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 搜索页顶栏：返回 + 可编辑输入框 + 「搜索」动作。
///
/// 输入控制器与焦点为 UI 局部控制器（非业务 state），故由本组件自持。
class SearchAppBar extends StatefulWidget {
  const SearchAppBar({
    super.key,
    required this.statusBarHeight,
    required this.placeholder,
    this.initialQuery = '',
    this.onBack,
    this.onSubmit,
    this.onChanged,
    this.onCleared,
  });

  final double statusBarHeight;
  final String placeholder;
  final String initialQuery;
  final VoidCallback? onBack;
  final void Function(String query)? onSubmit;

  /// 输入变化实时回调（用于联想）。
  final void Function(String query)? onChanged;
  final VoidCallback? onCleared;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  Animation<double>? _routeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    // 键盘在页面转场结束后再升起，避免与 push 动画抢帧导致的顿挫。
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusAfterTransition());
  }

  void _focusAfterTransition() {
    if (!mounted) return;
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null || animation.isCompleted) {
      _focusNode.requestFocus();
      return;
    }
    _routeAnimation = animation..addStatusListener(_onRouteAnimationStatus);
  }

  void _onRouteAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    _routeAnimation = null;
    if (mounted) _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() => widget.onSubmit?.call(_controller.text);

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
    if (value.trim().isEmpty) {
      widget.onCleared?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: widget.statusBarHeight),
      child: SizedBox(
        height: AppSizes.topBarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              _BackButton(onTap: widget.onBack),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _SearchInputField(
                  controller: _controller,
                  focusNode: _focusNode,
                  placeholder: widget.placeholder,
                  onSubmitted: (_) => _submit(),
                  onChanged: _handleChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SearchAction(onTap: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onTap});

  final VoidCallback? onTap;

  static const String _backIconAsset = 'assets/icons/ranking/back.svg';

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.only(right: AppSpacing.xxs),
        child: AppIcon(
          assetPath: _backIconAsset,
          width: AppSizes.searchAppBarBackIconWidth,
          height: AppSizes.searchAppBarBackIconHeight,
          color: AppColors.textOnDark,
        ),
      ),
    );
  }
}

class _SearchInputField extends StatelessWidget {
  const _SearchInputField({
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.onSubmitted,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;

  static const String _searchIconAsset = 'assets/icons/search.svg';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.searchBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(AppRadius.searchBar),
        border: Border.all(
          color: AppColors.borderGlass,
          width: AppSizes.hairline,
        ),
      ),
      child: Row(
        children: [
          const AppIcon(
            assetPath: _searchIconAsset,
            width: AppSizes.searchInputIconSize,
            height: AppSizes.searchInputIconSize,
            color: AppColors.textOnDarkPlaceholder,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              maxLines: 1,
              style: AppTextStyles.searchInputText,
              cursorColor: AppColors.searchCursor,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: AppTextStyles.searchPlaceholderDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAction extends StatelessWidget {
  const _SearchAction({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: const AppText('搜索', style: AppTextStyles.searchActionLabel),
    );
  }
}
