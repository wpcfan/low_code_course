import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  final Function(String)? onLoginSuccess;
  final Function(String)? onLoginFailure;
  const LoginPage({
    super.key,
    this.onLoginSuccess,
    this.onLoginFailure,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepository(),
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        ),
        child: Builder(
          builder: (context) {
            return BlocConsumer<AuthBloc, AuthState>(
              bloc: context.read<AuthBloc>(),
              listener: (context, state) {
                if (state.isSuccess && state.token.isNotEmpty) {
                  onLoginSuccess?.call(state.token);
                }
                if (state.isFailure) {
                  onLoginFailure?.call(state.message);
                }
              },
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('用户登录'),
                  ),
                  body: LoginForm(
                    onLogin: (username, password) {
                      context.read<AuthBloc>().add(
                            AuthEventLogin(username, password),
                          );
                    },
                  ).padding(all: 16).constrained(maxWidth: 400).center(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
