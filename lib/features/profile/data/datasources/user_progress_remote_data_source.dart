import 'dart:math';

import 'package:architect_nexus/features/profile/data/models/module_progress_model.dart';

class UserProgressRemoteDataSource {
  UserProgressRemoteDataSource({Random? random}) : _random = random ?? Random();

  final Random _random;
  final Map<String, ModuleProgressModel> _remoteStore = {};

  Future<void> pushProgress(ModuleProgressModel progress) async {
    await Future.delayed(_simulatedNetworkDelay());
    _maybeFail();
    _remoteStore[progress.moduleId] = progress;
  }

  Future<List<ModuleProgressModel>> pullProgress() async {
    await Future.delayed(_simulatedNetworkDelay());
    _maybeFail();
    return _remoteStore.values.toList();
  }

  Duration _simulatedNetworkDelay() {
    return Duration(milliseconds: 400 + _random.nextInt(400));
  }

  void _maybeFail() {
    if (_random.nextDouble() < 0.15) {
      throw ProgressSyncException('Network drop detected');
    }
  }
}

class ProgressSyncException implements Exception {
  ProgressSyncException(this.message);

  final String message;

  @override
  String toString() => 'ProgressSyncException: $message';
}
