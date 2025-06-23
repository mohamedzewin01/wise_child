import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';
import 'package:wise_child/features/EditProfile/presentation/widgets/card_image.dart';
import 'package:wise_child/l10n/app_localizations.dart';

import '../../../../assets_manager.dart';
import '../../../../core/di/di.dart';
import '../bloc/EditProfile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  late EditProfileCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<EditProfileCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(

        body:EditProfileBody(),
      ),
    );
  }
}

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({super.key});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.appBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ChangeUserImage(),
                      SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [


                            SizedBox(height: 15),
                            Row(
                              children: [
                                SizedBox(height: 15),
                                Expanded(
                                  child: CustomTextFormAuth(
                                    title: AppLocalizations.of(
                                      context,
                                    )!.firstName,
                                    controller:
                                    _firstNameController,
                                    hintText:  AppLocalizations.of(
                                      context,
                                    )!.firstName,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        return AppLocalizations.of(
                                          context,
                                        )!.pleaseEnterYourUsername;
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.name,
                                  ),
                                )
                                  ,
                                SizedBox(width: 16),

                                  Expanded(
                                  child: CustomTextFormAuth(
                                    title: AppLocalizations.of(
                                      context,
                                    )!.lastName,
                                    controller:
                                    _lastNameController,
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.lastName,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        return AppLocalizations.of(
                                          context,
                                        )!.pleaseEnterYourUsername;
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.name,
                                  ),
                                )

                              ],
                            ),
                            CustomTextFormAuth(
                              title: AppLocalizations.of(context)!.email,
                              controller: _emailController,
                              hintText: 'm@example.com',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.pleaseEnterYourEmail;
                                }
                                if (!value.contains('@')) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.pleaseEnterAValidEmail;
                                }
                                return null;
                              },
                              textInputType: TextInputType.emailAddress,
                            ),

                             CustomTextFormAuth(
                              controller: _dateController,
                              hintText: '21/10/1999',
                              title: AppLocalizations.of(
                                context,
                              )!.birthday,
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.grey[600],
                              ),
                              readOnly: true,
                              onTap: () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter event Date';
                                }
                                return null;
                              },
                            ),

                            CustomTextFormAuth(
                              title: AppLocalizations.of(context)!.password,
                              controller: _passwordController,
                              hintText: AppLocalizations.of(
                                context,
                              )!.enterYourPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.pleaseEnterYourPassword;
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              textInputType: TextInputType.visiblePassword,
                            ),

                                Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {

                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.forgotPassword,
                                  style: getSemiBoldStyle(
                                    color: ColorManager.primaryColor,
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed:(){},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 3,
                              ),
                              child: Text(

                                   AppLocalizations.of(context)!.register,///

                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),


                            SizedBox(height: 25),

                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTabOption(String title, bool isLogin) {


    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {

          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: ColorManager.primaryColor ,
            borderRadius: BorderRadius.circular(16),
            boxShadow: true
                ? [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold ,
              color: Colors.white ,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
