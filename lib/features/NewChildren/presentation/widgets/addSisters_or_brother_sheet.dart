// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/core/utils/custom_validator.dart';
// import 'package:wise_child/core/widgets/custom_text_form.dart';
// import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
// import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
//
// import '../../../../l10n/app_localizations.dart';
// import '../pages/NewChildren_page.dart';
//
// class AddSistersOrBrotherSheet extends StatefulWidget {
//   final String personType;
//
//   const AddSistersOrBrotherSheet({super.key, required this.personType});
//
//   @override
//   _AddSistersOrBrotherSheetState createState() =>
//       _AddSistersOrBrotherSheetState();
// }
//
// class _AddSistersOrBrotherSheetState extends State<AddSistersOrBrotherSheet> {
//   final _nameController = TextEditingController();
//   final _ageController = TextEditingController();
//   String _gender = 'male';
//
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       insetPadding: const EdgeInsets.all(16),
//       child: SingleChildScrollView(
//         child: Card(
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           color: Colors.white,
//           child: Container(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//               left: 24,
//               right: 24,
//               top: 24,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20.0),
//               color: Colors.white,
//               // gradient: LinearGradient(
//               //   begin: Alignment.topLeft,
//               //   end: Alignment.bottomRight,
//               //   colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF6B73FF)],
//               //   stops: [0.0, 0.5, 1.0],
//               // ),
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${AppLocalizations.of(context)!.add} ${widget.personType}',
//                     style: getSemiBoldStyle(fontSize: 22, color: Colors.black),
//                   ),
//                   const SizedBox(height: 24),
//                   CustomTextForm(
//                     controller: _nameController,
//                     hintText: AppLocalizations.of(context)!.name,
//                     textInputType: TextInputType.name,
//                     validator:  (value) {
//                       if (value == null || value.isEmpty) {
//                         return AppLocalizations.of(context)!.enterName;
//
//                       }
//
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextForm(
//                     controller: _ageController,
//                     hintText: AppLocalizations.of(context)!.age,
//                     textInputType: TextInputType.number,
//                     validator: (value) => CustomValidator.validateAge(
//                       value,
//                       emptyMessage: AppLocalizations.of(context)!.enterAge,
//                       invalidMessage: AppLocalizations.of(
//                         context,
//                       )!.invalidAge,
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//                   SectionHeader(
//                     title: AppLocalizations.of(context)!.gender,
//                     vertical: 0,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Radio<String>(
//                         activeColor: ColorManager.primaryColor,
//                         value: 'male',
//                         groupValue: _gender,
//                         onChanged: (v) => setState(() => _gender = v!),
//                       ),
//                       Text(
//                         AppLocalizations.of(context)!.genderBoy,
//                         style: getSemiBoldStyle(
//                           color: _gender == 'male' ? ColorManager.primaryColor : Colors.black45,
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Theme(
//                         data: Theme.of(context).copyWith(
//                           unselectedWidgetColor:
//                               Colors.grey,
//                         ),
//                         child: Radio<String>(
//                           activeColor: ColorManager.primaryColor,
//
//                           value: 'female',
//                           groupValue: _gender,
//                           onChanged: (v) => setState(() => _gender = v!),
//                         ),
//                       ),
//
//                       Text(
//                         AppLocalizations.of(context)!.genderGirl,
//                         style: getSemiBoldStyle(
//                           color: _gender == 'female'
//                               ? ColorManager.primaryColor
//                               : Colors.black45,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.grey.withOpacity(0.3),
//                               width: 1.5,
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             style: TextButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: Text(
//                               AppLocalizations.of(context)?.cancel ?? 'إلغاء',
//                               style: getSemiBoldStyle(
//                                 color: Colors.black45,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 ColorManager.primaryColor,
//                                 ColorManager.primaryColor.withOpacity(0.8),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: ColorManager.primaryColor.withOpacity(0.3),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: TextButton(
//                             onPressed: () {
//                               if (!_formKey.currentState!.validate()) {
//                                 return;
//                               }
//                               final siblings = Siblings(
//                                 name: _nameController.text,
//                                 age: int.tryParse(_ageController.text) ?? 0,
//                                 gender: _gender,
//                               );
//                               Navigator.pop(context, siblings);
//                             },
//                             style: TextButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: Text(
//                               AppLocalizations.of(context)?.add ?? 'اضافة',
//                               style: getSemiBoldStyle(
//                                 color: ColorManager.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Padding(
//   //     padding: EdgeInsets.only(
//   //       bottom: MediaQuery.of(context).viewInsets.bottom,
//   //       left: 8,
//   //       right: 8,
//   //       top: 16,
//   //     ),
//   //     child: Container(
//   //       padding: const EdgeInsets.all(24),
//   //       decoration: const BoxDecoration(
//   //         color: Colors.white,
//   //         borderRadius: BorderRadius.only(
//   //           topLeft: Radius.circular(20),
//   //           topRight: Radius.circular(20),
//   //         ),
//   //       ),
//   //       child: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           Text(
//   //             'إضافة ${widget.personType}',
//   //             style: getSemiBoldStyle(fontSize: 22, color: Colors.black),
//   //           ),
//   //           const SizedBox(height: 24),
//   //           CustomTextForm(controller: _nameController, hintText: 'الاسم'),
//   //           const SizedBox(height: 16),
//   //           CustomTextForm(
//   //             controller: _ageController,
//   //             hintText: 'العمر',
//   //             textInputType: TextInputType.number,
//   //           ),
//   //           SectionHeader(title: 'الجنس'),
//   //           Row(
//   //             mainAxisAlignment: MainAxisAlignment.center,
//   //             children: [
//   //               Radio<String>(
//   //                 activeColor: ColorManager.primaryColor,
//   //                 value: 'male',
//   //                 groupValue: _gender,
//   //                 onChanged: (v) => setState(() => _gender = v!),
//   //               ),
//   //               const Text('ذكر'),
//   //               const SizedBox(width: 20),
//   //               Radio<String>(
//   //                 activeColor: ColorManager.primaryColor,
//   //                 value: 'female',
//   //                 groupValue: _gender,
//   //                 onChanged: (v) => setState(() => _gender = v!),
//   //               ),
//   //               const Text('أنثى'),
//   //             ],
//   //           ),
//   //           const SizedBox(height: 24),
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               final siblings = Siblings(
//   //                 name: _nameController.text,
//   //                 age: int.tryParse(_ageController.text) ?? 0,
//   //                 gender: _gender,
//   //               );
//   //               Navigator.pop(context, siblings);
//   //             },
//   //             style: ElevatedButton.styleFrom(
//   //               backgroundColor: ColorManager.primaryColor,
//   //
//   //               minimumSize: const Size(double.infinity, 50),
//   //             ),
//   //             child: Text(
//   //               'إضافة',
//   //               style: getMediumStyle(color: Colors.white, fontSize: 16),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }
///
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';

class AddSistersOrBrotherSheet extends StatefulWidget {
  final String personType;

  const AddSistersOrBrotherSheet({super.key, required this.personType});

  @override
  _AddSistersOrBrotherSheetState createState() =>
      _AddSistersOrBrotherSheetState();
}

class _AddSistersOrBrotherSheetState extends State<AddSistersOrBrotherSheet>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Transform.scale(
            scale: _slideAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 10),
                      blurRadius: 30,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      left: 24,
                      right: 24,
                      top: 24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          _buildHeader(),

                          const SizedBox(height: 24),

                          // Name Field
                          _buildNameField(),

                          const SizedBox(height: 16),

                          // Age Field
                          _buildAgeField(),

                          const SizedBox(height: 20),

                          // Gender Selection
                          _buildGenderSelection(),

                          const SizedBox(height: 32),

                          // Action Buttons
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.primaryColor.withOpacity(0.8),
                ColorManager.primaryColor,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_add_outlined,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'إضافة ${widget.personType}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'أدخل المعلومات الأساسية',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الاسم',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextForm(
          controller: _nameController,
          hintText: 'أدخل الاسم',
          textInputType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال الاسم';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAgeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'العمر',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextForm(
          controller: _ageController,
          hintText: 'أدخل العمر',
          textInputType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال العمر';
            }
            final age = int.tryParse(value);
            if (age == null || age < 1 || age > 99) {
              return 'الرجاء إدخال عمر صحيح (1-99)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الجنس',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  value: 'male',
                  label: 'ذكر',
                  icon: Icons.male,
                  color: Colors.blue,
                  isSelected: _gender == 'male',
                ),
              ),
              Expanded(
                child: _buildGenderOption(
                  value: 'female',
                  label: 'أنثى',
                  icon: Icons.female,
                  color: Colors.pink,
                  isSelected: _gender == 'female',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade500,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey.shade600,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).pop(),
                child: Center(
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primaryColor.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (!_formKey.currentState!.validate()) return;

                  final siblings = Siblings(
                    name: _nameController.text.trim(),
                    age: int.tryParse(_ageController.text) ?? 0,
                    gender: _gender,
                  );
                  Navigator.pop(context, siblings);
                },
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'إضافة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// نفس التصميم للأصدقاء
class AddFriendsSheet extends StatefulWidget {
  final String personType;

  const AddFriendsSheet({super.key, required this.personType});

  @override
  _AddFriendsSheetState createState() => _AddFriendsSheetState();
}

class _AddFriendsSheetState extends State<AddFriendsSheet>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Transform.scale(
            scale: _slideAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 10),
                      blurRadius: 30,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      left: 24,
                      right: 24,
                      top: 24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildNameField(),
                          const SizedBox(height: 16),
                          _buildAgeField(),
                          const SizedBox(height: 20),
                          _buildGenderSelection(),
                          const SizedBox(height: 32),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber.shade400,
                Colors.amber.shade600,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.emoji_people_outlined,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'إضافة ${widget.personType}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'أدخل معلومات الصديق',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الاسم',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextForm(
          controller: _nameController,
          hintText: 'أدخل اسم الصديق',
          textInputType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال الاسم';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAgeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'العمر',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextForm(
          controller: _ageController,
          hintText: 'أدخل عمر الصديق',
          textInputType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال العمر';
            }
            final age = int.tryParse(value);
            if (age == null || age < 1 || age > 99) {
              return 'الرجاء إدخال عمر صحيح (1-99)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الجنس',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  value: 'male',
                  label: 'ذكر',
                  icon: Icons.male,
                  color: Colors.blue,
                  isSelected: _gender == 'male',
                ),
              ),
              Expanded(
                child: _buildGenderOption(
                  value: 'female',
                  label: 'أنثى',
                  icon: Icons.female,
                  color: Colors.pink,
                  isSelected: _gender == 'female',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade500,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey.shade600,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).pop(),
                child: Center(
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade500,
                  Colors.amber.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (!_formKey.currentState!.validate()) return;

                  final friends = Friends(
                    name: _nameController.text.trim(),
                    age: int.tryParse(_ageController.text) ?? 0,
                    gender: _gender,
                  );
                  Navigator.pop(context, friends);
                },
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'إضافة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}