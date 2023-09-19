import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models/models.dart';

class PageBlockConfigForm extends StatefulWidget {
  final PageBlock selectBlock;
  const PageBlockConfigForm({super.key, required this.selectBlock});

  @override
  State<PageBlockConfigForm> createState() => _PageBlockConfigFormState();
}

class _PageBlockConfigFormState extends State<PageBlockConfigForm> {
  final _formKey = GlobalKey<FormState>();
  late PageBlock _formValue;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _formValue = widget.selectBlock;
    });

    final buttonRow = [
      ElevatedButton(
        onPressed: _validateAndSave,
        child: const Text('保存'),
      ),
      const SizedBox(width: 8),
      TextButton(
        onPressed: () {
          _formKey.currentState?.reset();
        },
        child: const Text('清除表单'),
      ),
    ].toRow();

    final List<Widget> formItems = _buildFormItems();
    final formColumn = [
      ...formItems,
      const SizedBox(height: 16),
      buttonRow,
    ].toColumn();
    return Form(
      key: _formKey,
      child: formColumn,
    );
  }

  void _validateAndSave() {
    final form = _formKey.currentState;
    if (form?.validate() ?? false) {
      form?.save();
      debugPrint(_formValue.toString());
    }
  }

  List<Widget> _buildFormItems() {
    final List<Widget> formItems = [];
    formItems.add(
      MyTextFormField(
        initialValue: _formValue.sort.toString(),
        label: '排序',
        hint: '请输入排序',
        validators: [
          Validators.required(label: '排序'),
          Validators.isInteger(label: '排序'),
          Validators.min(label: '排序', min: 0),
          Validators.max(label: '排序', max: 100)
        ],
        onSaved: (value) {
          _formValue = _formValue.copyWith(sort: int.parse(value ?? '0'));
        },
      ),
    );
    formItems.add(
      MyTextFormField(
        initialValue: _formValue.config.horizontalPadding.toString(),
        label: '水平内边距',
        hint: '请输入水平内边距',
        validators: [
          Validators.required(label: '水平内边距'),
          Validators.isDouble(label: '水平内边距'),
          Validators.min(label: '水平内边距', min: 0),
          Validators.max(label: '水平内边距', max: 100)
        ],
        onSaved: (value) {
          _formValue = _formValue.copyWith(
              config: _formValue.config
                  .copyWith(horizontalPadding: double.parse(value ?? '0.0')));
        },
      ),
    );

    formItems.add(
      MyTextFormField(
        initialValue: _formValue.config.verticalPadding.toString(),
        label: '垂直内边距',
        hint: '请输入垂直内边距',
        validators: [
          Validators.required(label: '垂直内边距'),
          Validators.isDouble(label: '垂直内边距'),
          Validators.min(label: '垂直内边距', min: 0),
          Validators.max(label: '垂直内边距', max: 100)
        ],
        onSaved: (value) {
          _formValue = _formValue.copyWith(
              config: _formValue.config
                  .copyWith(verticalPadding: double.parse(value ?? '0.0')));
        },
      ),
    );

    formItems.add(
      MyTextFormField(
        initialValue: _formValue.config.horizontalSpacing.toString(),
        label: '水平间距',
        hint: '请输入水平间距',
        validators: [
          Validators.required(label: '水平间距'),
          Validators.isDouble(label: '水平间距'),
          Validators.min(label: '水平间距', min: 0),
          Validators.max(label: '水平间距', max: 100)
        ],
        onSaved: (value) {
          _formValue = _formValue.copyWith(
              config: _formValue.config
                  .copyWith(horizontalSpacing: double.parse(value ?? '0.0')));
        },
      ),
    );

    formItems.add(
      MyTextFormField(
        initialValue: _formValue.config.verticalSpacing.toString(),
        label: '垂直间距',
        hint: '请输入垂直间距',
        validators: [
          Validators.required(label: '垂直间距'),
          Validators.isDouble(label: '垂直间距'),
          Validators.min(label: '垂直间距', min: 0),
          Validators.max(label: '垂直间距', max: 100)
        ],
        onSaved: (value) {
          _formValue = _formValue.copyWith(
              config: _formValue.config
                  .copyWith(verticalSpacing: double.parse(value ?? '0.0')));
        },
      ),
    );

    formItems.add(
      MyTextFormField(
        initialValue: _formValue.config.blockHeight.toString(),
        label: '区块高度',
        hint: '请输入区块高度',
        validators: [
          Validators.required(label: '区块高度'),
          Validators.isDouble(label: '区块高度'),
          Validators.min(label: '区块高度', min: 0),
          Validators.max(label: '区块高度', max: 100)
        ],
        onSaved: (value) {
          _formValue = _formValue.copyWith(
              config: _formValue.config
                  .copyWith(blockHeight: double.parse(value ?? '0')));
        },
      ),
    );

    formItems.add(
      MyTextFormField(
        initialValue: (_formValue.config.blockWidth ?? '').toString(),
        label: '区块宽度',
        hint: '请输入区块宽度',
        validators: [
          Validators.required(label: '区块宽度'),
          Validators.isDouble(label: '区块宽度'),
          Validators.min(label: '区块宽度', min: 0),
          Validators.max(label: '区块宽度', max: 100)
        ],
        onSaved: (value) {
          _formValue = _formValue.copyWith(
              config: _formValue.config
                  .copyWith(blockWidth: double.parse(value ?? '0')));
        },
      ),
    );

    return formItems;
  }
}
