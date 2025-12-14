import 'package:architect_nexus/features/profile/data/models/module_progress_model.dart';
import 'package:hive/hive.dart';

class UserProgressLocalDataSource {
  static const _boxName = 'module_progress_box';

  Future<Map<String, ModuleProgressModel>> getAllProgress() async {
    final box = await _openBox();
    return Map<String, ModuleProgressModel>.from(box.toMap().cast<String, ModuleProgressModel>());
  }

  Future<ModuleProgressModel?> getProgress(String moduleId) async {
    final box = await _openBox();
    return box.get(moduleId);
  }

  Future<void> upsertProgress(ModuleProgressModel progress) async {
    final box = await _openBox();
    await box.put(progress.moduleId, progress);
  }

  Future<Box<ModuleProgressModel>> _openBox() async {
    _registerAdapter();
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<ModuleProgressModel>(_boxName);
    }
    return Hive.openBox<ModuleProgressModel>(_boxName);
  }

  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(ModuleProgressModelAdapter().typeId)) {
      Hive.registerAdapter(ModuleProgressModelAdapter());
    }
  }
}
