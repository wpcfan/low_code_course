import 'package:flutter/material.dart';

import '../validators/validators.dart';

class MyTextFormField extends StatelessWidget {
  final String? initialValue;
  final List<Validator> validators;
  final void Function(String?)? onSaved;
  final String? label;
  final String? hint;
  final Widget? suffix;
  final bool readonly;
  final InputDecoration decoration;
  MyTextFormField({
    super.key,
    this.initialValue,
    this.validators = const [],
    this.onSaved,
    this.label,
    this.hint,
    this.suffix,
    this.readonly = false,
  }) : decoration = InputDecoration(
          labelText: label,
          hintText: hint,
          suffix: suffix,
        );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readonly,
      controller: TextEditingController(text: initialValue),
      decoration: decoration,
      validator: (value) {
        for (final validator in validators) {
          final error = validator(value);
          if (error != null) {
            return error;
          }
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
