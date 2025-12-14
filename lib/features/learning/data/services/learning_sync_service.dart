import 'package:architect_nexus/features/learning/data/datasources/learning_local_data_source.dart';
import 'package:architect_nexus/features/learning/data/datasources/learning_remote_data_source.dart';

class LearningSyncService {
  LearningSyncService({
    required LearningLocalDataSource localDataSource,
    required LearningRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final LearningLocalDataSource _localDataSource;
  final LearningRemoteDataSource _remoteDataSource;

  Future<void> sync() async {
    final modules = await _remoteDataSource.fetchModules();
    final slides = await _remoteDataSource.fetchSlides();
    await _localDataSource.cacheModules(modules);
    await _localDataSource.cacheSlides(slides);
  }
}
