part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailStarted extends LoginEvent {
  LoginEmailStarted({@required this.email, @required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class LoginGoogleStarted extends LoginEvent {}

class LoginFacebookStarted extends LoginEvent {}
