import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';

/// Profile Screen - The Cache
/// Goal: A personal repository and skill tracker
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.backgroundPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentPrimary.withOpacity(0.2),
                      AppColors.accentSecondary.withOpacity(0.2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceLg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.accentPrimary,
                                  width: 3,
                                ),
                                color: AppColors.backgroundSecondary,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.accentPrimary,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Developer',
                                    style: AppTypography.h3,
                                  ),
                                  const SizedBox(height: AppDimens.spaceXs),
                                  Text(
                                    'developer@example.com',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Stats Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              child: Row(
                children: [
                  Expanded(child: _StatCard(label: 'Completed', value: '12')),
                  const SizedBox(width: AppDimens.spaceSm),
                  Expanded(child: _StatCard(label: 'In Progress', value: '5')),
                  const SizedBox(width: AppDimens.spaceSm),
                  Expanded(child: _StatCard(label: 'Saved', value: '24')),
                ],
              ),
            ),
          ),
          
          // Skill Constellation Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKILL CONSTELLATION',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.textHighlight,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  _SkillConstellation(),
                ],
              ),
            ),
          ),
          
          // Resume Learning Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESUME LEARNING',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.accentPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  Text(
                    'Pick up where you left off',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // In Progress Modules
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _ProgressModuleCard(index: index);
                },
                childCount: 3,
              ),
            ),
          ),
          
          // My Stacks Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MY STACKS',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.accentSecondary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.accentSecondary,
                        onPressed: () {
                          // TODO: Create new folder
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  Text(
                    'Organize your saved content',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Folder Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppDimens.spaceSm,
                mainAxisSpacing: AppDimens.spaceSm,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildListDelegate([
                _FolderCard(label: 'Python Basics', count: 8),
                _FolderCard(label: 'AI & ML', count: 12),
                _FolderCard(label: 'Web Dev', count: 5),
                _FolderCard(label: 'Project Ideas', count: 15),
              ]),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 100), // Bottom padding for nav
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.glassOverlay,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.h2.copyWith(
              color: AppColors.accentPrimary,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillConstellation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_graph,
              size: 64,
              color: AppColors.accentPrimary.withOpacity(0.3),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            Text(
              'Your skill nodes will appear here',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressModuleCard extends StatelessWidget {
  final int index;
  
  const _ProgressModuleCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final progress = 0.65; // Mock progress
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.glassOverlay,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(
          color: AppColors.accentPrimary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Advanced Python Decorators',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.play_circle_outline),
                color: AppColors.accentPrimary,
                onPressed: () {
                  // TODO: Continue module
                },
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Row(
            children: [
              Icon(
                Icons.signal_cellular_alt,
                size: AppDimens.iconXs,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimens.spaceXs),
              Text(
                'Advanced',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}% complete',
                style: AppTypography.caption.copyWith(
                  color: AppColors.accentPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.backgroundSecondary,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentPrimary,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  final String label;
  final int count;
  
  const _FolderCard({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.glassOverlay,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(
          color: AppColors.accentSecondary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.folder_outlined,
            color: AppColors.accentSecondary,
            size: AppDimens.iconLg,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                '$count items',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
