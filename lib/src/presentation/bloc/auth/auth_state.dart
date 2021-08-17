part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginError extends AuthState {
  final String message;

  const LoginError({
    required this.message,
  });
}

class LogoutLoading extends AuthState {}

class LogoutSucces extends AuthState {}

class LogoutError extends AuthState {
  final String message;

  const LogoutError({
    required this.message,
  });
}
