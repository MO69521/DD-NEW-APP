import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

class AppSelectionMark extends StatelessWidget {
  const AppSelectionMark({
    super.key,
    required this.isSelected,
    this.unselectedBackgroundColor = AppColors.gradientFadeStart,
    this.unselectedBorderColor =
        AppColors.bookshelfSelectionMarkBorderUnselected,
    this.selectedBackgroundColor = AppColors.primary,
    this.selectedBorderColor = AppColors.primary,
    this.selectedBorderWidth = AppSizes.hairline,
    this.unselectedBorderWidth = AppSizes.hairline,
  });

  final bool isSelected;
  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final double selectedBorderWidth;
  final double unselectedBorderWidth;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected ? selectedBackgroundColor : unselectedBackgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? selectedBorderColor : unselectedBorderColor,
          width: isSelected ? selectedBorderWidth : unselectedBorderWidth,
        ),
      ),
      child: SizedBox.square(
        dimension: AppSizes.selectionMarkSize,
        child: isSelected
            ? const Center(
                child: SizedBox.square(
                  dimension: AppSizes.bookshelfSelectionCheckIconSize,
                  child: CustomPaint(painter: _SelectionCheckPainter()),
                ),
              )
            : null,
      ),
    );
  }
}

class _SelectionCheckPainter extends CustomPainter {
  const _SelectionCheckPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.22, size.height * 0.52)
      ..lineTo(size.width * 0.43, size.height * 0.72)
      ..lineTo(size.width * 0.78, size.height * 0.30);

    final paint = Paint()
      ..color = AppColors.onPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.selectionMarkCheckStrokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SelectionCheckPainter oldDelegate) {
    return false;
  }
}
