import 'package:architect_nexus/core/theme/app_colors.dart';
import 'package:architect_nexus/core/theme/app_dimens.dart';
import 'package:architect_nexus/core/theme/app_typography.dart';
import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';
import 'package:architect_nexus/features/learning/presentation/controllers/learning_providers.dart';
import 'package:architect_nexus/features/profile/presentation/controllers/user_progress_providers.dart';
import 'package:architect_nexus/features/spark/domain/spark_event.dart';
import 'package:architect_nexus/features/spark/presentation/controllers/spark_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModuleViewerScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const ModuleViewerScreen({
    super.key,
    required this.moduleId,
  });

  @override
  ConsumerState<ModuleViewerScreen> createState() => _ModuleViewerScreenState();
}

class _ModuleViewerScreenState extends ConsumerState<ModuleViewerScreen> {
  late final PageController _pageController;
  int _currentSlide = 0;
  bool _initialProgressApplied = false;
  bool _initialProgressRecorded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _nextSlide(int totalSlides) {
    if (_currentSlide < totalSlides - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      HapticFeedback.selectionClick();
    }
  }

  void _previousSlide() {
    if (_currentSlide > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      HapticFeedback.selectionClick();
    }
  }

  void _onSlideComplete(String moduleTitle) {
    HapticFeedback.mediumImpact();
    ref.read(sparkControllerProvider.notifier).trigger(SparkEvent.moduleComplete);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: AppDimens.spaceSm),
            Flexible(
              child: Text(
                '$moduleTitle complete! 🎉',
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.backgroundSecondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(learningModuleDetailProvider(widget.moduleId));
    final progressAsync = ref.watch(moduleProgressControllerProvider);

    return detailAsync.when(
      data: (detail) {
        final slides = detail.slides;
        if (slides.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No slides available')),
          );
        }

        final module = detail.module;
        final totalSlides = slides.length;
        if (_currentSlide >= totalSlides) {
          _currentSlide = totalSlides - 1;
        }
        final progressState = progressAsync.value;
        _applyStoredProgress(progressState, module.id, totalSlides);
        _seedInitialProgress(progressState, module.id, totalSlides);

        final isBookmarked = progressAsync.maybeWhen(
          data: (state) => state.progressFor(module.id)?.isBookmarked ?? false,
          orElse: () => false,
        );

        return Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                onTapUp: (details) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  if (details.globalPosition.dx > screenWidth * 0.7) {
                    _nextSlide(totalSlides);
                  } else if (details.globalPosition.dx < screenWidth * 0.3) {
                    _previousSlide();
                  }
                },
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentSlide = index);
                    _markProgress(module.id, index, totalSlides);
                    if (index == totalSlides - 1) {
                      _onSlideComplete(module.title);
                    }
                  },
                  itemCount: totalSlides,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return _buildSlide(module, slide);
                  },
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    height: AppDimens.progressBarHeight,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceMd,
                      vertical: AppDimens.spaceSm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_currentSlide + 1) / totalSlides,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.accentPrimary,
                              AppColors.accentSecondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.glassOverlay,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.spaceMd,
                            vertical: AppDimens.spaceSm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.glassOverlay,
                            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                          ),
                          child: Text(
                            '${_currentSlide + 1}/$totalSlides',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accentPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_outline),
                          onPressed: () => _toggleBookmark(module.id),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.glassOverlay,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(
          child: Text('Unable to load module: $error'),
        ),
      ),
    );
  }

  Widget _buildSlide(LearningModule module, ModuleSlide slide) {
    if (slide.order == 0) {
      return _TitleSlide(
        module: module,
        slideTitle: slide.title,
        description: slide.content,
      );
    }

    switch (slide.type) {
      case SlideType.code:
        return _CodeSlide(slide: slide);
      case SlideType.image:
        return _ImageSlide(slide: slide);
      case SlideType.interactive:
      case SlideType.text:
        return _ContentSlide(slide: slide);
    }
  }

  void _markProgress(String moduleId, int slideIndex, int totalSlides) {
    ref.read(moduleProgressControllerProvider.notifier).markSlide(
          moduleId: moduleId,
          slideIndex: slideIndex,
          totalSlides: totalSlides,
        );
  }

  void _toggleBookmark(String moduleId) {
    ref.read(moduleProgressControllerProvider.notifier).toggleBookmark(moduleId);
  }

  void _applyStoredProgress(
    ModuleProgressState? state,
    String moduleId,
    int totalSlides,
  ) {
    if (state == null || _initialProgressApplied || totalSlides <= 0) {
      return;
    }
    final stored = state.progressFor(moduleId);
    if (stored == null) {
      return;
    }
    final target = stored.currentSlide.clamp(0, totalSlides - 1);
    _initialProgressApplied = true;
    _currentSlide = target;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(target);
      }
    });
    _markProgress(moduleId, target, totalSlides);
  }

  void _seedInitialProgress(
    ModuleProgressState? state,
    String moduleId,
    int totalSlides,
  ) {
    if (_initialProgressRecorded || totalSlides <= 0 || state == null) {
      return;
    }
    final existing = state.progressFor(moduleId);
    _initialProgressRecorded = true;
    if (existing != null) {
      return;
    }
    _markProgress(moduleId, 0, totalSlides);
  }
}

class _TitleSlide extends StatelessWidget {
  const _TitleSlide({
    required this.module,
    required this.slideTitle,
    required this.description,
  });

  final LearningModule module;
  final String slideTitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentPrimary.withValues(alpha: 0.2),
            AppColors.accentSecondary.withValues(alpha: 0.2),
          ],
        ),
      ),
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceSm,
            ),
            decoration: BoxDecoration(
              color: AppColors.accentSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: Text(
              module.difficulty.name.toUpperCase(),
              style: AppTypography.caption.copyWith(
                color: AppColors.accentSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Text(
            slideTitle.toUpperCase(),
            style: AppTypography.h1.copyWith(fontSize: 36),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Text(
            description,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                size: AppDimens.iconSm,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimens.spaceXs),
              Text(
                '${module.estimatedMinutes} min read',
                style: AppTypography.bodyMedium.copyWith(
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

class _ContentSlide extends StatelessWidget {
  const _ContentSlide({required this.slide});

  final ModuleSlide slide;

  @override
  Widget build(BuildContext context) {
    final paragraphs = slide.content.split('\n\n');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spaceXl),
          Text(
            slide.title,
            style: AppTypography.h2,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          ...paragraphs.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
              child: Text(
                paragraph,
                style: AppTypography.bodyLarge.copyWith(height: 1.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeSlide extends StatelessWidget {
  const _CodeSlide({required this.slide});

  final ModuleSlide slide;

  @override
  Widget build(BuildContext context) {
    final code = slide.codeSnippet ?? '';
    final languageLabel = slide.codeLanguage?.toUpperCase() ?? 'CODE';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spaceXl),
          Text(
            slide.title,
            style: AppTypography.h3,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Text(
            slide.content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              border: Border.all(
                color: AppColors.accentSecondary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceSm,
                        vertical: AppDimens.spaceXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                      ),
                      child: Text(
                        languageLabel,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.accentSecondary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: AppDimens.iconSm),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: code));
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Code copied!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceSm),
                Text(
                  code,
                  style: AppTypography.code.copyWith(
                    color: AppColors.textPrimary,
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

class _ImageSlide extends StatelessWidget {
  const _ImageSlide({required this.slide});

  final ModuleSlide slide;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spaceXl),
          Text(
            slide.title,
            style: AppTypography.h3,
          ),
          const SizedBox(height: AppDimens.spaceSm),
          if (slide.imageUrl != null)
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                border: Border.all(
                  color: AppColors.accentPrimary.withValues(alpha: 0.3),
                ),
                image: DecorationImage(
                  image: AssetImage(slide.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                border: Border.all(
                  color: AppColors.accentPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  color: AppColors.textSecondary,
                  size: AppDimens.iconLg,
                ),
              ),
            ),
          const SizedBox(height: AppDimens.spaceLg),
          Text(
            slide.content,
            style: AppTypography.bodyLarge,
          ),
        ],
      ),
    );
  }
}
