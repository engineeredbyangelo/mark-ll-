import 'package:architect_nexus/features/learning/data/datasources/learning_remote_data_source.dart';
import 'package:architect_nexus/features/learning/data/services/learning_sync_service.dart';
import 'package:architect_nexus/features/learning/presentation/controllers/learning_providers.dart';
import 'package:architect_nexus/features/profile/presentation/controllers/user_progress_sync_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LearningSyncState {
  const LearningSyncState({
    this.isSyncing = false,
    this.lastSyncedAt,
    this.error,
  });

  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final Object? error;

  LearningSyncState copyWith({
    bool? isSyncing,
    DateTime? lastSyncedAt,
    Object? error = _sentinel,
  }) {
    return LearningSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      error: identical(error, _sentinel) ? this.error : error,
    );
  }
}

const _sentinel = Object();

final learningRemoteDataSourceProvider = Provider<LearningRemoteDataSource>((ref) {
  return LearningRemoteDataSource();
});

final learningSyncServiceProvider = Provider<LearningSyncService>((ref) {
  final local = ref.watch(learningLocalDataSourceProvider);
  final remote = ref.watch(learningRemoteDataSourceProvider);
  return LearningSyncService(localDataSource: local, remoteDataSource: remote);
});

final learningSyncControllerProvider =
    StateNotifierProvider<LearningSyncController, LearningSyncState>((ref) {
  final service = ref.watch(learningSyncServiceProvider);
  return LearningSyncController(ref, service);
});

class LearningSyncController extends StateNotifier<LearningSyncState> {
  LearningSyncController(this._ref, this._service)
      : super(const LearningSyncState(isSyncing: false));

  final Ref _ref;
  final LearningSyncService _service;

  Future<void> sync() async {
    if (state.isSyncing) {
      return;
    }
    state = state.copyWith(isSyncing: true, error: null);
    Object? syncError;
    try {
      await _service.sync();
    } catch (error) {
      syncError = error;
    }

    try {
      await _ref.read(userProgressSyncControllerProvider.notifier).flush(force: true);
    } catch (error) {
      syncError ??= error;
    }

    if (syncError == null) {
      state = state.copyWith(
        isSyncing: false,
        lastSyncedAt: DateTime.now(),
        error: null,
      );
      _ref.invalidate(learningModulesProvider);
      _ref.invalidate(learningModuleDetailProvider);
    } else {
      state = state.copyWith(isSyncing: false, error: syncError);
    }
  }
}
