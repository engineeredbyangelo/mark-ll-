import 'dart:async';

import 'package:architect_nexus/features/spark/domain/spark_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SparkState {
  const SparkState({this.activeEvent, this.lastTriggeredAt});

  final SparkEvent? activeEvent;
  final DateTime? lastTriggeredAt;

  bool get isVisible => activeEvent != null;
}

final sparkControllerProvider = StateNotifierProvider<SparkController, SparkState>((ref) {
  return SparkController();
});

class SparkController extends StateNotifier<SparkState> {
  SparkController() : super(const SparkState());

  Timer? _hideTimer;

  void trigger(SparkEvent event) {
    _hideTimer?.cancel();
    state = SparkState(activeEvent: event, lastTriggeredAt: DateTime.now());
    _hideTimer = Timer(event.displayDuration, () {
      state = const SparkState();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }
}
