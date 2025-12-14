import 'package:architect_nexus/features/profile/data/models/progress_sync_intent_model.dart';
import 'package:hive/hive.dart';

class ProgressSyncQueueLocalDataSource {
  static const _boxName = 'progress_sync_queue_box';

  Future<List<ProgressSyncIntentModel>> getIntents() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> upsertIntent(ProgressSyncIntentModel intent) async {
    final box = await _openBox();
    await box.put(intent.moduleId, intent);
  }

  Future<void> removeIntent(String moduleId) async {
    final box = await _openBox();
    await box.delete(moduleId);
  }

  Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }

  Future<Box<ProgressSyncIntentModel>> _openBox() async {
    _registerAdapter();
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<ProgressSyncIntentModel>(_boxName);
    }
    return Hive.openBox<ProgressSyncIntentModel>(_boxName);
  }

  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(ProgressSyncIntentModelAdapter().typeId)) {
      Hive.registerAdapter(ProgressSyncIntentModelAdapter());
    }
  }
}
