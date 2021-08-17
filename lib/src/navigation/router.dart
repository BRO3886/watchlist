// @CupertinoAutoRouter
// @AdaptiveAutoRouter
// @CustomAutoRouter
import 'package:auto_route/auto_route.dart';
import 'package:watchlist/src/presentation/pages/auth/auth.dart';
import 'package:watchlist/src/presentation/pages/home/home.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: AuthScreen, path: '/auth'),
    AutoRoute(page: HomeScreen, path: '/home'),
  ],
)
class $AppRouter {}
