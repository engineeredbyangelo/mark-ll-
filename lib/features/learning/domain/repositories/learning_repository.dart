import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';
import 'package:architect_nexus/features/learning/domain/entities/module_detail.dart';

abstract class LearningRepository {
  Future<List<LearningModule>> getModules();

  Future<LearningModuleDetail> getModuleDetail(String moduleId);
}
