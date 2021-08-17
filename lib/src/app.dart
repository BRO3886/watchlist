import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/src/navigation/router.gr.dart';
import 'package:watchlist/src/persistence/persistence.dart';
import 'package:watchlist/src/presentation/bloc/auth/auth_bloc.dart';

import 'di/di.dart';

class WatchList extends StatefulWidget {
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  late final AppRouter _appRouter;
  late final UserDAO _userDAO;
  late bool _isSignedIn;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
    _userDAO = getIt<UserDAO>();
    _isSignedIn = _userDAO.isSignedIn();
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: MaterialApp.router(
        routeInformationParser: _appRouter.defaultRouteParser(includePrefixMatches: true),
        routerDelegate: _appRouter.delegate(
          initialRoutes: [
            if (_isSignedIn) const HomeScreen(),
            if (!_isSignedIn) const AuthScreen(),
          ],
        ),
      ),
    );
  }
}
