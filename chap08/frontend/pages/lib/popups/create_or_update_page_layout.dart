import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CreateOrUpdatePageLayout extends StatefulWidget {
  const CreateOrUpdatePageLayout({super.key});

  @override
  State<CreateOrUpdatePageLayout> createState() =>
      _CreateOrUpdatePageLayoutState();
}

class _CreateOrUpdatePageLayoutState extends State<CreateOrUpdatePageLayout> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('创建页面布局'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '页面标题',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return '页面标题不能为空';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
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
              ),
              DropdownButtonFormField(
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
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '基准屏幕宽度',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return '基准屏幕宽度不能为空';
                  }
                  if (double.tryParse(value!) == null ||
                      double.parse(value) < 300) {
                    return '基准屏幕宽度必须是大于 300 的数字';
                  }
                  return null;
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
          onPressed: () => {
            if (_formKey.currentState!.validate())
              {
                Navigator.of(context).pop(),
              }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
