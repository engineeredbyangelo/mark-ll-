import 'package:architect_nexus/features/profile/data/datasources/user_progress_local_data_source.dart';
import 'package:architect_nexus/features/profile/data/repositories/user_progress_repository_impl.dart';
import 'package:architect_nexus/features/profile/domain/repositories/user_progress_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProgressLocalDataSourceProvider = Provider<UserProgressLocalDataSource>((ref) {
  return UserProgressLocalDataSource();
});

final userProgressRepositoryProvider = Provider<UserProgressRepository>((ref) {
  final dataSource = ref.watch(userProgressLocalDataSourceProvider);
  return UserProgressRepositoryImpl(localDataSource: dataSource);
});
