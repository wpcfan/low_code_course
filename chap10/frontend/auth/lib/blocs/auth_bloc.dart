import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<AuthEventLogin>(_onLogin);
  }

  void _onLogin(
    AuthEventLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final token = await authRepository.login(
        username: event.username,
        password: event.password,
      );
      emit(state.copyWith(
        isAuth: true,
        isLoading: false,
        isSuccess: true,
        message: 'Login success',
        username: event.username,
        token: token,
      ));
    } catch (e) {
      emit(state.copyWith(
        isAuth: false,
        isLoading: false,
        isFailure: true,
        message: 'Login failure',
        token: '',
      ));
    }
  }
}
