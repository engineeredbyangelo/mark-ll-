import 'package:architect_nexus/features/learning/data/datasources/learning_local_data_source.dart';
import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';
import 'package:architect_nexus/features/learning/domain/entities/module_detail.dart';
import 'package:architect_nexus/features/learning/domain/repositories/learning_repository.dart';

class LearningRepositoryImpl implements LearningRepository {
  LearningRepositoryImpl({required LearningLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final LearningLocalDataSource _localDataSource;

  @override
  Future<List<LearningModule>> getModules() async {
    final modules = await _localDataSource.getModules();
    return modules.map((module) => module.toEntity()).toList();
  }

  @override
  Future<LearningModuleDetail> getModuleDetail(String moduleId) async {
    final moduleModel = await _localDataSource.getModuleById(moduleId);
    if (moduleModel == null) {
      throw StateError('Module $moduleId not found');
    }
    final slideModels = await _localDataSource.getSlides(moduleId);
    return LearningModuleDetail(
      module: moduleModel.toEntity(),
      slides: slideModels.map((slide) => slide.toEntity()).toList(),
    );
  }
}
