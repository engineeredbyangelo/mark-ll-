class ProgressSyncIntent {
  const ProgressSyncIntent({
    required this.moduleId,
    required this.attemptCount,
    required this.enqueuedAt,
    required this.nextAttemptAt,
  });

  final String moduleId;
  final int attemptCount;
  final DateTime enqueuedAt;
  final DateTime nextAttemptAt;

  ProgressSyncIntent copyWith({
    int? attemptCount,
    DateTime? enqueuedAt,
    DateTime? nextAttemptAt,
  }) {
    return ProgressSyncIntent(
      moduleId: moduleId,
      attemptCount: attemptCount ?? this.attemptCount,
      enqueuedAt: enqueuedAt ?? this.enqueuedAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    );
  }
}
