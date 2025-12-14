import 'package:architect_nexus/core/theme/app_colors.dart';
import 'package:architect_nexus/core/theme/app_dimens.dart';
import 'package:architect_nexus/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    super.key,
    required this.activeIndex,
    required this.onItemSelected,
  });

  final int activeIndex;
  final ValueChanged<int> onItemSelected;

  static const _items = [
    _NavItemData(icon: Icons.home, label: 'Home'),
    _NavItemData(icon: Icons.explore_outlined, label: 'Explore'),
    _NavItemData(icon: Icons.bookmark_outline, label: 'Saved'),
    _NavItemData(icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: AppDimens.bottomNavHeight,
        margin: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.glassOverlay,
          borderRadius: BorderRadius.circular(AppDimens.radiusXl),
          border: Border.all(
            color: AppColors.accentPrimary.withValues(alpha: 0.3),
            width: AppDimens.borderWidthThin,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.backgroundPrimary.withValues(alpha: 0.5),
              blurRadius: AppDimens.spaceLg,
              offset: const Offset(0, AppDimens.spaceXs),
            ),
          ],
        ),
        child: Row(
          children: List.generate(
            _items.length,
            (index) => Expanded(
              child: _NavButton(
                data: _items[index],
                isActive: index == activeIndex,
                onTap: () => onItemSelected(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  final _NavItemData data;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.accentPrimary : AppColors.textSecondary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            data.icon,
            color: color,
            size: AppDimens.iconMd,
          ),
          const SizedBox(height: AppDimens.spaceXs),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(data.label),
          ),
        ],
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
