import 'package:architect_nexus/core/theme/app_colors.dart';
import 'package:architect_nexus/core/theme/app_dimens.dart';
import 'package:architect_nexus/core/theme/app_typography.dart';
import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ModuleFeed extends StatelessWidget {
  const ModuleFeed({
    super.key,
    required this.modulesAsync,
    this.emptyMessage = 'Spark is curating fresh content. Check back soon.',
    this.bookmarkedModuleIds = const <String>{},
  });

  final AsyncValue<List<LearningModule>> modulesAsync;
  final String emptyMessage;
  final Set<String> bookmarkedModuleIds;

  @override
  Widget build(BuildContext context) {
    return modulesAsync.when(
      data: (modules) {
        if (modules.isEmpty) {
          return SliverToBoxAdapter(child: _ModuleFeedEmptyState(message: emptyMessage));
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: _ModuleFeedCard(
                module: modules[index],
                isBookmarked: bookmarkedModuleIds.contains(modules[index].id),
              ),
            ),
            childCount: modules.length,
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(child: _ModuleFeedSkeleton()),
      error: (error, _) => SliverToBoxAdapter(
        child: _ModuleFeedError(message: error.toString()),
      ),
    );
  }
}

class _ModuleFeedCard extends StatelessWidget {
  const _ModuleFeedCard({
    required this.module,
    this.isBookmarked = false,
  });

  final LearningModule module;
  final bool isBookmarked;

  Color _difficultyHue() {
    switch (module.difficulty) {
      case ModuleDifficulty.beginner:
        return AppColors.accentPrimary;
      case ModuleDifficulty.intermediate:
        return AppColors.accentSecondary;
      case ModuleDifficulty.advanced:
        return AppColors.textHighlight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _difficultyHue();
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.push('/module/${module.id}');
      },
      child: Container(
        height: AppDimens.cardHeightLg,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          border: Border.all(
            color: accent.withValues(alpha: 0.4),
            width: AppDimens.borderWidthThin,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.10),
              AppColors.backgroundSecondary,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.radiusXl),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundPrimary.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppDimens.spaceSm,
                    runSpacing: AppDimens.spaceXs,
                    children: module.tags.take(3).map((tag) => _TagChip(label: tag)).toList(),
                  ),
                  const Spacer(),
                  Text(
                    module.title,
                    style: AppTypography.h3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  Text(
                    module.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: AppDimens.iconXs,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppDimens.spaceXs),
                      Text(
                        '${module.estimatedMinutes} min read',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceMd),
                      const Icon(
                        Icons.layers,
                        size: AppDimens.iconXs,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppDimens.spaceXs),
                      Text(
                        '${module.totalSlides} slides',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: AppDimens.spaceSm,
              right: AppDimens.spaceSm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isBookmarked)
                    Icon(
                      Icons.bookmark,
                      color: accent,
                      size: AppDimens.iconSm,
                    ),
                  Icon(
                    Icons.chevron_right,
                    color: accent,
                    size: AppDimens.iconLg,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(
          color: AppColors.accentPrimary.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.accentPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ModuleFeedSkeleton extends StatelessWidget {
  const _ModuleFeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (_) => Container(
          margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
          height: AppDimens.cardHeightLg,
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          ),
        ),
      ),
    );
  }
}

class _ModuleFeedError extends StatelessWidget {
  const _ModuleFeedError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceLg),
      child: Text(
        'Unable to sync modules: $message',
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _ModuleFeedEmptyState extends StatelessWidget {
  const _ModuleFeedEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceLg),
      child: Text(
        message,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
