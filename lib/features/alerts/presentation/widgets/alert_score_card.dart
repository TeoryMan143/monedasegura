import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/catalogs/catalog_providers.dart';
import '../../../../core/domain/fraud_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/kit.dart';

/// The score of A-05 (HU-07): the big badge, the risk meter and the suggested fraud type.
///
/// The badge, the meter and its text give the range without relying on colour alone.
class AlertScoreCard extends StatelessWidget {
  const AlertScoreCard({
    required this.score,
    required this.suggestedType,
    super.key,
  });

  final int score;
  final FraudType suggestedType;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScoreBadge.large(score: score),
          const SizedBox(width: AppSpace.xl),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Eyebrow('SCORE DE RIESGO'),
                const SizedBox(height: AppSpace.sm),
                ScoreMeter(score: score),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.xl),
          const SizedBox(
            width: 1,
            height: AppSizes.scoreBadgeLarge,
            child: ColoredBox(color: AppColors.borderSubtle),
          ),
          const SizedBox(width: AppSpace.xl),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Eyebrow('TIPO SUGERIDO'),
                const SizedBox(height: AppSpace.sm),
                _SuggestedType(type: suggestedType),
                const SizedBox(height: AppSpace.sm),
                Text(
                  suggestedType.description,
                  style: AppText.bodyS.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small uppercase caption above a value.
class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppText.label.copyWith(color: AppColors.textSecondary));
}

/// The type as a `TaxonomyChip` with the colour of the catalog. While the catalog loads,
/// or if it fails, it shows the code and name as text.
class _SuggestedType extends ConsumerWidget {
  const _SuggestedType({required this.type});

  final FraudType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(fraudTypesProvider).value;
    final entry = catalog?.where((item) => item.code == type.code).firstOrNull;
    if (entry == null) {
      return Text('${type.code} · ${type.label}', style: AppText.bodyMMedium);
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: TaxonomyChip.fromCatalog(entry),
    );
  }
}
