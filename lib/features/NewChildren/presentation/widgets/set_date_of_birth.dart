import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';
import 'package:wise_child/features/NewChildren/presentation/bloc/NewChildren_cubit.dart';

class SetDateOfBirth extends StatefulWidget {
  const SetDateOfBirth({super.key});

  @override
  State<SetDateOfBirth> createState() => _SetDateOfBirthState();
}

class _SetDateOfBirthState extends State<SetDateOfBirth> {
  DateTime? _dateOfBirth = DateTime(2000, 01, 01);
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatDate(_dateOfBirth));
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextForm(
      readOnly: true,
      onTap: () async {
        final now = DateTime.now();
        final maxDate = now;
        final minDate = DateTime(now.year - 15, now.month, now.day);

        DateTime validInitialDate = _dateOfBirth ?? maxDate;
        if (validInitialDate.isBefore(minDate)) {
          validInitialDate = minDate;
        } else if (validInitialDate.isAfter(maxDate)) {
          validInitialDate = maxDate;
        }

        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: validInitialDate,
          firstDate: minDate,
          lastDate: maxDate,
        );

        if (picked != null && picked != _dateOfBirth) {
          setState(() {
            _dateOfBirth = picked;
            _controller.text = _formatDate(picked);
            context.read<NewChildrenCubit>().updateBirthDate(_controller.text);
          });
        }
      },
      suffixIcon: Icon(Icons.calendar_today, color: Colors.black45),
      controller: _controller,
      hintText: 'تاريخ الميلاد',
    );
  }
}
