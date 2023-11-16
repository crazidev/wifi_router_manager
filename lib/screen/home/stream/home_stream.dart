import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:router_manager/controller/home_controller.dart';

final homeStreamProvider = StreamProvider.autoDispose<dynamic>((ref) {
  final streamController = homeStream(ref);

  // Add a disposal logic to close the stream when the provider is disposed
  ref.onDispose(() {
    streamController.close();
  });

  return streamController.stream;
});

final statusStreamProvider = StreamProvider.autoDispose<dynamic>((ref) {
  final streamController = statusStream(ref);

  // Add a disposal logic to close the stream when the provider is disposed
  ref.onDispose(() {
    streamController.close();
  });

  return streamController.stream;
});

// @riverpod
StreamController homeStream(StreamProviderRef ref) {
  late StreamController<dynamic> controller;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.read(homeProvider).startStream();
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  controller = StreamController(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller;
}

@riverpod
StreamController statusStream(StreamProviderRef ref) {
  late StreamController<dynamic> controller;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.read(homeProvider).statusStream();
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  controller = StreamController(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller;
}
