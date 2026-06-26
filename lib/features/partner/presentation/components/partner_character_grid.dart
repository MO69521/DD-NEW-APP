import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/partner_character.dart';
import 'partner_character_card.dart';

/// L3 — 探索页双列角色网格（Wrap 自适应高度，避免固定 extent 溢出）。
class PartnerCharacterGrid extends StatelessWidget {
  const PartnerCharacterGrid({
    super.key,
    required this.characters,
    this.onCharacterTap,
  });

  final List<PartnerCharacter> characters;
  final ValueChanged<PartnerCharacter>? onCharacterTap;

  static const int _crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing = AppSpacing.sm * (_crossAxisCount - 1);
        final itemWidth =
            (constraints.maxWidth - totalSpacing) / _crossAxisCount;

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final character in characters)
              SizedBox(
                width: itemWidth,
                child: PartnerCharacterCard(
                  character: character,
                  onTap: onCharacterTap == null
                      ? null
                      : () => onCharacterTap!(character),
                ),
              ),
          ],
        );
      },
    );
  }
}
