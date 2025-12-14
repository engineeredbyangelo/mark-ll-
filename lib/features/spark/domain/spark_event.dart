enum SparkEvent {
  appLaunch,
  scrollIdle,
  moduleComplete,
}

extension SparkEventMetadata on SparkEvent {
  Duration get displayDuration {
    switch (this) {
      case SparkEvent.appLaunch:
        return const Duration(seconds: 3);
      case SparkEvent.scrollIdle:
        return const Duration(seconds: 2);
      case SparkEvent.moduleComplete:
        return const Duration(seconds: 4);
    }
  }

  String get headline {
    switch (this) {
      case SparkEvent.appLaunch:
        return 'Spark online';
      case SparkEvent.scrollIdle:
        return 'Need a boost?';
      case SparkEvent.moduleComplete:
        return 'Module cleared!';
    }
  }

  String get subtext {
    switch (this) {
      case SparkEvent.appLaunch:
        return 'Flow State warming up.';
      case SparkEvent.scrollIdle:
        return 'Spark spotted a pause. Ready for guidance?';
      case SparkEvent.moduleComplete:
        return 'Energy synced. Queue up the next mission.';
    }
  }
}
