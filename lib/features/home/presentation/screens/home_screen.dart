import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';

/// Home Screen - The Stream
/// Goal: Discovery over aggregation. High visuals, low text density.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showBottomNav = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrollingDown = _scrollController.position.userScrollDirection.name == 'reverse';
    if (isScrollingDown && _showBottomNav) {
      setState(() => _showBottomNav = false);
    } else if (!isScrollingDown && !_showBottomNav) {
      setState(() => _showBottomNav = true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: AppColors.backgroundPrimary.withOpacity(0.9),
                title: Text(
                  'NEXUS',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.accentPrimary,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () {
                      // TODO: Navigate to profile
                    },
                  ),
                ],
              ),
              
              // Daily Byte Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DAILY BYTE',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.textHighlight,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSm),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _DailyByteCard(index: index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Hero Cards Section
              SliverPadding(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _HeroCard(index: index);
                    },
                    childCount: 10,
                  ),
                ),
              ),
            ],
          ),
          
          // Floating Glass Bottom Navigation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showBottomNav ? 0 : -100,
            left: 0,
            right: 0,
            child: _GlassBottomNav(),
          ),
        ],
      ),
    );
  }
}

class _DailyByteCard extends StatelessWidget {
  final int index;
  
  const _DailyByteCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.glassOverlay,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceSm,
                  vertical: AppDimens.spaceXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
                child: Text(
                  '< 60s',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.accentSecondary,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.bookmark_outline,
                size: AppDimens.iconSm,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          Text(
            'Quick Tip: Understanding async/await',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final int index;
  
  const _HeroCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentPrimary.withOpacity(0.1),
            AppColors.accentSecondary.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        child: Stack(
          children: [
            // Placeholder for thumbnail
            Container(
              color: AppColors.backgroundSecondary,
              child: Center(
                child: Icon(
                  Icons.article,
                  size: 64,
                  color: AppColors.accentPrimary.withOpacity(0.3),
                ),
              ),
            ),
            
            // Gradient Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundPrimary.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppDimens.spaceSm,
                      children: [
                        _Tag(label: 'Python'),
                        _Tag(label: 'AI'),
                      ],
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    Text(
                      'Building Your First Neural Network',
                      style: AppTypography.h3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: AppDimens.iconXs,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimens.spaceXs),
                        Text(
                          '12 min read',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceMd),
                        Icon(
                          Icons.signal_cellular_alt,
                          size: AppDimens.iconXs,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimens.spaceXs),
                        Text(
                          'Intermediate',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.5),
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

class _GlassBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.bottomNavHeight,
      margin: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.glassOverlay,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.backgroundPrimary.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home, label: 'Home', isActive: true),
          _NavItem(icon: Icons.explore_outlined, label: 'Explore'),
          _NavItem(icon: Icons.bookmark_outline, label: 'Saved'),
          _NavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  
  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? AppColors.accentPrimary : AppColors.textSecondary,
          size: AppDimens.iconMd,
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isActive ? AppColors.accentPrimary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
