import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/src/navigation/router.gr.dart';
import 'package:watchlist/src/presentation/bloc/bloc.dart';
import 'package:watchlist/src/presentation/theme/theme.dart';
import 'package:watchlist/src/presentation/wigets/snackbars.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Watchlist',
              style: headingText,
            ),
            const Text(
              'An app to help you keep track of your watchlist\nMade as a task for Yellow Class.',
              style: subtitleText,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            Align(
              child: Image.asset(
                ImageAssets.personWithLaptop,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(20),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(errorSnackbar(state.message));
            }
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(successSnackbar('Logged in!'));
              context.router.replace(const HomeScreen());
            }
          },
          child: ElevatedButton(
            onPressed: () {
              final authbloc = BlocProvider.of<AuthBloc>(context);
              authbloc.add(LoginEvent());
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is LoginLoading) {
                  return Container(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(brownOnYellow),
                    ),
                  );
                }
                return Text(
                  'Login With Google'.toUpperCase(),
                  style: Theme.of(context).textTheme.button!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: brownOnYellow,
                      ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
