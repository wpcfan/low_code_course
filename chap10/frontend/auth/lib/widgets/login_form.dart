import 'package:flutter/material.dart';
import 'package:forms/forms.dart';

class Login {
  final String? username;
  final String? password;

  const Login({
    this.username,
    this.password,
  });

  Login copyWith({
    String? username,
    String? password,
  }) {
    return Login(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}

class LoginForm extends StatefulWidget {
  final Function(String, String)? onLogin;
  const LoginForm({
    super.key,
    this.onLogin,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  Login _formValue = const Login();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          MyTextFormField(
            label: '用户名',
            validators: [
              Validators.required(label: '用户名', value: '请输入用户名'),
            ],
            onSaved: (newValue) {
              setState(() {
                _formValue = _formValue.copyWith(username: newValue);
              });
            },
          ),
          MyTextFormField(
            label: '密码',
            obscureText: true,
            validators: [
              Validators.required(label: '密码', value: '请输入密码'),
            ],
            onSaved: (newValue) {
              setState(() {
                _formValue = _formValue.copyWith(password: newValue);
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onLogin?.call(
                  _formValue.username!,
                  _formValue.password!,
                );
              }
            },
            child: const Text('登录'),
          ),
        ],
      ),
    );
  }
}
