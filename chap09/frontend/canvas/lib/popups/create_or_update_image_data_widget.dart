import 'package:common/common.dart';
import 'package:files/files.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models/models.dart';

class CreateOrUpdateImageDataWidget extends StatefulWidget {
  final String? title;
  final ImageData? imageData;
  const CreateOrUpdateImageDataWidget({
    super.key,
    this.imageData,
    this.title = '编辑图片数据',
  });

  @override
  State<CreateOrUpdateImageDataWidget> createState() =>
      _CreateOrUpdateImageDataWidgetState();
}

class _CreateOrUpdateImageDataWidgetState
    extends State<CreateOrUpdateImageDataWidget> {
  final _formKey = GlobalKey<FormState>();
  late ImageData _formValue;

  @override
  void initState() {
    super.initState();
    _formValue = widget.imageData ??
        const ImageData(
          image: '',
          link: MyLink(
            type: LinkType.url,
            value: '',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? ''),
      content: _buildFormItems(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(_formValue);
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }

  Widget _buildFormItems() {
    final List<Widget> formItems = [];
    formItems.add(
      MyTextFormField(
        initialValue: _formValue.image,
        label: '图片地址',
        hint: '请输入图片地址',
        suffix: const Icon(
          Icons.image,
          color: Colors.grey,
        ).inkWell(onTap: () async {
          final String? image = await showDialog(
            context: context,
            builder: (context) => const ImageExplorerDialog(),
          );
          if (image != null) {
            setState(() {
              _formValue = _formValue.copyWith(image: image);
            });
          }
        }),
        validators: [
          Validators.required(label: '图片地址'),
        ],
        onSaved: (value) {
          _formValue = _formValue.copyWith(image: value);
        },
      ),
    );

    formItems.add(
      MyTextFormField(
        initialValue: _formValue.link.value,
        label: '链接地址',
        hint: '请输入链接地址',
        validators: [
          Validators.required(label: '链接地址'),
        ],
        onSaved: (value) {
          _formValue = _formValue.copyWith(
            link: _formValue.link.copyWith(value: value),
          );
        },
      ),
    );

    formItems.add(DropdownButtonFormField(
      value: _formValue.link.type,
      items: LinkType.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.value),
            ),
          )
          .toList(),
      onChanged: (value) {
        _formValue = _formValue.copyWith(
          link: _formValue.link.copyWith(type: value as LinkType),
        );
      },
    ));

    return Form(
      key: _formKey,
      child: formItems.toColumn(mainAxisSize: MainAxisSize.min),
    );
  }
}
