import 'package:architect_nexus/features/learning/data/datasources/learning_seed_data.dart';
import 'package:architect_nexus/features/learning/data/models/learning_module_model.dart';
import 'package:architect_nexus/features/learning/data/models/module_slide_model.dart';
import 'package:hive/hive.dart';

class LearningLocalDataSource {
  static const _modulesBox = 'learning_modules_box';
  static const _slidesBox = 'learning_module_slides_box';

  Future<List<LearningModuleModel>> getModules() async {
    final box = await _openModulesBox();
    await _seedModulesIfNeeded(box);
    return box.values.toList();
  }

  Future<LearningModuleModel?> getModuleById(String moduleId) async {
    final box = await _openModulesBox();
    await _seedModulesIfNeeded(box);
    for (final module in box.values) {
      if (module.id == moduleId) {
        return module;
      }
    }
    return null;
  }

  Future<List<ModuleSlideModel>> getSlides(String moduleId) async {
    final box = await _openSlidesBox();
    await _seedSlidesIfNeeded(box);
    return box.values.where((slide) => slide.moduleId == moduleId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<Box<LearningModuleModel>> _openModulesBox() async {
    _registerAdapters();
    if (Hive.isBoxOpen(_modulesBox)) {
      return Hive.box<LearningModuleModel>(_modulesBox);
    }
    return Hive.openBox<LearningModuleModel>(_modulesBox);
  }

  Future<Box<ModuleSlideModel>> _openSlidesBox() async {
    _registerAdapters();
    if (Hive.isBoxOpen(_slidesBox)) {
      return Hive.box<ModuleSlideModel>(_slidesBox);
    }
    return Hive.openBox<ModuleSlideModel>(_slidesBox);
  }

  Future<void> _seedModulesIfNeeded(Box<LearningModuleModel> box) async {
    if (box.isEmpty) {
      await box.addAll(seedLearningModules);
    }
  }

  Future<void> _seedSlidesIfNeeded(Box<ModuleSlideModel> box) async {
    if (box.isEmpty) {
      await box.addAll(seedLearningSlides);
    }
  }

  Future<void> cacheModules(List<LearningModuleModel> modules) async {
    final box = await _openModulesBox();
    await box.clear();
    await box.addAll(modules);
  }

  Future<void> cacheSlides(List<ModuleSlideModel> slides) async {
    final box = await _openSlidesBox();
    await box.clear();
    await box.addAll(slides);
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(LearningModuleModelAdapter().typeId)) {
      Hive.registerAdapter(LearningModuleModelAdapter());
    }
    if (!Hive.isAdapterRegistered(ModuleSlideModelAdapter().typeId)) {
      Hive.registerAdapter(ModuleSlideModelAdapter());
    }
  }
}
