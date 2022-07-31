import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AVAC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Geolocator is used to find velocity
  GeolocatorPlatform locator = GeolocatorPlatform.instance;
  double? _velocity = 0;
  double? _highestVelocity;
  late StreamController<double?> _velocityUpdatedStreamController;

  void initstate(){
    super.initState();
    _velocityUpdatedStreamController = StreamController<double?>();
    // Speedometer functionality. Updates any time velocity chages.
    _velocityUpdatedStreamController = StreamController<double?>();
    locator
        .getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
          ),
        )
        .listen(
          (Position position) => _onAccelerate(position.speed),
        );
        
    _velocity = 0;
    _highestVelocity = 0.0;
  }
  /// Callback that runs when velocity updates, which in turn updates stream.
  void _onAccelerate(double speed) {
    locator.getCurrentPosition().then(
      (Position updatedPosition) {
        _velocity = (speed + updatedPosition.speed) / 2;
        if (_velocity! > _highestVelocity!) _highestVelocity = _velocity;
        _velocityUpdatedStreamController.add(_velocity);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your velocity:',
            ),
            Text(
              '$_velocity',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text(
              'm/s',
            ),
          ],
        ),
      ), 
    );
  }
}
