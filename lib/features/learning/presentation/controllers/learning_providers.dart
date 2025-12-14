import 'package:architect_nexus/features/learning/data/datasources/learning_local_data_source.dart';
import 'package:architect_nexus/features/learning/data/repositories/learning_repository_impl.dart';
import 'package:architect_nexus/features/learning/domain/entities/learning_module.dart';
import 'package:architect_nexus/features/learning/domain/entities/module_detail.dart';
import 'package:architect_nexus/features/learning/domain/repositories/learning_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final learningLocalDataSourceProvider = Provider<LearningLocalDataSource>((ref) {
  return LearningLocalDataSource();
});

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  final dataSource = ref.watch(learningLocalDataSourceProvider);
  return LearningRepositoryImpl(localDataSource: dataSource);
});

final learningModulesProvider = FutureProvider<List<LearningModule>>((ref) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getModules();
});

final exploreModulesProvider = FutureProvider<List<LearningModule>>((ref) async {
  final modules = await ref.watch(learningModulesProvider.future);
  final curated = modules
      .where((module) => module.isExploreCurated)
      .toList()
    ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  if (curated.isNotEmpty) {
    return curated;
  }
  final fallback = [...modules]
    ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  return fallback.take(4).toList();
});

final learningModuleDetailProvider = FutureProvider.family<LearningModuleDetail, String>((ref, moduleId) async {
  final repository = ref.watch(learningRepositoryProvider);
  return repository.getModuleDetail(moduleId);
});
