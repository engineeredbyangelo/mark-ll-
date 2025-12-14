import 'package:architect_nexus/features/profile/data/datasources/progress_sync_queue_local_data_source.dart';
import 'package:architect_nexus/features/profile/data/datasources/user_progress_remote_data_source.dart';
import 'package:architect_nexus/features/profile/data/services/user_progress_sync_service.dart';
import 'package:architect_nexus/features/profile/domain/entities/user_progress.dart';
import 'package:architect_nexus/features/profile/presentation/controllers/user_progress_data_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProgressSyncState {
  const UserProgressSyncState({
    this.isSyncing = false,
    this.pendingCount = 0,
    this.nextAttemptAt,
    this.lastError,
  });

  final bool isSyncing;
  final int pendingCount;
  final DateTime? nextAttemptAt;
  final Object? lastError;

  UserProgressSyncState copyWith({
    bool? isSyncing,
    int? pendingCount,
    Object? nextAttemptAt = _sentinel,
    Object? lastError = _sentinel,
  }) {
    return UserProgressSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      nextAttemptAt: identical(nextAttemptAt, _sentinel)
          ? this.nextAttemptAt
          : nextAttemptAt as DateTime?,
      lastError: identical(lastError, _sentinel) ? this.lastError : lastError,
    );
  }
}

const _sentinel = Object();

final progressSyncQueueLocalDataSourceProvider = Provider<ProgressSyncQueueLocalDataSource>((ref) {
  return ProgressSyncQueueLocalDataSource();
});

final userProgressRemoteDataSourceProvider = Provider<UserProgressRemoteDataSource>((ref) {
  return UserProgressRemoteDataSource();
});

final userProgressSyncServiceProvider = Provider<UserProgressSyncService>((ref) {
  final local = ref.watch(userProgressLocalDataSourceProvider);
  final queue = ref.watch(progressSyncQueueLocalDataSourceProvider);
  final remote = ref.watch(userProgressRemoteDataSourceProvider);
  return UserProgressSyncService(
    localDataSource: local,
    queueLocalDataSource: queue,
    remoteDataSource: remote,
  );
});

final userProgressSyncControllerProvider =
    StateNotifierProvider<UserProgressSyncController, UserProgressSyncState>((ref) {
  final service = ref.watch(userProgressSyncServiceProvider);
  return UserProgressSyncController(service);
});

class UserProgressSyncController extends StateNotifier<UserProgressSyncState> {
  UserProgressSyncController(this._service) : super(const UserProgressSyncState()) {
    _hydrate();
  }

  final UserProgressSyncService _service;

  Future<void> _hydrate() async {
    final snapshot = await _service.describeQueue();
    state = state.copyWith(
      pendingCount: snapshot.pendingCount,
      nextAttemptAt: snapshot.nextAttemptAt,
    );
  }

  Future<void> enqueue(ModuleProgress progress) async {
    await _service.enqueue(progress);
    await _hydrate();
  }

  Future<void> flush({bool force = false}) async {
    if (state.isSyncing) {
      return;
    }
    state = state.copyWith(isSyncing: true, lastError: null);
    try {
      final report = await _service.processQueue(force: force);
      state = state.copyWith(
        isSyncing: false,
        pendingCount: report.pendingCount,
        nextAttemptAt: report.nextAttemptAt,
        lastError: report.lastError,
      );
    } catch (error) {
      state = state.copyWith(isSyncing: false, lastError: error);
    }
  }

  Future<void> flushIfDue() async {
    final nextAttempt = state.nextAttemptAt;
    if (nextAttempt == null || nextAttempt.isAfter(DateTime.now())) {
      return;
    }
    await flush();
  }
}
