// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/core/widgets/custom_text_form.dart';
// import 'package:wise_child/features/EditProfile/presentation/widgets/card_image.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
//
// import '../../../../assets_manager.dart';
// import '../../../../core/di/di.dart';
// import '../bloc/EditProfile_cubit.dart';
//
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//
//   late EditProfileCubit viewModel;
//
//   @override
//   void initState() {
//     viewModel = getIt.get<EditProfileCubit>();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: viewModel,
//       child: Scaffold(
//
//         body:EditProfileBody(),
//       ),
//     );
//   }
// }
//
// class EditProfileBody extends StatefulWidget {
//   const EditProfileBody({super.key});
//
//   @override
//   State<EditProfileBody> createState() => _EditProfileBodyState();
// }
//
// class _EditProfileBodyState extends State<EditProfileBody> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   DateTime? _selectedDate;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorManager.appBackground,
//       body: Center(
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(0.0),
//             child: Stack(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     ChangeUserImage(),
//                     SizedBox(height: 20),
//                     Container(
//                       margin: const EdgeInsets.all(8),
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Column(
//                         children: [
//                           SizedBox(height: 15),
//                           Row(
//                             children: [
//                               SizedBox(height: 15),
//                               Expanded(
//                                 child: CustomTextFormAuth(
//                                   title: AppLocalizations.of(
//                                     context,
//                                   )!.firstName,
//                                   controller:
//                                   _firstNameController,
//                                   hintText:  AppLocalizations.of(
//                                     context,
//                                   )!.firstName,
//                                   validator: (value) {
//                                     if (value == null ||
//                                         value.isEmpty) {
//                                       return AppLocalizations.of(
//                                         context,
//                                       )!.pleaseEnterYourUsername;
//                                     }
//                                     return null;
//                                   },
//                                   textInputType: TextInputType.name,
//                                 ),
//                               )
//                                 ,
//                               SizedBox(width: 16),
//
//                                 Expanded(
//                                 child: CustomTextFormAuth(
//                                   title: AppLocalizations.of(
//                                     context,
//                                   )!.lastName,
//                                   controller:
//                                   _lastNameController,
//                                   hintText: AppLocalizations.of(
//                                     context,
//                                   )!.lastName,
//                                   validator: (value) {
//                                     if (value == null ||
//                                         value.isEmpty) {
//                                       return AppLocalizations.of(
//                                         context,
//                                       )!.pleaseEnterYourUsername;
//                                     }
//                                     return null;
//                                   },
//                                   textInputType: TextInputType.name,
//                                 ),
//                               )
//
//                             ],
//                           ),
//                           CustomTextFormAuth(
//                             title: AppLocalizations.of(context)!.email,
//                             controller: _emailController,
//                             hintText: 'm@example.com',
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return AppLocalizations.of(
//                                   context,
//                                 )!.pleaseEnterYourEmail;
//                               }
//                               if (!value.contains('@')) {
//                                 return AppLocalizations.of(
//                                   context,
//                                 )!.pleaseEnterAValidEmail;
//                               }
//                               return null;
//                             },
//                             textInputType: TextInputType.emailAddress,
//                           ),
//
//                            CustomTextFormAuth(
//                             controller: _dateController,
//                             hintText: '21/10/1999',
//                             title: AppLocalizations.of(
//                               context,
//                             )!.birthday,
//                             suffixIcon: Icon(
//                               Icons.calendar_today,
//                               color: Colors.grey[600],
//                             ),
//                             readOnly: true,
//                             onTap: () {},
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter event Date';
//                               }
//                               return null;
//                             },
//                           ),
//
//                           CustomTextFormAuth(
//                             title: AppLocalizations.of(context)!.password,
//                             controller: _passwordController,
//                             hintText: AppLocalizations.of(
//                               context,
//                             )!.enterYourPassword,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return AppLocalizations.of(
//                                   context,
//                                 )!.pleaseEnterYourPassword;
//                               }
//                               if (value.length < 6) {
//                                 return 'Password must be at least 6 characters';
//                               }
//                               return null;
//                             },
//                             textInputType: TextInputType.visiblePassword,
//                           ),
//
//                               Align(
//                             alignment: Alignment.centerRight,
//                             child: TextButton(
//                               onPressed: () {
//
//                               },
//                               style: TextButton.styleFrom(
//                                 padding: EdgeInsets.zero,
//                               ),
//                               child: Text(
//                                 AppLocalizations.of(
//                                   context,
//                                 )!.forgotPassword,
//                                 style: getSemiBoldStyle(
//                                   color: ColorManager.primaryColor,
//                                 ),
//                               ),
//                             ),
//                           )
//
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 16,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           ElevatedButton(
//                             onPressed:(){},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: ColorManager.primaryColor,
//                               foregroundColor: Colors.white,
//                               padding: EdgeInsets.symmetric(vertical: 8),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               elevation: 3,
//                             ),
//                             child: Text(
//
//                                  AppLocalizations.of(context)!.register,///
//
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//
//
//                           SizedBox(height: 25),
//
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildTabOption(String title, bool isLogin) {
//
//
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//
//           });
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 14),
//           decoration: BoxDecoration(
//             color: ColorManager.primaryColor ,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: true
//                 ? [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: Offset(0, 2),
//               ),
//             ]
//                 : [],
//           ),
//           child: Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontWeight: FontWeight.bold ,
//               color: Colors.white ,
//               fontSize: 15,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/resources/values_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';
import 'package:wise_child/core/widgets/custom_snack_bar.dart';
import 'package:wise_child/features/EditProfile/presentation/widgets/card_image.dart';
import 'package:wise_child/features/EditProfile/presentation/widgets/gender_selector.dart';
import 'package:wise_child/l10n/app_localizations.dart';
import '../../../../core/di/di.dart';
import '../../../../core/utils/cashed_data_shared_preferences.dart';
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
        backgroundColor: ColorManager.appBackground,
        // appBar: _buildAppBar(context),
        body: const EditProfileBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: ColorManager.appBackground,
      title: Text(
        AppLocalizations.of(context)!.editProfile,
        style: getBoldStyle(
          color: ColorManager.darkGrey,
          fontSize: AppSize.s20,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: ColorManager.darkGrey,
          size: AppSize.s24,
        ),
        onPressed: () => Navigator.of(context).pop(),
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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Load existing user data from cache or API
    _firstNameController.text =
        CacheService.getData(key: CacheKeys.userFirstName) ?? '';
    _lastNameController.text =
        CacheService.getData(key: CacheKeys.userLastName) ?? '';
    _emailController.text =
        CacheService.getData(key: CacheKeys.userEmail) ?? '';
    _phoneController.text =
        CacheService.getData(key: CacheKeys.userPhone) ?? '';
    _ageController.text =
        CacheService.getData(key: CacheKeys.userAge)?.toString() ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          CustomSnackBar.showSuccessSnackBar(
            context,
            message:
                state.editProfileEntity.message ??
                AppLocalizations.of(context)!.profileUpdatedSuccessfully,
          );
          Navigator.of(context).pop();
        } else if (state is EditProfileFailure) {
          CustomSnackBar.showErrorSnackBar(
            context,
            message: state.exception.toString(),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Image Section
              CustomAppBarApp(
                title: 'تعديل الملف الشخصي',
                subtitle: 'يمكنك تعديل الملف الشخصي',
                backFunction: () => Navigator.pop(context),
                colorContainerStack: ColorManager.appBackground,
              ),
              const SizedBox(height: AppSize.s20),
              const ChangeUserImage(),
              const SizedBox(height: AppSize.s32),

              // Form Section
              _buildFormCard(),

              const SizedBox(height: AppSize.s24),

              // Save Button
              _buildSaveButton(),

              const SizedBox(height: AppSize.s20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      margin: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.personalInformation,
            style: getBoldStyle(
              color: ColorManager.darkGrey,
              fontSize: AppSize.s18,
            ),
          ),
          const SizedBox(height: AppSize.s20),

          // Name Fields Row
          Row(
            children: [
              Expanded(
                child: CustomTextFormNew(
                  title: AppLocalizations.of(context)!.firstName,
                  controller: _firstNameController,
                  hintText: AppLocalizations.of(context)!.firstName,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(
                        context,
                      )!.pleaseEnterYourFirstName;
                    }
                    if (value.length < 2) {
                      return AppLocalizations.of(
                        context,
                      )!.firstNameMustBeAtLeast2Characters;
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                  prefixIcon: Icons.person_outline,
                ),
              ),
              const SizedBox(width: AppSize.s16),
              Expanded(
                child: CustomTextFormNew(
                  title: AppLocalizations.of(context)!.lastName,
                  controller: _lastNameController,
                  hintText: AppLocalizations.of(context)!.lastName,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(
                        context,
                      )!.pleaseEnterYourLastName;
                    }
                    if (value.length < 2) {
                      return AppLocalizations.of(
                        context,
                      )!.lastNameMustBeAtLeast2Characters;
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                  prefixIcon: Icons.person_outline,
                ),
              ),
            ],
          ),

          // Email Field
          CustomTextFormNew(
            title: AppLocalizations.of(context)!.email,
            controller: _emailController,
            hintText: 'm@example.com',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context)!.pleaseEnterYourEmail;
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return AppLocalizations.of(context)!.pleaseEnterAValidEmail;
              }
              return null;
            },
            textInputType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            readOnly: true, // Usually email shouldn't be editable
          ),

          // Phone Field
          // CustomTextFormNew(
          //   title: AppLocalizations.of(context)!.phoneNumber,
          //   controller: _phoneController,
          //   hintText: '+966XXXXXXXXX',
          //   validator: (value) {
          //     if (value == null || value.trim().isEmpty) {
          //       return AppLocalizations.of(context)!.pleaseEnterYourPhoneNumber;
          //     }
          //     if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
          //       return AppLocalizations.of(context)!.pleaseEnterAValidPhoneNumber;
          //     }
          //     return null;
          //   },
          //   textInputType: TextInputType.phone,
          //   prefixIcon: Icons.phone_outlined,
          // ),

          // Age and Gender Row
          Row(
            children: [
              Expanded(
                child: CustomTextFormNew(
                  title: AppLocalizations.of(context)!.age,
                  controller: _ageController,
                  hintText: '25',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterYourAge;
                    }
                    int? age = int.tryParse(value);
                    if (age == null || age < 1 || age > 120) {
                      return AppLocalizations.of(context)!.pleaseEnterAValidAge;
                    }
                    return null;
                  },
                  textInputType: TextInputType.number,
                  prefixIcon: Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        if (state is EditProfileLoading) {
          return Container(
            height: AppSize.s50,
            margin: const EdgeInsets.all(AppPadding.p16),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor,
              borderRadius: BorderRadius.circular(AppSize.s25),
            ),
            child: const Center(child: CustomLoadingWidget()),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: ElevatedButton(
            onPressed: _handleSaveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s25),
              ),
              elevation: 3,
              shadowColor: ColorManager.primaryColor.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_outlined, size: AppSize.s20),
                const SizedBox(width: AppSize.s8),
                Text(
                  AppLocalizations.of(context)!.saveChanges,
                  style: getBoldStyle(
                    color: Colors.white,
                    fontSize: AppSize.s16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSaveProfile() {
    if (_formKey.currentState!.validate()) {
      // int? age = int.tryParse(_ageController.text);
      // if (age == null) {
      //   CustomSnackBar.showErrorSnackBar(
      //     context,
      //     message: AppLocalizations.of(context)!.pleaseEnterAValidAge,
      //   );
      //   return;
      // }

      // Call the cubit method
      context.read<EditProfileCubit>().editProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        age: 39,
      );
    }
  }
}
