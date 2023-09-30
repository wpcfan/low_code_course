import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isAuth;
  final bool isLoading;
  final bool isFailure;
  final bool isSuccess;
  final String message;
  final String username;
  final String token;

  const AuthState({
    this.isAuth = false,
    this.isLoading = false,
    this.isFailure = false,
    this.isSuccess = false,
    this.message = '',
    this.username = '',
    this.token = '',
  });

  @override
  List<Object> get props => [
        isAuth,
        isLoading,
        isFailure,
        isSuccess,
        message,
        username,
        token,
      ];

  AuthState copyWith({
    bool? isAuth,
    bool? isLoading,
    bool? isFailure,
    bool? isSuccess,
    String? message,
    String? username,
    String? token,
  }) {
    return AuthState(
      isAuth: isAuth ?? this.isAuth,
      isLoading: isLoading ?? this.isLoading,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      username: username ?? this.username,
      token: token ?? this.token,
    );
  }
}
