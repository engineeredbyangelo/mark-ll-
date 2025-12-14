import 'package:architect_nexus/core/theme/app_colors.dart';
import 'package:architect_nexus/core/theme/app_dimens.dart';
import 'package:architect_nexus/core/theme/app_typography.dart';
import 'package:architect_nexus/features/learning/presentation/controllers/learning_sync_controller.dart';
import 'package:flutter/material.dart';

class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({super.key, required this.state, required this.onTap});

  final LearningSyncState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSyncing = state.isSyncing;
    final label = isSyncing ? 'Syncing…' : 'Sync';
    return GestureDetector(
      onTap: isSyncing ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSm,
          vertical: AppDimens.spaceXs,
        ),
        decoration: BoxDecoration(
          color: AppColors.glassOverlay,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(
            color: AppColors.accentPrimary.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSyncing)
              const SizedBox(
                width: AppDimens.iconXs,
                height: AppDimens.iconXs,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(
                Icons.sync,
                size: AppDimens.iconSm,
                color: AppColors.accentPrimary,
              ),
            const SizedBox(width: AppDimens.spaceXs),
            Text(
              label,
              style: AppTypography.caption.copyWith(color: AppColors.accentPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
