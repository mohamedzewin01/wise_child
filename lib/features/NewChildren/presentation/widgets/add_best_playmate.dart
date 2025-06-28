import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/utils/custom_validator.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
import '../../../../l10n/app_localizations.dart';

class AddBestPlaymate extends StatefulWidget {
  const AddBestPlaymate({super.key, required this.personType});

  final String personType;

  @override
  State<AddBestPlaymate> createState() => _AddBestPlaymateState();
}

class _AddBestPlaymateState extends State<AddBestPlaymate> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF6B73FF)],
                //   stops: [0.0, 0.5, 1.0],
                // ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.add} ${widget.personType}',
                      style: getSemiBoldStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
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
                      validator: (value) => CustomValidator.validateAge(
                        value,
                        emptyMessage: AppLocalizations.of(context)!.enterAge,
                        invalidMessage: AppLocalizations.of(
                          context,
                        )!.invalidAge,
                      ),
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
                          activeColor: ColorManager.primaryColor,
                          value: 'male',
                          groupValue: _gender,
                          onChanged: (v) => setState(() => _gender = v!),
                        ),
                        Text(
                          AppLocalizations.of(context)!.genderBoy,
                          style: getSemiBoldStyle(
                            color: _gender == 'male'
                                ? ColorManager.primaryColor
                                : Colors.black45,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(unselectedWidgetColor: Colors.grey),
                          child: Radio<String>(
                            activeColor: ColorManager.primaryColor,
                            value: 'female',
                            groupValue: _gender,
                            onChanged: (v) => setState(() => _gender = v!),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.genderGirl,
                          style: getSemiBoldStyle(
                            color: _gender == 'female'
                                ? ColorManager.primaryColor
                                : Colors.black45,
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
                                  color: Colors.black45,
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
                                  ColorManager.primaryColor,
                                  ColorManager.primaryColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorManager.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;

                                final bestPlaymate = BestPlaymate(
                                  name: _nameController.text,
                                  age: int.tryParse(_ageController.text) ?? 0,
                                  gender: _gender,
                                );
                                Navigator.pop(context, bestPlaymate);
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)?.add ?? 'إضافة',
                                style: getSemiBoldStyle(
                                  color: ColorManager.white,
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
        ),
      ),
    );
  }
}
