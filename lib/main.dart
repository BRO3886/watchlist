import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watchlist/src/di/di.dart';
import 'package:watchlist/src/persistence/persistence.dart';

import 'src/app.dart';

Future<void> main() async {
  //This is the glue that binds the framework to the Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // register all dependecy injection
  getItInit();

  // init services
  await Firebase.initializeApp();
  await DBService.init();

  // set orientation lock
  const List<DeviceOrientation> orientations = [
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ];
  await SystemChrome.setPreferredOrientations(orientations);

  runApp(WatchList());
}
