import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/app.dart';

Future<void> main() async {
  //This is the glue that binds the framework to the Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // set orientation lock
  const List<DeviceOrientation> orientations = [
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ];
  await SystemChrome.setPreferredOrientations(orientations);

  runApp(WatchList());
}
