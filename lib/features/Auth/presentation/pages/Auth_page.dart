import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/functions/auth_function.dart';
import 'package:wise_child/core/functions/custom_dailog.dart';
import 'package:wise_child/core/resources/color_manager.dart';

import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/Privacy_Policy.dart';
import 'package:wise_child/core/widgets/change_language.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';

import 'package:wise_child/l10n/app_localizations.dart';

import '../../../../core/di/di.dart';
import '../bloc/Auth_cubit.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late AuthCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<AuthCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(body: LoginPage(viewModel: viewModel)),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.viewModel});

  final AuthCubit viewModel;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoginTabSelected = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2010),
      firstDate: DateTime(1950),
      lastDate: DateTime(2010),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          Navigator.pushReplacementNamed(
            context,
            RoutesManager.layoutScreen,
          );
        }
        if (state is AuthLoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.exception.toString())));
        }
        if (state is AuthLoginLoading) {
          CustomDialog.showLoadingDialog(context);
        }
        if (state is AuthSingUpSuccess) {
          Navigator.pushReplacementNamed(
            context,
            RoutesManager.layoutScreen,
          );
        }
        if (state is AuthSingUpFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.exception.toString())));
        }
        if (state is AuthSingUpLoading) {
          CustomDialog.showLoadingDialog(context);
        }
      },
      child: Scaffold(
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
                        Text(
                          AppLocalizations.of(context)!.appName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: ColorManager.cardBackground,
                          child: const Text(
                            "🧸",
                            style: TextStyle(fontSize: 48),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.loginToContinue,
                          textAlign: TextAlign.center,
                          style: getSemiBoldStyle(
                            fontSize: 16,
                            color: Colors.grey[700]!,
                          ),
                        ),
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
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200]?.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    _buildTabOption(
                                      AppLocalizations.of(context)!.login,
                                      true,
                                    ),
                                    _buildTabOption(
                                      AppLocalizations.of(context)!.register,
                                      false,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  SizedBox(height: 15),
                                  _isLoginTabSelected == false
                                      ? Expanded(
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
                                      : SizedBox(height: 16),
                                  SizedBox(width: 16),
                                  _isLoginTabSelected == false
                                      ? Expanded(
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
                                      : SizedBox(height: 16),
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
                              _isLoginTabSelected == false
                                  ? CustomTextFormAuth(
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
                                      onTap: () => _selectDate(context),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter event Date';
                                        }
                                        return null;
                                      },
                                    )
                                  : SizedBox(),
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
                              _isLoginTabSelected == true
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          AuthFunctions.resetPassword(
                                            context,
                                            'mohammedzewin01@gmai.com',

                                            /// TODO: Replace with the user's email
                                          );
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
                                  : SizedBox(),
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
                                onPressed: _singUp,
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
                                  _isLoginTabSelected == false
                                      ? AppLocalizations.of(context)!.register
                                      : AppLocalizations.of(context)!.login,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Divider(color: Colors.grey[350]),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.orContinueWith,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.grey[350]),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),

                              // Social Login Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: SvgPicture.asset(
                                        Assets.googleSvg,
                                        height: 20,
                                      ),

                                      label: Text(
                                        AppLocalizations.of(context)!.google,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onPressed: () {
                                        widget.viewModel.signInWithGoogle();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                        elevation: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              PrivacyPolicy(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(top: 0, right: 0, child: ChangeLanguage()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _singUp() {
    if (_formKey.currentState!.validate()) {
      _isLoginTabSelected == true
          ? widget.viewModel.signIn(
              email: _emailController.text,
              password: _passwordController.text,
            )
          : widget.viewModel.signUp(
              password: _passwordController.text.trim(),
              email: _emailController.text.trim(),
              firstName: _firstNameController.text.trim(),
              lastName: _firstNameController.text.trim(),

              ///TODO: Replace with the user's first name
            );
    }
  }

  Widget _buildTabOption(String title, bool isLogin) {
    bool isSelected =
        (_isLoginTabSelected && isLogin) || (!_isLoginTabSelected && !isLogin);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isLoginTabSelected = isLogin;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
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
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey[700],
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
