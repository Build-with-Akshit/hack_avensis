import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeService {
  final double _shakeThresholdGravity = 2.7;
  final int _minTimeBetweenShakes = 1000;
  int _lastShakeTime = 0;

  Function()? onShake;
  StreamSubscription? _subscription;

  void startListening() {
    _subscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      double gX = event.x / 9.80665;
      double gY = event.y / 9.80665;
      double gZ = event.z / 9.80665;

      // gForce will be close to 1 when there is no movement.
      double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > _shakeThresholdGravity) {
        final now = DateTime.now().millisecondsSinceEpoch;
        // Ignore shakes too close to each other (debounce)
        if (_lastShakeTime + _minTimeBetweenShakes > now) {
          return;
        }

        _lastShakeTime = now;
        if (kDebugMode) {
          print("SHAKE DETECTED! G-Force: $gForce");
        }

        onShake?.call();
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
}
