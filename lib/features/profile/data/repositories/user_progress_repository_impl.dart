import 'package:architect_nexus/features/profile/data/datasources/user_progress_local_data_source.dart';
import 'package:architect_nexus/features/profile/data/models/module_progress_model.dart';
import 'package:architect_nexus/features/profile/domain/entities/user_progress.dart';
import 'package:architect_nexus/features/profile/domain/repositories/user_progress_repository.dart';

class UserProgressRepositoryImpl implements UserProgressRepository {
  UserProgressRepositoryImpl({required UserProgressLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final UserProgressLocalDataSource _localDataSource;

  @override
  Future<Map<String, ModuleProgress>> getAllProgress() async {
    final records = await _localDataSource.getAllProgress();
    return records.map((key, value) => MapEntry(key, value.toEntity()));
  }

  @override
  Future<ModuleProgress?> getProgress(String moduleId) async {
    final existing = await _localDataSource.getProgress(moduleId);
    return existing?.toEntity();
  }

  @override
  Future<void> saveProgress(ModuleProgress progress) {
    final model = ModuleProgressModel.fromEntity(progress);
    return _localDataSource.upsertProgress(model);
  }
}
