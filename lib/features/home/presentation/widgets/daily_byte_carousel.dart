import 'package:architect_nexus/core/theme/app_colors.dart';
import 'package:architect_nexus/core/theme/app_dimens.dart';
import 'package:architect_nexus/core/theme/app_typography.dart';
import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DailyByteCarousel extends StatelessWidget {
  const DailyByteCarousel({
    super.key,
    required this.modulesAsync,
    this.title = 'DAILY BYTE',
    this.emptyMessage = 'Fresh bytes are syncing... check back shortly.',
  });

  final AsyncValue<List<LearningModule>> modulesAsync;
  final String title;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h4.copyWith(color: AppColors.textHighlight),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        SizedBox(
          height: AppDimens.cardHeightSm,
          child: modulesAsync.when(
            data: (modules) {
              if (modules.isEmpty) {
                return _DailyByteEmptyState(message: emptyMessage);
              }
              final featured = modules.take(5).toList();
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(right: AppDimens.spaceMd),
                itemCount: featured.length,
                separatorBuilder: (context, _) => const SizedBox(width: AppDimens.spaceSm),
                itemBuilder: (context, index) => _DailyByteCard(module: featured[index]),
              );
            },
            loading: () => const _DailyByteSkeletonList(),
            error: (error, _) => _DailyByteError(message: error.toString()),
          ),
        ),
      ],
    );
  }
}

class _DailyByteCard extends StatelessWidget {
  const _DailyByteCard({required this.module});

  final LearningModule module;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push('/module/${module.id}');
      },
      child: Container(
        width: AppDimens.cardHeightLg,
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.glassOverlay,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          border: Border.all(
            color: AppColors.accentPrimary.withValues(alpha: 0.2),
            width: AppDimens.borderWidthThin,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _InfoChip(label: '~${module.estimatedMinutes}m'),
                const Spacer(),
                Icon(
                  Icons.flash_on,
                  size: AppDimens.iconSm,
                  color: AppColors.accentPrimary.withValues(alpha: 0.8),
                ),
              ],
            ),
            Text(
              module.title,
              style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              module.description,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentSecondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.accentSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DailyByteSkeletonList extends StatelessWidget {
  const _DailyByteSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: AppDimens.spaceSm),
      itemBuilder: (context, _) => Container(
        width: AppDimens.cardHeightLg,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        ),
      ),
    );
  }
}

class _DailyByteError extends StatelessWidget {
  const _DailyByteError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Unable to load insights: $message',
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _DailyByteEmptyState extends StatelessWidget {
  const _DailyByteEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Text(
        message,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
