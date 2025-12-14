import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';

/// Aggregate of a module with its slides
class LearningModuleDetail {
  final LearningModule module;
  final List<ModuleSlide> slides;

  const LearningModuleDetail({
    required this.module,
    required this.slides,
  });
}
