import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models/models.dart';

class CreateOrUpdatePageLayout extends StatefulWidget {
  final String title;
  final PageLayout? pageLayout;
  final Function(PageLayout)? onCreated;
  final Function(PageLayout)? onUpdated;

  const CreateOrUpdatePageLayout({
    super.key,
    required this.title,
    this.pageLayout,
    this.onCreated,
    this.onUpdated,
  });

  @override
  State<CreateOrUpdatePageLayout> createState() =>
      _CreateOrUpdatePageLayoutState();
}

class _CreateOrUpdatePageLayoutState extends State<CreateOrUpdatePageLayout> {
  final _formKey = GlobalKey<FormState>();
  late PageLayout _formValue;

  @override
  void initState() {
    super.initState();
    _formValue = widget.pageLayout ?? PageLayout.empty();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextFormField(
                initialValue: widget.pageLayout?.title,
                label: '页面标题',
                validators: [
                  Validators.required(label: '页面标题'),
                  Validators.maxLength(label: '页面标题', maxLength: 255),
                ],
                onSaved: (newValue) {
                  setState(() {
                    _formValue = _formValue.copyWith(title: newValue);
                  });
                },
              ),
              DropdownButtonFormField(
                value: widget.pageLayout?.pageType,
                decoration: const InputDecoration(
                  labelText: '页面类型',
                ),
                items: const [
                  DropdownMenuItem(
                    value: PageType.home,
                    child: Text('首页'),
                  ),
                  DropdownMenuItem(
                    value: PageType.category,
                    child: Text('分类页'),
                  ),
                  DropdownMenuItem(
                    value: PageType.about,
                    child: Text('个人中心页'),
                  ),
                ],
                onChanged: (value) => debugPrint('onChanged: $value'),
                onSaved: (newValue) {
                  setState(() {
                    _formValue = _formValue.copyWith(pageType: newValue);
                  });
                },
              ),
              DropdownButtonFormField(
                value: widget.pageLayout?.platform,
                decoration: const InputDecoration(
                  labelText: '页面平台',
                ),
                items: const [
                  DropdownMenuItem(
                    value: Platform.app,
                    child: Text('App'),
                  ),
                  DropdownMenuItem(
                    value: Platform.web,
                    child: Text('Web'),
                  ),
                ],
                onChanged: (value) => debugPrint('onChanged: $value'),
                onSaved: (newValue) {
                  setState(() {
                    _formValue = _formValue.copyWith(platform: newValue);
                  });
                },
              ),
              MyTextFormField(
                initialValue:
                    widget.pageLayout?.config.baselineScreenWidth?.toString(),
                label: '基准屏幕宽度',
                validators: [
                  Validators.required(label: '基准屏幕宽度'),
                  Validators.isDouble(label: '基准屏幕宽度'),
                  Validators.min(label: '基准屏幕宽度', min: 300),
                ],
                onSaved: (newValue) {
                  setState(() {
                    _formValue = _formValue.copyWith(
                      config: _formValue.config.copyWith(
                        baselineScreenWidth: double.parse(newValue!),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              if (widget.pageLayout == null) {
                widget.onCreated?.call(_formValue);
              } else {
                widget.onUpdated?.call(_formValue);
              }
              Navigator.of(context).pop();
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
