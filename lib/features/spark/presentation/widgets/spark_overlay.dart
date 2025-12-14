import 'package:architect_nexus/core/theme/app_colors.dart';
import 'package:architect_nexus/core/theme/app_dimens.dart';
import 'package:architect_nexus/core/theme/app_typography.dart';
import 'package:architect_nexus/features/spark/domain/spark_event.dart';
import 'package:architect_nexus/features/spark/presentation/controllers/spark_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SparkOverlay extends ConsumerStatefulWidget {
  const SparkOverlay({super.key});

  @override
  ConsumerState<SparkOverlay> createState() => _SparkOverlayState();
}

class _SparkOverlayState extends ConsumerState<SparkOverlay> {
  bool _hasFiredLaunch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _triggerLaunch());
  }

  void _triggerLaunch() {
    if (_hasFiredLaunch) return;
    _hasFiredLaunch = true;
    ref.read(sparkControllerProvider.notifier).trigger(SparkEvent.appLaunch);
  }

  @override
  Widget build(BuildContext context) {
    final sparkState = ref.watch(sparkControllerProvider);
    final event = sparkState.activeEvent;

    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            offset: sparkState.isVisible ? Offset.zero : const Offset(0.3, 0.3),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: sparkState.isVisible ? 1 : 0,
              child: event == null ? const SizedBox.shrink() : _SparkBubble(event: event),
            ),
          ),
        ),
      ),
    );
  }
}

class _SparkBubble extends StatelessWidget {
  const _SparkBubble({required this.event});

  final SparkEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.glassOverlay,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        border: Border.all(
          color: AppColors.accentPrimary.withValues(alpha: 0.4),
          width: AppDimens.borderWidthThin,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.backgroundPrimary.withValues(alpha: 0.4),
            blurRadius: AppDimens.spaceLg,
            offset: const Offset(0, AppDimens.spaceXs),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimens.cardHeightSm / 2,
            height: AppDimens.cardHeightSm / 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  AppColors.accentPrimary,
                  AppColors.accentSecondary,
                ],
              ),
              border: Border.all(
                color: AppColors.textHighlight.withValues(alpha: 0.6),
                width: AppDimens.borderWidthThin,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.headline,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHighlight,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  event.subtext,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
