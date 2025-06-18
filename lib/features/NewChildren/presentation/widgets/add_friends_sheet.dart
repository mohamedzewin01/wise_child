// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/core/widgets/custom_text_form.dart';
// import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
//
// import '../../data/models/request/add_child_request.dart';
// import '../bloc/NewChildren_cubit.dart';
// import '../pages/NewChildren_page.dart';
//
// class AddFriendsSheet extends StatefulWidget {
//   final String personType;
//
//   const AddFriendsSheet({super.key, required this.personType});
//
//   @override
//   _AddFriendsSheetState createState() => _AddFriendsSheetState();
// }
//
// class _AddFriendsSheetState extends State<AddFriendsSheet> {
//   final _nameController = TextEditingController();
//   final _ageController = TextEditingController();
//   String _gender = 'male';
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 8,
//         right: 8,
//         top: 16,
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'إضافة ${widget.personType}',
//               style: getSemiBoldStyle(fontSize: 22, color: Colors.black),
//             ),
//             const SizedBox(height: 24),
//             CustomTextForm(controller: _nameController, hintText: 'الاسم'),
//             const SizedBox(height: 16),
//             CustomTextForm(
//               controller: _ageController,
//               hintText: 'العمر',
//               textInputType: TextInputType.number,
//             ),
//             SectionHeader(title: 'الجنس'),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Radio<String>(
//                   activeColor: ColorManager.primaryColor,
//                   value: 'male',
//                   groupValue: _gender,
//                   onChanged: (v) => setState(() => _gender = v!),
//                 ),
//                  Text('ذكر',style: getBoldStyle(color: Colors.grey,),),
//                 const SizedBox(width: 12),
//                 Radio<String>(
//                   activeColor: ColorManager.primaryColor,
//                   value: 'female',
//                   groupValue: _gender,
//                   onChanged: (v) => setState(() => _gender = v!),
//                 ),
//                  Text('أنثى',style: getBoldStyle(color: Colors.grey,),)
//               ],
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 final friends =Friends(
//                   name: _nameController.text,
//                   age: int.tryParse(_ageController.text) ?? 0,
//                   gender: _gender,
//                 );
//                 Navigator.pop(context, friends);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorManager.primaryColor,
//
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: Text(
//                 'إضافة',
//                 style: getMediumStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
import '../../../../l10n/app_localizations.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF6B73FF)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.add} ${widget.personType}',
                  style: getSemiBoldStyle(fontSize: 22, color: Colors.black),
                ),
                const SizedBox(height: 24),
                CustomTextForm(
                  controller: _nameController,
                  hintText: AppLocalizations.of(context)!.name,
                  textInputType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enterName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextForm(
                  controller: _ageController,
                  hintText: AppLocalizations.of(context)!.age,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enterAge;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  title: AppLocalizations.of(context)!.gender,
                  vertical: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      activeColor: ColorManager.white,
                      value: 'male',
                      groupValue: _gender,
                      onChanged: (v) => setState(() => _gender = v!),
                    ),
                    Text(
                      AppLocalizations.of(context)!.genderBoy,
                      style: getSemiBoldStyle(
                        color: _gender == 'male' ? Colors.white : Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.grey,
                      ),
                      child: Radio<String>(
                        activeColor: ColorManager.white,
                        value: 'female',
                        groupValue: _gender,
                        onChanged: (v) => setState(() => _gender = v!),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.genderGirl,
                      style: getSemiBoldStyle(
                        color: _gender == 'female' ? Colors.white : Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.cancel ?? 'إلغاء',
                            style: getSemiBoldStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white70,
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;

                            final friends = Friends(
                              name: _nameController.text,
                              age: int.tryParse(_ageController.text) ?? 0,
                              gender: _gender,
                            );
                            Navigator.pop(context, friends);
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.add ?? 'إضافة',
                            style: getSemiBoldStyle(
                              color: ColorManager.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
