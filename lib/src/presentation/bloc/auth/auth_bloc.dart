import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:watchlist/src/di/di.dart';
import 'package:watchlist/src/network/user_service.dart';
import 'package:watchlist/src/persistence/models/user.dart' as db;
import 'package:watchlist/src/persistence/persistence.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserDAO _dao;
  final UserRepository _repository;
  AuthBloc({UserRepository? repository, UserDAO? dao})
      : _dao = dao ?? getIt<UserDAO>(),
        _repository = repository ?? UserRepository(signIn: GoogleSignIn()),
        super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield* _mapLoginEventToState();
    } else if (event is LogoutEvent) {
      yield* _mapLogoutEventToState();
    }
  }

  Stream<AuthState> _mapLoginEventToState() async* {
    yield LoginLoading();
    try {
      final UserCredential? userCred = await _repository.signInWithGoogle();

      if (userCred == null) {
        yield const LoginError(message: 'Unable to login with Google');
        return;
      }

      final UserCredential u = userCred;
      final user = db.User(
        name: u.user?.displayName,
        isSignedIn: true,
        photoURL: u.user?.photoURL,
      );

      await _dao.setUser(user);

      yield LoginSuccess();
    } catch (e) {
      yield const LoginError(message: 'Unable to login with Google');
    }
  }

  Stream<AuthState> _mapLogoutEventToState() async* {
    yield LoginLoading();
    try {
      if (await _repository.isSignedIn()) {
        await _repository.signOut();
      }
      _dao.user?.delete();
      yield LogoutSucces();
    } catch (e) {
      yield const LogoutError(message: 'Unable to logout');
    }
  }
}
