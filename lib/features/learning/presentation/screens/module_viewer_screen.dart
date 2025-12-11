import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';

/// Module Viewer Screen - Flow State View
/// Goal: Replace scrolling articles with interactive slides
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
  final PageController _pageController = PageController();
  int _currentSlide = 0;
  final int _totalSlides = 8; // Mock data

  void _nextSlide() {
    if (_currentSlide < _totalSlides - 1) {
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

  void _onSlideComplete() {
    // Haptic reward when completing module
    HapticFeedback.mediumImpact();
    
    // TODO: Save progress to cache
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              'Module Complete! 🎉',
              style: AppTypography.bodyMedium,
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
    return Scaffold(
      body: Stack(
        children: [
          // Slide Content
          GestureDetector(
            onTapUp: (details) {
              final screenWidth = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx > screenWidth * 0.7) {
                _nextSlide();
              } else if (details.globalPosition.dx < screenWidth * 0.3) {
                _previousSlide();
              }
            },
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentSlide = index);
                if (index == _totalSlides - 1) {
                  _onSlideComplete();
                }
              },
              itemCount: _totalSlides,
              itemBuilder: (context, index) {
                return _buildSlide(index);
              },
            ),
          ),
          
          // Progress Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                height: 4,
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
                  widthFactor: (_currentSlide + 1) / _totalSlides,
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
          
          // Top Bar
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
                        '${_currentSlide + 1}/$_totalSlides',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.accentPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_outline),
                      onPressed: () {
                        // TODO: Save to cache
                      },
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
  }

  Widget _buildSlide(int index) {
    // Mock slide types
    if (index == 0) {
      return _TitleSlide();
    } else if (index % 3 == 0) {
      return _CodeSlide(slideNumber: index);
    } else {
      return _ContentSlide(slideNumber: index);
    }
  }
}

class _TitleSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: AppColors.accentSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: Text(
              'INTERMEDIATE',
              style: AppTypography.caption.copyWith(
                color: AppColors.accentSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Text(
            'BUILDING YOUR FIRST\nNEURAL NETWORK',
            style: AppTypography.h1.copyWith(fontSize: 36),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Text(
            'A hands-on guide to understanding the fundamentals of deep learning',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                size: AppDimens.iconSm,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimens.spaceXs),
              Text(
                '12 min read',
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
  final int slideNumber;
  
  const _ContentSlide({required this.slideNumber});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // Space for progress bar
          Text(
            'Understanding Neural Networks',
            style: AppTypography.h2,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Text(
            'A neural network is a series of algorithms that endeavors to recognize underlying relationships in a set of data through a process that mimics the way the human brain operates.',
            style: AppTypography.bodyLarge.copyWith(height: 1.8),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Text(
            'In this module, you\'ll learn:',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          ...[
            'The basic structure of a neural network',
            'How neurons process information',
            'Activation functions and their importance',
            'Training through backpropagation',
          ].map((item) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.accentPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Text(
                    item,
                    style: AppTypography.bodyMedium.copyWith(height: 1.6),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _CodeSlide extends StatelessWidget {
  final int slideNumber;
  
  const _CodeSlide({required this.slideNumber});

  @override
  Widget build(BuildContext context) {
    const code = '''import numpy as np

# Define a simple neural network
class NeuralNetwork:
    def __init__(self):
        self.weights = np.random.rand(2, 1)
    
    def forward(self, X):
        return self.sigmoid(np.dot(X, self.weights))
    
    def sigmoid(self, x):
        return 1 / (1 + np.exp(-x))
''';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          Text(
            'Code Example',
            style: AppTypography.h3,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Text(
            'Here\'s a basic implementation of a neural network in Python:',
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
                color: AppColors.accentSecondary.withOpacity(0.3),
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
                        color: AppColors.accentSecondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                      ),
                      child: Text(
                        'Python',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.accentSecondary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: code));
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
