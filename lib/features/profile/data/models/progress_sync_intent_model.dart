import 'package:architect_nexus/features/profile/domain/entities/progress_sync_intent.dart';
import 'package:hive/hive.dart';

class ProgressSyncIntentModel extends HiveObject {
  ProgressSyncIntentModel({
    required this.moduleId,
    required this.attemptCount,
    required this.enqueuedAt,
    required this.nextAttemptAt,
  });

  final String moduleId;
  final int attemptCount;
  final DateTime enqueuedAt;
  final DateTime nextAttemptAt;

  ProgressSyncIntent toEntity() {
    return ProgressSyncIntent(
      moduleId: moduleId,
      attemptCount: attemptCount,
      enqueuedAt: enqueuedAt,
      nextAttemptAt: nextAttemptAt,
    );
  }

  static ProgressSyncIntentModel fromEntity(ProgressSyncIntent intent) {
    return ProgressSyncIntentModel(
      moduleId: intent.moduleId,
      attemptCount: intent.attemptCount,
      enqueuedAt: intent.enqueuedAt,
      nextAttemptAt: intent.nextAttemptAt,
    );
  }

  ProgressSyncIntentModel copyWith({
    int? attemptCount,
    DateTime? enqueuedAt,
    DateTime? nextAttemptAt,
  }) {
    return ProgressSyncIntentModel(
      moduleId: moduleId,
      attemptCount: attemptCount ?? this.attemptCount,
      enqueuedAt: enqueuedAt ?? this.enqueuedAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    );
  }
}

class ProgressSyncIntentModelAdapter extends TypeAdapter<ProgressSyncIntentModel> {
  @override
  final int typeId = 4;

  @override
  ProgressSyncIntentModel read(BinaryReader reader) {
    final fields = reader.readMap().cast<String, dynamic>();
    return ProgressSyncIntentModel(
      moduleId: fields['moduleId'] as String,
      attemptCount: fields['attemptCount'] as int? ?? 0,
      enqueuedAt: DateTime.fromMillisecondsSinceEpoch(fields['enqueuedAt'] as int),
      nextAttemptAt: DateTime.fromMillisecondsSinceEpoch(fields['nextAttemptAt'] as int),
    );
  }

  @override
  void write(BinaryWriter writer, ProgressSyncIntentModel obj) {
    writer.writeMap({
      'moduleId': obj.moduleId,
      'attemptCount': obj.attemptCount,
      'enqueuedAt': obj.enqueuedAt.millisecondsSinceEpoch,
      'nextAttemptAt': obj.nextAttemptAt.millisecondsSinceEpoch,
    });
  }
}
