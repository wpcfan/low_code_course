import 'package:common/common.dart';
import 'package:flutter/material.dart';

class DateInputWidget extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final String labelText;
  final DateTime? initialDate;

  const DateInputWidget({
    Key? key,
    this.onDateSelected,
    this.labelText = '请选择或输入日期',
    this.initialDate,
  }) : super(key: key);

  @override
  State<DateInputWidget> createState() => _DateInputWidgetState();
}

class _DateInputWidgetState extends State<DateInputWidget> {
  final TextEditingController _textController = TextEditingController();
  DateTime? _selectedDate;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _textController.addListener(_validateDate);
  }

  void _validateDate() {
    final input = _textController.text;
    const pattern = r'^\d{4}-\d{2}-\d{2}$';
    final regex = RegExp(pattern);

    setState(() {
      _isValid = regex.hasMatch(input);
      if (_isValid) {
        _selectedDate = DateTime.tryParse(input);
      } else {
        _selectedDate = null;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('zh'),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _textController.text = "${picked.toLocal()}".split(' ')[0];
        _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textController.text.length));
        widget.onDateSelected?.call(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: _selectedDate == null
                ? widget.labelText
                : _selectedDate!.format('yyyy-MM-dd'),
            errorText: _isValid ? null : '日期格式应为yyyy-MM-dd',
            suffixIcon: GestureDetector(
              onTap: () => _selectDate(context),
              child: const Icon(Icons.calendar_today),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
