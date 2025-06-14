import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';

import '../../data/models/request/add_child_request.dart';
import '../bloc/NewChildren_cubit.dart';
import '../pages/NewChildren_page.dart';

class AddFriendsSheet extends StatefulWidget {
  final String personType;

  const AddFriendsSheet({super.key, required this.personType});

  @override
  _AddFriendsSheetState createState() => _AddFriendsSheetState();
}

class _AddFriendsSheetState extends State<AddFriendsSheet> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 8,
        right: 8,
        top: 16,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إضافة ${widget.personType}',
              style: getSemiBoldStyle(fontSize: 22, color: Colors.black),
            ),
            const SizedBox(height: 24),
            CustomTextForm(controller: _nameController, hintText: 'الاسم'),
            const SizedBox(height: 16),
            CustomTextForm(
              controller: _ageController,
              hintText: 'العمر',
              textInputType: TextInputType.number,
            ),
            SectionHeader(title: 'الجنس'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  activeColor: ColorManager.primaryColor,
                  value: 'male',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v!),
                ),
                 Text('ذكر',style: getBoldStyle(color: Colors.grey,),),
                const SizedBox(width: 12),
                Radio<String>(
                  activeColor: ColorManager.primaryColor,
                  value: 'female',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v!),
                ),
                 Text('أنثى',style: getBoldStyle(color: Colors.grey,),)
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final friends =Friends(
                  name: _nameController.text,
                  age: int.tryParse(_ageController.text) ?? 0,
                  gender: _gender,
                );
                Navigator.pop(context, friends);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,

                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'إضافة',
                style: getMediumStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}