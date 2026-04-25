import 'package:flutter/material.dart';
import 'package:geosense/map_view.dart';
import 'package:geosense/accelerometer_widget.dart';

void main() {
  runApp(const GeoSenseApp());
}

class GeoSenseApp extends StatelessWidget {
  const GeoSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoSense'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MapView(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AccelerometerWidget(),
          ),
        ],
      ),
    );
  }
}