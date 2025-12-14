import 'dart:async';

import 'package:architect_nexus/features/profile/domain/entities/user_progress.dart';
import 'package:architect_nexus/features/profile/domain/repositories/user_progress_repository.dart';
import 'package:architect_nexus/features/profile/presentation/controllers/user_progress_data_providers.dart';
import 'package:architect_nexus/features/profile/presentation/controllers/user_progress_sync_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModuleProgressState {
  const ModuleProgressState({required this.progressByModule});

  final Map<String, ModuleProgress> progressByModule;

  ModuleProgress? progressFor(String moduleId) => progressByModule[moduleId];

  Set<String> get bookmarkedModuleIds => progressByModule.entries
      .where((entry) => entry.value.isBookmarked)
      .map((entry) => entry.key)
      .toSet();
}

final moduleProgressControllerProvider =
    StateNotifierProvider<ModuleProgressController, AsyncValue<ModuleProgressState>>((ref) {
  final repository = ref.watch(userProgressRepositoryProvider);
  final syncController = ref.watch(userProgressSyncControllerProvider.notifier);
  return ModuleProgressController(repository, syncController);
});

class ModuleProgressController extends StateNotifier<AsyncValue<ModuleProgressState>> {
  ModuleProgressController(this._repository, this._syncController)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final UserProgressRepository _repository;
  final UserProgressSyncController _syncController;

  Future<void> _load() async {
    try {
      final data = await _repository.getAllProgress();
      state = AsyncValue.data(ModuleProgressState(progressByModule: data));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> markSlide({
    required String moduleId,
    required int slideIndex,
    required int totalSlides,
  }) async {
    final previous = state.value?.progressByModule[moduleId];
    final normalizedTotal = totalSlides == 0 ? (previous?.totalSlides ?? 1) : totalSlides;
    final isCompleted = normalizedTotal > 0 && slideIndex >= normalizedTotal - 1;
    final progress = ModuleProgress(
      moduleId: moduleId,
      currentSlide: slideIndex,
      totalSlides: normalizedTotal,
      isCompleted: isCompleted || (previous?.isCompleted ?? false),
      completedAt: isCompleted ? (previous?.completedAt ?? DateTime.now()) : previous?.completedAt,
      lastAccessedAt: DateTime.now(),
      isBookmarked: previous?.isBookmarked ?? false,
    );
    _optimisticUpdate(progress);
    await _repository.saveProgress(progress);
    await _syncController.enqueue(progress);
    Future.microtask(() => _syncController.flushIfDue());
  }

  Future<void> toggleBookmark(String moduleId) async {
    final previous = state.value?.progressByModule[moduleId];
    final toggled = ModuleProgress(
      moduleId: moduleId,
      currentSlide: previous?.currentSlide ?? 0,
      totalSlides: previous?.totalSlides ?? 0,
      isCompleted: previous?.isCompleted ?? false,
      completedAt: previous?.completedAt,
      lastAccessedAt: DateTime.now(),
      isBookmarked: !(previous?.isBookmarked ?? false),
    );
    _optimisticUpdate(toggled);
    await _repository.saveProgress(toggled);
    await _syncController.enqueue(toggled);
    Future.microtask(() => _syncController.flushIfDue());
  }

  void _optimisticUpdate(ModuleProgress progress) {
    final current = Map<String, ModuleProgress>.from(state.value?.progressByModule ?? {});
    current[progress.moduleId] = progress;
    state = AsyncValue.data(ModuleProgressState(progressByModule: current));
  }
}
