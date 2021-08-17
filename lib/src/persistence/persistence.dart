import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watchlist/src/persistence/models/user.dart';

class DBService {
  static Future<void> init() async {
    // storage loc
    final _appDocumentDirectory = await getApplicationSupportDirectory();
    // init hive
    await Hive.initFlutter(_appDocumentDirectory.path);
    // register adapter
    Hive.registerAdapter(UserAdapter());
    // open box
    await Hive.openBox<User>(USER_BOX);
  }

  static const String USER_BOX = 'userBox';
}

@lazySingleton
class UserDAO {
  final box = Hive.box<User>(DBService.USER_BOX);
  static const String userKey = 'user';

  User? get user => box.get(userKey);

  Future<void> setUser(User u) async {
    await box.put(userKey, u);
  }

  bool isSignedIn() {
    final u = box.get(userKey);
    return u?.isSignedIn ?? false;
  }

  String? getPhoto() {
    final u = box.get(userKey);
    return u?.photoURL;
  }
}
