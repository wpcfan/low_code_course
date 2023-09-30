import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthEventLogin extends AuthEvent {
  final String username;
  final String password;

  const AuthEventLogin(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}
