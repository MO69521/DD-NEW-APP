import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// 作品简介区块（Figma 185:2438）。
class BookDetailIntro extends StatefulWidget {
  const BookDetailIntro({super.key, required this.intro});

  final String intro;

  @override
  State<BookDetailIntro> createState() => _BookDetailIntroState();
}

class _BookDetailIntroState extends State<BookDetailIntro> {
  static const int _collapsedMaxLines = 5;
  static const String _moreSuffix = '...查看更多';

  bool _isExpanded = false;

  bool _exceedsCollapsedLines(BuildContext context, double maxWidth) {
    final direction = Directionality.of(context);
    if (maxWidth <= 0) return false;

    final painter = TextPainter(
      text: TextSpan(
        text: widget.intro,
        style: AppTextStyles.bookDetailIntroBody,
      ),
      textDirection: direction,
      maxLines: _collapsedMaxLines,
    )..layout(maxWidth: maxWidth);

    return painter.didExceedMaxLines;
  }

  String _collapsedIntro(BuildContext context, double maxWidth) {
    final direction = Directionality.of(context);
    var low = 0;
    var high = widget.intro.length;
    var best = '';

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      final candidate =
          '${widget.intro.substring(0, mid).trimRight()}$_moreSuffix';
      final painter = TextPainter(
        text: TextSpan(
          text: candidate,
          style: AppTextStyles.bookDetailIntroBody,
        ),
        textDirection: direction,
        maxLines: _collapsedMaxLines,
      )..layout(maxWidth: maxWidth);

      if (painter.didExceedMaxLines) {
        high = mid - 1;
      } else {
        best = candidate;
        low = mid + 1;
      }
    }

    return best;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText('作品简介', style: AppTextStyles.bookDetailBlockTitle),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final shouldShowMore =
                !_isExpanded &&
                _exceedsCollapsedLines(context, constraints.maxWidth);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (shouldShowMore)
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = true),
                    behavior: HitTestBehavior.opaque,
                    child: RichText(
                      maxLines: _collapsedMaxLines,
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                        style: AppTextStyles.bookDetailIntroBody,
                        children: [
                          TextSpan(
                            text: _collapsedIntro(
                              context,
                              constraints.maxWidth,
                            ).replaceFirst(_moreSuffix, ''),
                          ),
                          TextSpan(
                            text: _moreSuffix,
                            style: AppTextStyles.bookDetailIntroBody.copyWith(
                              color: AppColors.textOnDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  AppText(
                    widget.intro,
                    style: AppTextStyles.bookDetailIntroBody,
                    maxLines: _isExpanded ? null : _collapsedMaxLines,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
