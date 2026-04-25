import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerWidget extends StatefulWidget {
  const AccelerometerWidget({super.key});

  @override
  State<AccelerometerWidget> createState() => _AccelerometerWidgetState();
}

class _AccelerometerWidgetState extends State<AccelerometerWidget> {
  AccelerometerEvent? _event;
  bool _shakeDetected = false;
  StreamSubscription? _sub;
  static const double _shakeThreshold = 15.0;

  @override
  void initState() {
    super.initState();
    _sub = accelerometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen((event) {
      final magnitude = math.sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      setState(() {
        _event = event;
        _shakeDetected = magnitude > _shakeThreshold;
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = _event;
    return Card(
      color: _shakeDetected ? Colors.red.shade50 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acelerómetro',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (e != null) ...[
              Text('X: ${e.x.toStringAsFixed(2)} m/s²'),
              Text('Y: ${e.y.toStringAsFixed(2)} m/s²'),
              Text('Z: ${e.z.toStringAsFixed(2)} m/s²'),
              if (_shakeDetected)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    '¡Agitación detectada!',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ] else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}