import 'package:architect_nexus/features/profile/domain/entities/user_progress.dart';

abstract class UserProgressRepository {
  Future<Map<String, ModuleProgress>> getAllProgress();
  Future<ModuleProgress?> getProgress(String moduleId);
  Future<void> saveProgress(ModuleProgress progress);
}
