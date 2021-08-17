import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/src/di/di.dart';
import 'package:watchlist/src/navigation/router.gr.dart';
import 'package:watchlist/src/persistence/persistence.dart';
import 'package:watchlist/src/presentation/bloc/auth/auth_bloc.dart';
import 'package:watchlist/src/presentation/theme/theme.dart';
import 'package:watchlist/src/presentation/wigets/snackbars.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userDAO = getIt<UserDAO>();
  late final AuthBloc _authBloc;
  late final String _photoURL;
  bool loading = false;

  @override
  void initState() {
    _photoURL = _userDAO.getPhoto() ?? 'https://katb.in/tail8728';
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Watchlist',
          style: headingText.copyWith(fontSize: 22),
        ),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   successSnackbar('Currently logged in as ${_userDAO.user?.name}'),
              // );
              showDialog(
                context: context,
                barrierDismissible: !loading,
                builder: (context) => AlertDialog(
                  title: const Text('Profile'),
                  content: ListTile(
                    title: Text(_userDAO.user?.name ?? 'Anon'),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_photoURL),
                    ),
                    subtitle: const Text('Description '),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        _authBloc.add(LogoutEvent());
                        setState(() {
                          loading = false;
                        });
                      },
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is LogoutSucces) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(successSnackbar('Logged out!'));
                            context.router.replace(const AuthScreen());
                          }
                          if (state is LogoutError) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(errorSnackbar(state.message));
                          }
                        },
                        builder: (context, state) {
                          if (state is LogoutLoading) {
                            return Container(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(brownOnYellow),
                              ),
                            );
                          }
                          return Text(
                            'Logout'.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: CircleAvatar(
              backgroundImage: NetworkImage(_photoURL),
            ),
          )
        ],
        backgroundColor: Colors.grey[100],
      ),
      body: const Center(
        child: Text('body'),
      ),
    );
  }
}
