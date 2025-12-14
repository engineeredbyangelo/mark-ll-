import 'dart:async';

import 'package:architect_nexus/core/theme/app_colors.dart';
import 'package:architect_nexus/core/theme/app_dimens.dart';
import 'package:architect_nexus/core/theme/app_typography.dart';
import 'package:architect_nexus/features/home/presentation/widgets/daily_byte_carousel.dart';
import 'package:architect_nexus/features/home/presentation/widgets/glass_bottom_nav.dart';
import 'package:architect_nexus/features/home/presentation/widgets/module_feed.dart';
import 'package:architect_nexus/features/learning/presentation/controllers/learning_providers.dart';
import 'package:architect_nexus/features/profile/presentation/controllers/user_progress_providers.dart';
import 'package:architect_nexus/features/learning/presentation/controllers/learning_sync_controller.dart';
import 'package:architect_nexus/features/home/presentation/widgets/sync_error_banner.dart';
import 'package:architect_nexus/features/home/presentation/widgets/sync_status_chip.dart';
import 'package:architect_nexus/features/spark/domain/spark_event.dart';
import 'package:architect_nexus/features/spark/presentation/controllers/spark_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum HomeTab { home, explore, saved }

/// Home Screen - The Stream
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ScrollController _scrollController;
  bool _showBottomNav = true;
  HomeTab _activeTab = HomeTab.home;
  Timer? _idleTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _resetIdleTimer();
  }

  void _onScroll() {
    _resetIdleTimer();
    final direction = _scrollController.position.userScrollDirection;
    final isScrollingDown = direction == ScrollDirection.reverse;
    if (isScrollingDown && _showBottomNav) {
      setState(() => _showBottomNav = false);
    } else if (!isScrollingDown && !_showBottomNav) {
      setState(() => _showBottomNav = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _idleTimer?.cancel();
    super.dispose();
  }

  void _handleNavTap(int index) {
    _resetIdleTimer();
    if (index == 3) {
      context.push('/profile');
      return;
    }
    final targetTab = HomeTab.values[index];
    if (_activeTab == targetTab) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() => _activeTab = targetTab);
    }
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 5), () {
      ref.read(sparkControllerProvider.notifier).trigger(SparkEvent.scrollIdle);
    });
  }

  SliverAppBar _buildAppBar(WidgetRef ref, LearningSyncState syncState) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.backgroundPrimary.withValues(alpha: 0.9),
      title: Text(
        'NEXUS',
        style: AppTypography.h3.copyWith(color: AppColors.accentPrimary),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceSm),
          child: SyncStatusChip(
            state: syncState,
            onTap: () => ref.read(learningSyncControllerProvider.notifier).sync(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () => context.push('/profile'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeModulesAsync = ref.watch(learningModulesProvider);
    final exploreModulesAsync = ref.watch(exploreModulesProvider);
    final progressAsync = ref.watch(moduleProgressControllerProvider);
    final syncState = ref.watch(learningSyncControllerProvider);
    final bookmarkedIds = progressAsync.value?.bookmarkedModuleIds ?? const <String>{};
    final tabModulesAsync = switch (_activeTab) {
      HomeTab.home => homeModulesAsync,
      HomeTab.explore => exploreModulesAsync,
      HomeTab.saved => homeModulesAsync.whenData(
          (modules) => modules.where((module) => bookmarkedIds.contains(module.id)).toList(),
        ),
    };

    final dailyTitle = switch (_activeTab) {
      HomeTab.home => 'DAILY BYTE',
      HomeTab.explore => 'EXPLORE BYTE',
      HomeTab.saved => 'SAVED BYTE',
    };
    final carouselEmpty = switch (_activeTab) {
      HomeTab.home => 'Fresh bytes are syncing... check back shortly.',
      HomeTab.explore => 'Spark is mapping new missions. Try again in a beat.',
      HomeTab.saved => 'Bookmark short reads to pin them here.',
    };
    final feedEmpty = switch (_activeTab) {
      HomeTab.home => 'Spark is curating fresh content. Check back soon.',
      HomeTab.explore => 'No emerging missions yet. Pull to refresh.',
      HomeTab.saved => 'Save a module to see it here.',
    };

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            color: AppColors.accentPrimary,
            backgroundColor: AppColors.backgroundSecondary,
            onRefresh: () => ref.read(learningSyncControllerProvider.notifier).sync(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                _buildAppBar(ref, syncState),
                if (syncState.error != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
                      child: SyncErrorBanner(
                        message: syncState.error.toString(),
                        onRetry: () => ref.read(learningSyncControllerProvider.notifier).sync(),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: DailyByteCarousel(
                      modulesAsync: tabModulesAsync,
                      title: dailyTitle,
                      emptyMessage: carouselEmpty,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
                  sliver: ModuleFeed(
                    modulesAsync: tabModulesAsync,
                    emptyMessage: feedEmpty,
                    bookmarkedModuleIds: bookmarkedIds,
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: AppDimens.spaceXxl)),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showBottomNav ? 0 : -AppDimens.bottomNavHeight,
            left: 0,
            right: 0,
            child: GlassBottomNav(
              activeIndex: _activeTab.index,
              onItemSelected: _handleNavTap,
            ),
          ),
        ],
      ),
    );
  }
}
