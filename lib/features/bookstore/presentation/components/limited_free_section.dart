import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/components/book_grid_card.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// 限时免费区块：倒计时 + 横向 3 本书卡。
class LimitedFreeSection extends StatefulWidget {
  const LimitedFreeSection({
    super.key,
    required this.books,
    this.onMoreTap,
    this.onBookTap,
  });

  final List<Book> books;
  final VoidCallback? onMoreTap;

  /// 回调携带该卡封面的屏内唯一 Hero 标签，供详情页同 tag 飞行。
  final void Function(Book book, Object coverHeroTag)? onBookTap;

  @override
  State<LimitedFreeSection> createState() => _LimitedFreeSectionState();
}

class _LimitedFreeSectionState extends State<LimitedFreeSection> {
  static const Duration _initialRemaining = Duration(
    days: 3,
    hours: 8,
    minutes: 59,
  );

  late final DateTime _endsAt;
  late Duration _remaining = _initialRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _endsAt = DateTime.now().add(_initialRemaining);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final nextRemaining = _endsAt.difference(DateTime.now());
      if (!mounted) return;
      if (nextRemaining <= Duration.zero) {
        setState(() => _remaining = Duration.zero);
        _timer?.cancel();
        return;
      }
      setState(() => _remaining = nextRemaining);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleBooks = widget.books.take(3).toList();
    if (visibleBooks.isEmpty) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LimitedFreeHeader(
              remaining: _remaining,
              onMoreTap: widget.onMoreTap,
            ),
            const SizedBox(height: AppSpacing.md),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth =
                    (constraints.maxWidth - AppSpacing.md * 2) / 3;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var index = 0; index < visibleBooks.length; index++)
                      Padding(
                        padding: EdgeInsets.only(
                          right: index == visibleBooks.length - 1
                              ? 0
                              : AppSpacing.md,
                        ),
                        child: SizedBox(
                          width: itemWidth,
                          child: Builder(
                            builder: (context) {
                              final book = visibleBooks[index];
                              final heroTag = 'book-cover-limitedfree-${book.id}';
                              return BookGridCard(
                                title: book.title,
                                category: book.category,
                                coverAsset: book.coverAsset,
                                coverTag: book.coverTag,
                                heroTag: heroTag,
                                onTap: widget.onBookTap == null
                                    ? null
                                    : () => widget.onBookTap!(book, heroTag),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LimitedFreeHeader extends StatelessWidget {
  const _LimitedFreeHeader({required this.remaining, this.onMoreTap});

  final Duration remaining;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          '限时免费',
          style: AppTextStyles.sectionTitleDark.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        _Countdown(remaining: remaining),
        const Spacer(),
        AppPressable(
          onTap: onMoreTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                '更多',
                style: AppTextStyles.bookTagDark.copyWith(
                  color: AppColors.textOnDarkMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              const AppIcon(
                assetPath: 'assets/icons/arrow_right.svg',
                width: AppSpacing.sm,
                height: AppSpacing.sm,
                color: AppColors.sectionActionIcon,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Countdown extends StatelessWidget {
  const _Countdown({required this.remaining});

  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final clamped = remaining.isNegative ? Duration.zero : remaining;
    final totalMinutes = clamped == Duration.zero
        ? 0
        : (clamped.inSeconds + Duration.secondsPerMinute - 1) ~/
              Duration.secondsPerMinute;
    final days = totalMinutes ~/ Duration.minutesPerDay;
    final hours = (totalMinutes ~/ Duration.minutesPerHour).remainder(
      Duration.hoursPerDay,
    );
    final minutes = totalMinutes.remainder(Duration.minutesPerHour);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CountdownValue(value: days.toString().padLeft(2, '0')),
        const _CountdownUnit('天'),
        _CountdownValue(value: hours.toString().padLeft(2, '0')),
        const _CountdownUnit('时'),
        _CountdownValue(value: minutes.toString().padLeft(2, '0')),
        const _CountdownUnit('分'),
      ],
    );
  }
}

class _CountdownValue extends StatelessWidget {
  const _CountdownValue({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.limitedFreeCountdownBoxSize,
      height: AppSizes.limitedFreeCountdownBoxSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppWelfareColors.hotSaleBadge,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: AppText(
        value,
        style: AppTextStyles.captionMd.copyWith(
          color: AppWelfareColors.hotSaleBadgeText,
        ),
      ),
    );
  }
}

class _CountdownUnit extends StatelessWidget {
  const _CountdownUnit(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: AppText(
        value,
        style: AppTextStyles.captionMd.copyWith(color: AppColors.textOnDark),
      ),
    );
  }
}
