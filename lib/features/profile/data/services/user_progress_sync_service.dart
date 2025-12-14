import 'dart:math';

import 'package:architect_nexus/features/profile/data/datasources/progress_sync_queue_local_data_source.dart';
import 'package:architect_nexus/features/profile/data/datasources/user_progress_local_data_source.dart';
import 'package:architect_nexus/features/profile/data/datasources/user_progress_remote_data_source.dart';
import 'package:architect_nexus/features/profile/data/models/module_progress_model.dart';
import 'package:architect_nexus/features/profile/data/models/progress_sync_intent_model.dart';
import 'package:architect_nexus/features/profile/domain/entities/user_progress.dart';

class ProgressSyncReport {
  const ProgressSyncReport({
    required this.pendingCount,
    required this.successCount,
    required this.failureCount,
    this.lastError,
    this.nextAttemptAt,
  });

  final int pendingCount;
  final int successCount;
  final int failureCount;
  final Object? lastError;
  final DateTime? nextAttemptAt;
}

class UserProgressSyncService {
  UserProgressSyncService({
    required UserProgressLocalDataSource localDataSource,
    required ProgressSyncQueueLocalDataSource queueLocalDataSource,
    required UserProgressRemoteDataSource remoteDataSource,
    Duration baseDelay = const Duration(seconds: 2),
    Duration maxDelay = const Duration(minutes: 2),
    Random? random,
  })  : _localDataSource = localDataSource,
        _queueLocalDataSource = queueLocalDataSource,
        _remoteDataSource = remoteDataSource,
        _baseDelay = baseDelay,
        _maxDelay = maxDelay,
        _random = random ?? Random();

  final UserProgressLocalDataSource _localDataSource;
  final ProgressSyncQueueLocalDataSource _queueLocalDataSource;
  final UserProgressRemoteDataSource _remoteDataSource;
  final Duration _baseDelay;
  final Duration _maxDelay;
  final Random _random;

  Future<void> enqueue(ModuleProgress progress) async {
    final intent = ProgressSyncIntentModel(
      moduleId: progress.moduleId,
      attemptCount: 0,
      enqueuedAt: DateTime.now(),
      nextAttemptAt: DateTime.now(),
    );
    await _queueLocalDataSource.upsertIntent(intent);
  }

  Future<ProgressSyncReport> processQueue({bool force = false}) async {
    final intents = await _queueLocalDataSource.getIntents();
    var successCount = 0;
    var failureCount = 0;
    Object? lastError;

    final now = DateTime.now();
    for (final intent in intents) {
      if (!force && intent.nextAttemptAt.isAfter(now)) {
        continue;
      }

      final ModuleProgressModel? progressModel = await _localDataSource.getProgress(intent.moduleId);
      if (progressModel == null) {
        await _queueLocalDataSource.removeIntent(intent.moduleId);
        continue;
      }

      try {
        await _remoteDataSource.pushProgress(progressModel);
        await _queueLocalDataSource.removeIntent(intent.moduleId);
        successCount += 1;
      } catch (error) {
        failureCount += 1;
        lastError = error;
        final nextIntent = intent.copyWith(
          attemptCount: intent.attemptCount + 1,
          nextAttemptAt: now.add(_nextDelay(intent.attemptCount + 1)),
        );
        await _queueLocalDataSource.upsertIntent(nextIntent);
      }
    }

    final remaining = await _queueLocalDataSource.getIntents();
    final nextAttemptAt = _computeNextAttemptAt(remaining);
    return ProgressSyncReport(
      pendingCount: remaining.length,
      successCount: successCount,
      failureCount: failureCount,
      lastError: lastError,
      nextAttemptAt: nextAttemptAt,
    );
  }

  Future<ProgressSyncReport> describeQueue() async {
    final intents = await _queueLocalDataSource.getIntents();
    return ProgressSyncReport(
      pendingCount: intents.length,
      successCount: 0,
      failureCount: 0,
      lastError: null,
      nextAttemptAt: _computeNextAttemptAt(intents),
    );
  }

  Duration _nextDelay(int attempt) {
    final baseMillis = _baseDelay.inMilliseconds;
    final maxMillis = _maxDelay.inMilliseconds;
    final growth = 1 << (attempt - 1);
    final scaled = baseMillis * growth;
    final capped = scaled > maxMillis ? maxMillis : scaled;
    final jitter = _random.nextInt(baseMillis + 1);
    final total = (capped + jitter).clamp(baseMillis, maxMillis);
    return Duration(milliseconds: total);
  }

  DateTime? _computeNextAttemptAt(List<ProgressSyncIntentModel> intents) {
    if (intents.isEmpty) {
      return null;
    }
    intents.sort((a, b) => a.nextAttemptAt.compareTo(b.nextAttemptAt));
    return intents.first.nextAttemptAt;
  }
}
