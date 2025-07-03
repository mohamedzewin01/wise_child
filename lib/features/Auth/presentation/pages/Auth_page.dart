// // import 'package:flutter/gestures.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:intl/intl.dart';
// // import 'package:wise_child/assets_manager.dart';
// // import 'package:wise_child/core/functions/auth_function.dart';
// // import 'package:wise_child/core/functions/custom_dailog.dart';
// // import 'package:wise_child/core/resources/color_manager.dart';
// //
// // import 'package:wise_child/core/resources/routes_manager.dart';
// // import 'package:wise_child/core/resources/style_manager.dart';
// // import 'package:wise_child/core/widgets/Privacy_Policy.dart';
// // import 'package:wise_child/core/widgets/change_language.dart';
// // import 'package:wise_child/core/widgets/custom_text_form.dart';
// //
// // import 'package:wise_child/l10n/app_localizations.dart';
// //
// // import '../../../../core/di/di.dart';
// // import '../bloc/Auth_cubit.dart';
// //
// // class AuthPage extends StatefulWidget {
// //   const AuthPage({super.key});
// //
// //   @override
// //   State<AuthPage> createState() => _AuthPageState();
// // }
// //
// // class _AuthPageState extends State<AuthPage> {
// //   late AuthCubit viewModel;
// //
// //   @override
// //   void initState() {
// //     viewModel = getIt.get<AuthCubit>();
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider.value(
// //       value: viewModel,
// //       child: Scaffold(body: LoginPage(viewModel: viewModel)),
// //     );
// //   }
// // }
// //
// // class LoginPage extends StatefulWidget {
// //   const LoginPage({super.key, required this.viewModel});
// //
// //   final AuthCubit viewModel;
// //
// //   @override
// //   _LoginPageState createState() => _LoginPageState();
// // }
// //
// // class _LoginPageState extends State<LoginPage> {
// //   bool _isLoginTabSelected = true;
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _firstNameController = TextEditingController();
// //   final TextEditingController _lastNameController = TextEditingController();
// //   final TextEditingController _dateController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   DateTime? _selectedDate;
// //
// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate ?? DateTime(2010),
// //       firstDate: DateTime(1950),
// //       lastDate: DateTime(2010),
// //     );
// //     if (picked != null && picked != _selectedDate) {
// //       setState(() {
// //         _selectedDate = picked;
// //         _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocListener<AuthCubit, AuthState>(
// //       listener: (context, state) {
// //         if (state is AuthLoginSuccess) {
// //           Navigator.pushReplacementNamed(
// //             context,
// //             RoutesManager.layoutScreen,
// //           );
// //         }
// //         if (state is AuthLoginFailure) {
// //           ScaffoldMessenger.of(
// //             context,
// //           ).showSnackBar(SnackBar(content: Text(state.exception.toString())));
// //         }
// //         if (state is AuthLoginLoading) {
// //           CustomDialog.showLoadingDialog(context);
// //         }
// //         if (state is AuthSingUpSuccess) {
// //           Navigator.pushReplacementNamed(
// //             context,
// //             RoutesManager.layoutScreen,
// //           );
// //         }
// //         if (state is AuthSingUpFailure) {
// //           ScaffoldMessenger.of(
// //             context,
// //           ).showSnackBar(SnackBar(content: Text(state.exception.toString())));
// //         }
// //         if (state is AuthSingUpLoading) {
// //           CustomDialog.showLoadingDialog(context);
// //         }
// //       },
// //       child: Scaffold(
// //         backgroundColor: ColorManager.appBackground,
// //         body: Center(
// //           child: SingleChildScrollView(
// //             padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 40.0),
// //             child: Form(
// //               key: _formKey,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(0.0),
// //                 child: Stack(
// //                   children: [
// //                     Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       crossAxisAlignment: CrossAxisAlignment.stretch,
// //                       children: [
// //                         Text(
// //                           AppLocalizations.of(context)!.appName,
// //                           textAlign: TextAlign.center,
// //                           style: TextStyle(
// //                             fontSize: 36,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.black87,
// //                           ),
// //                         ),
// //                         SizedBox(height: 8),
// //                         CircleAvatar(
// //                           radius: 50,
// //                           backgroundColor: ColorManager.cardBackground,
// //                           backgroundImage:  AssetImage(Assets.logoPng),
// //                           // child: const Text(
// //                           //   "🧸",
// //                           //   style: TextStyle(fontSize: 48),
// //                           // ),
// //                         ),
// //                         Text(
// //                           AppLocalizations.of(context)!.loginToContinue,
// //                           textAlign: TextAlign.center,
// //                           style: getSemiBoldStyle(
// //                             fontSize: 16,
// //                             color: Colors.grey[700]!,
// //                           ),
// //                         ),
// //                         SizedBox(height: 20),
// //                         Container(
// //                           margin: const EdgeInsets.all(8),
// //                           padding: const EdgeInsets.all(16),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             border: Border.all(color: Colors.grey[300]!),
// //                             borderRadius: BorderRadius.circular(16),
// //                           ),
// //                           child: Column(
// //                             children: [
// //                               Container(
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.grey[200]?.withOpacity(0.7),
// //                                   borderRadius: BorderRadius.circular(16),
// //                                 ),
// //                                 child: Row(
// //                                   children: [
// //                                     _buildTabOption(
// //                                       AppLocalizations.of(context)!.login,
// //                                       true,
// //                                     ),
// //                                     _buildTabOption(
// //                                       AppLocalizations.of(context)!.register,
// //                                       false,
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                               SizedBox(height: 15),
// //                               Row(
// //                                 children: [
// //                                   SizedBox(height: 15),
// //                                   _isLoginTabSelected == false
// //                                       ? Expanded(
// //                                           child: CustomTextFormAuth(
// //                                             title: AppLocalizations.of(
// //                                               context,
// //                                             )!.firstName,
// //                                             controller:
// //                                                 _firstNameController,
// //                                             hintText:  AppLocalizations.of(
// //                                               context,
// //                                             )!.firstName,
// //                                             validator: (value) {
// //                                               if (value == null ||
// //                                                   value.isEmpty) {
// //                                                 return AppLocalizations.of(
// //                                                   context,
// //                                                 )!.pleaseEnterYourUsername;
// //                                               }
// //                                               return null;
// //                                             },
// //                                             textInputType: TextInputType.name,
// //                                           ),
// //                                         )
// //                                       : SizedBox(height: 16),
// //                                   SizedBox(width: 16),
// //                                   _isLoginTabSelected == false
// //                                       ? Expanded(
// //                                           child: CustomTextFormAuth(
// //                                             title: AppLocalizations.of(
// //                                               context,
// //                                             )!.lastName,
// //                                             controller:
// //                                                 _lastNameController,
// //                                             hintText: AppLocalizations.of(
// //                                               context,
// //                                             )!.lastName,
// //                                             validator: (value) {
// //                                               if (value == null ||
// //                                                   value.isEmpty) {
// //                                                 return AppLocalizations.of(
// //                                                   context,
// //                                                 )!.pleaseEnterYourUsername;
// //                                               }
// //                                               return null;
// //                                             },
// //                                             textInputType: TextInputType.name,
// //                                           ),
// //                                         )
// //                                       : SizedBox(height: 16),
// //                                 ],
// //                               ),
// //                               CustomTextFormAuth(
// //                                 title: AppLocalizations.of(context)!.email,
// //                                 controller: _emailController,
// //                                 hintText: 'm@example.com',
// //                                 validator: (value) {
// //                                   if (value == null || value.isEmpty) {
// //                                     return AppLocalizations.of(
// //                                       context,
// //                                     )!.pleaseEnterYourEmail;
// //                                   }
// //                                   if (!value.contains('@')) {
// //                                     return AppLocalizations.of(
// //                                       context,
// //                                     )!.pleaseEnterAValidEmail;
// //                                   }
// //                                   return null;
// //                                 },
// //                                 textInputType: TextInputType.emailAddress,
// //                               ),
// //                               _isLoginTabSelected == false
// //                                   ? CustomTextFormAuth(
// //                                       controller: _dateController,
// //                                       hintText: '21/10/1999',
// //                                       title: AppLocalizations.of(
// //                                         context,
// //                                       )!.birthday,
// //                                       suffixIcon: Icon(
// //                                         Icons.calendar_today,
// //                                         color: Colors.grey[600],
// //                                       ),
// //                                       readOnly: true,
// //                                       onTap: () => _selectDate(context),
// //                                       validator: (value) {
// //                                         if (value == null || value.isEmpty) {
// //                                           return 'Please enter event Date';
// //                                         }
// //                                         return null;
// //                                       },
// //                                     )
// //                                   : SizedBox(),
// //                               CustomTextFormAuth(
// //                                 title: AppLocalizations.of(context)!.password,
// //                                 controller: _passwordController,
// //                                 hintText: AppLocalizations.of(
// //                                   context,
// //                                 )!.enterYourPassword,
// //                                 validator: (value) {
// //                                   if (value == null || value.isEmpty) {
// //                                     return AppLocalizations.of(
// //                                       context,
// //                                     )!.pleaseEnterYourPassword;
// //                                   }
// //                                   if (value.length < 6) {
// //                                     return 'Password must be at least 6 characters';
// //                                   }
// //                                   return null;
// //                                 },
// //                                 textInputType: TextInputType.visiblePassword,
// //                               ),
// //                               _isLoginTabSelected == true
// //                                   ? Align(
// //                                       alignment: Alignment.centerRight,
// //                                       child: TextButton(
// //                                         onPressed: () {
// //                                           AuthFunctions.resetPassword(
// //                                             context,
// //                                             'mohammedzewin01@gmai.com',
// //
// //                                             /// TODO: Replace with the user's email
// //                                           );
// //                                         },
// //                                         style: TextButton.styleFrom(
// //                                           padding: EdgeInsets.zero,
// //                                         ),
// //                                         child: Text(
// //                                           AppLocalizations.of(
// //                                             context,
// //                                           )!.forgotPassword,
// //                                           style: getSemiBoldStyle(
// //                                             color: ColorManager.primaryColor,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     )
// //                                   : SizedBox(),
// //                             ],
// //                           ),
// //                         ),
// //
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 30,
// //                             vertical: 16,
// //                           ),
// //                           child: Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             crossAxisAlignment: CrossAxisAlignment.stretch,
// //                             children: [
// //                               ElevatedButton(
// //                                 onPressed: _singUp,
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: ColorManager.primaryColor,
// //                                   foregroundColor: Colors.white,
// //                                   padding: EdgeInsets.symmetric(vertical: 8),
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(25),
// //                                   ),
// //                                   elevation: 3,
// //                                 ),
// //                                 child: Text(
// //                                   _isLoginTabSelected == false
// //                                       ? AppLocalizations.of(context)!.register
// //                                       : AppLocalizations.of(context)!.login,
// //                                   style: TextStyle(
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 6),
// //                               Row(
// //                                 children: <Widget>[
// //                                   Expanded(
// //                                     child: Divider(color: Colors.grey[350]),
// //                                   ),
// //                                   Padding(
// //                                     padding: EdgeInsets.symmetric(
// //                                       horizontal: 10.0,
// //                                     ),
// //                                     child: Text(
// //                                       AppLocalizations.of(
// //                                         context,
// //                                       )!.orContinueWith,
// //                                       style: TextStyle(
// //                                         color: Colors.grey[600],
// //                                         fontSize: 11,
// //                                         fontWeight: FontWeight.w500,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   Expanded(
// //                                     child: Divider(color: Colors.grey[350]),
// //                                   ),
// //                                 ],
// //                               ),
// //                               SizedBox(height: 16),
// //
// //                               // Social Login Buttons
// //                               Row(
// //                                 children: [
// //                                   Expanded(
// //                                     child: OutlinedButton.icon(
// //                                       icon: SvgPicture.asset(
// //                                         Assets.googleSvg,
// //                                         height: 20,
// //                                       ),
// //
// //                                       label: Text(
// //                                         AppLocalizations.of(context)!.google,
// //                                         style: TextStyle(
// //                                           color: Colors.black87,
// //                                           fontWeight: FontWeight.w500,
// //                                         ),
// //                                       ),
// //                                       onPressed: () {
// //                                         widget.viewModel.signInWithGoogle();
// //                                       },
// //                                       style: OutlinedButton.styleFrom(
// //                                         backgroundColor: Colors.white,
// //                                         padding: EdgeInsets.symmetric(
// //                                           vertical: 12,
// //                                         ),
// //                                         shape: RoundedRectangleBorder(
// //                                           borderRadius: BorderRadius.circular(
// //                                             8,
// //                                           ),
// //                                         ),
// //                                         side: BorderSide(
// //                                           color: Colors.grey[300]!,
// //                                         ),
// //                                         elevation: 1,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                               SizedBox(height: 25),
// //                               PrivacyPolicy(),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     Positioned(top: 0, right: 0, child: ChangeLanguage()),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _singUp() {
// //     if (_formKey.currentState!.validate()) {
// //       _isLoginTabSelected == true
// //           ? widget.viewModel.signIn(
// //               email: _emailController.text,
// //               password: _passwordController.text,
// //             )
// //           : widget.viewModel.signUp(
// //               password: _passwordController.text.trim(),
// //               email: _emailController.text.trim(),
// //               firstName: _firstNameController.text.trim(),
// //               lastName: _firstNameController.text.trim(),
// //
// //               ///TODO: Replace with the user's first name
// //             );
// //     }
// //   }
// //
// //   Widget _buildTabOption(String title, bool isLogin) {
// //     bool isSelected =
// //         (_isLoginTabSelected && isLogin) || (!_isLoginTabSelected && !isLogin);
// //     return Expanded(
// //       child: GestureDetector(
// //         onTap: () {
// //           setState(() {
// //             _isLoginTabSelected = isLogin;
// //           });
// //         },
// //         child: Container(
// //           padding: EdgeInsets.symmetric(vertical: 14),
// //           decoration: BoxDecoration(
// //             color: isSelected ? ColorManager.primaryColor : Colors.transparent,
// //             borderRadius: BorderRadius.circular(16),
// //             boxShadow: isSelected
// //                 ? [
// //                     BoxShadow(
// //                       color: Colors.grey.withOpacity(0.3),
// //                       spreadRadius: 1,
// //                       blurRadius: 5,
// //                       offset: Offset(0, 2),
// //                     ),
// //                   ]
// //                 : [],
// //           ),
// //           child: Text(
// //             title,
// //             textAlign: TextAlign.center,
// //             style: TextStyle(
// //               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// //               color: isSelected ? Colors.white : Colors.grey[700],
// //               fontSize: 15,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// // lib/features/Auth/presentation/pages/auth_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:intl/intl.dart';
// import 'package:wise_child/assets_manager.dart';
// import 'package:wise_child/core/functions/auth_function.dart';
// import 'package:wise_child/core/functions/custom_dailog.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/routes_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/core/widgets/Privacy_Policy.dart';
// import 'package:wise_child/core/widgets/change_language.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
// import '../../../../core/di/di.dart';
// import '../bloc/Auth_cubit.dart';
// import '../widgets/auth_animated_background.dart';
// import '../widgets/glassmorphism_container.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/animated_switch_tabs.dart';
// import '../widgets/gradient_button.dart';
// import '../widgets/social_auth_buttons.dart';
// import '../widgets/floating_elements.dart';
//
// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});
//
//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }
//
// class _AuthPageState extends State<AuthPage>
//     with TickerProviderStateMixin {
//   late AuthCubit viewModel;
//   late AnimationController _mainController;
//   late AnimationController _formController;
//   late AnimationController _pulseController;
//
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _formSlideAnimation;
//   late Animation<double> _pulseAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     viewModel = getIt.get<AuthCubit>();
//
//     _initAnimations();
//     _startAnimations();
//   }
//
//   void _initAnimations() {
//     _mainController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     _formController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _mainController,
//       curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//     ));
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _mainController,
//       curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
//     ));
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _mainController,
//       curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
//     ));
//
//     _formSlideAnimation = Tween<double>(
//       begin: 50.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _formController,
//       curve: Curves.easeOutBack,
//     ));
//
//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.1,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   void _startAnimations() {
//     _mainController.forward();
//     _formController.forward();
//     _pulseController.repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _mainController.dispose();
//     _formController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: viewModel,
//       child: GestureDetector(
//         onTap: () =>  FocusScope.of(context).unfocus(),
//         child: Scaffold(
//           extendBodyBehindAppBar: true,
//           body: Stack(
//             children: [
//               // Animated Background
//               const AuthAnimatedBackground(),
//
//               // Floating Elements
//               const FloatingElements(),
//
//               // Main Content
//               SafeArea(
//                 child: BlocListener<AuthCubit, AuthState>(
//                   listener: _handleAuthState,
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//
//
//                         _buildLanguageToggle(),
//
//                         _buildHeader(),
//
//                         const SizedBox(height: 20),
//
//
//                         _buildAuthForm(),
//
//                         const SizedBox(height: 10),
//
//                         _buildPrivacyPolicy(),
//
//                         const SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLanguageToggle() {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Align(
//           alignment: Alignment.topRight,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.3),
//                 width: 1,
//               ),
//             ),
//             child: const ChangeLanguage(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Column(
//           children: [
//             // Animated Logo
//             ScaleTransition(
//               scale: _scaleAnimation,
//               child: AnimatedBuilder(
//                 animation: _pulseAnimation,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: _pulseAnimation.value,
//                     child: Container(
//                       width: 120,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.white.withOpacity(0.3),
//                             Colors.white.withOpacity(0.1),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.white.withOpacity(0.4),
//                             blurRadius: 30,
//                             spreadRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: Center(
//                         child: Container(
//                           width: 80,
//                           height: 80,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(40),
//                             child: Image.asset(
//                               Assets.logoPng,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return const Icon(
//                                   Icons.child_care,
//                                   size: 40,
//                                   color: Color(0xFF667eea),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Title
//             Text(
//               AppLocalizations.of(context)!.appName,
//               style: getBoldStyle(
//                 color: Colors.white,
//                 fontSize: 32,
//               ).copyWith(
//                 shadows: [
//                   Shadow(
//                     offset: const Offset(0, 3),
//                     blurRadius: 15,
//                     color: Colors.black.withOpacity(0.3),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // Subtitle
//             Text(
//               AppLocalizations.of(context)!.loginToContinue,
//               textAlign: TextAlign.center,
//               style: getRegularStyle(
//                 color: Colors.white.withOpacity(0.9),
//                 fontSize: 16,
//               ).copyWith(
//                 shadows: [
//                   Shadow(
//                     offset: const Offset(0, 1),
//                     blurRadius: 5,
//                     color: Colors.black.withOpacity(0.2),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAuthForm() {
//     return AnimatedBuilder(
//       animation: _formController,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, _formSlideAnimation.value),
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: GlassmorphismContainer(
//               child: AuthFormContent(
//                 viewModel: viewModel,
//                 formController: _formController,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPrivacyPolicy() {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: Colors.white.withOpacity(0.2),
//             width: 1,
//           ),
//         ),
//         child: const PrivacyPolicy(),
//       ),
//     );
//   }
//
//   void _handleAuthState(BuildContext context, AuthState state) {
//     if (state is AuthLoginSuccess || state is AuthSingUpSuccess) {
//       Navigator.pushReplacementNamed(context, RoutesManager.layoutScreen);
//     } else if (state is AuthLoginFailure || state is AuthSingUpFailure) {
//       _showErrorSnackBar(context, state);
//     } else if (state is AuthLoginLoading || state is AuthSingUpLoading) {
//       CustomDialog.showLoadingDialog(context);
//     }
//   }
//
//   void _showErrorSnackBar(BuildContext context, AuthState state) {
//     String message = '';
//     if (state is AuthLoginFailure) {
//       message = state.exception.toString();
//     } else if (state is AuthSingUpFailure) {
//       message = state.exception.toString();
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.red.shade400,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }
// }
//
//
// class AuthFormContent extends StatefulWidget {
//   final AuthCubit viewModel;
//   final AnimationController formController;
//
//   const AuthFormContent({
//     super.key,
//     required this.viewModel,
//     required this.formController,
//   });
//
//   @override
//   State<AuthFormContent> createState() => _AuthFormContentState();
// }
//
// class _AuthFormContentState extends State<AuthFormContent>
//     with TickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _dateController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   bool _isLoginMode = true;
//   DateTime? _selectedDate;
//
//   late AnimationController _switchController;
//   late Animation<double> _switchAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _switchController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//
//     _switchAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _switchController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _dateController.dispose();
//     _passwordController.dispose();
//     _switchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//
//           AnimatedSwitchTabs(
//             isLoginSelected: _isLoginMode,
//             onTabChanged: (isLogin) {
//               setState(() {
//                 _isLoginMode = isLogin;
//               });
//               if (isLogin) {
//                 _switchController.reverse();
//               } else {
//                 _switchController.forward();
//               }
//             },
//           ),
//
//           const SizedBox(height: 20),
//
//           // Form Fields with Animation
//           AnimatedBuilder(
//             animation: _switchAnimation,
//             builder: (context, child) {
//               return Column(
//                 children: [
//                   // Name fields for signup
//                   if (!_isLoginMode) ...[
//                     _buildNameFields(),
//                     const SizedBox(height: 16),
//                   ],
//
//                   // Email field
//                   CustomTextField(
//                     controller: _emailController,
//                     label: AppLocalizations.of(context)!.email,
//                     icon: Icons.email_outlined,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: _validateEmail,
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Birthday field for signup
//                   if (!_isLoginMode) ...[
//                     CustomTextField(
//                       controller: _dateController,
//                       label: AppLocalizations.of(context)!.birthday,
//                       icon: Icons.calendar_today_outlined,
//                       readOnly: true,
//                       onTap: () => _selectDate(context),
//                       validator: _validateBirthday,
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//
//                   // Password field
//                   CustomTextField(
//                     controller: _passwordController,
//                     label: AppLocalizations.of(context)!.password,
//                     icon: Icons.lock_outline,
//                     isPassword: true,
//                     validator: _validatePassword,
//                   ),
//                 ],
//               );
//             },
//           ),
//
//           // Forgot Password for Login
//           if (_isLoginMode) ...[
//             const SizedBox(height: 16),
//             _buildForgotPassword(),
//           ],
//
//           const SizedBox(height: 30),
//
//           // Auth Button
//           GradientButton(
//             text: _isLoginMode
//                 ? AppLocalizations.of(context)!.login
//                 : AppLocalizations.of(context)!.register,
//             onPressed: _handleSubmit,
//             icon: Icons.arrow_forward_ios,
//           ),
//
//           const SizedBox(height: 24),
//
//           // Divider
//           _buildDivider(),
//
//           const SizedBox(height: 24),
//
//           // Social Login
//           SocialAuthButtons(
//             onGooglePressed: () => widget.viewModel.signInWithGoogle(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNameFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: CustomTextField(
//             controller: _firstNameController,
//             label: AppLocalizations.of(context)!.firstName,
//             icon: Icons.person_outline,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return AppLocalizations.of(context)!.pleaseEnterYourUsername;
//               }
//               return null;
//             },
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: CustomTextField(
//             controller: _lastNameController,
//             label: AppLocalizations.of(context)!.lastName,
//             icon: Icons.person_outline,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return AppLocalizations.of(context)!.pleaseEnterYourUsername;
//               }
//               return null;
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildForgotPassword() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: TextButton(
//         onPressed: () {
//           AuthFunctions.resetPassword(
//             context,
//             _emailController.text.isEmpty
//                 ? 'user@example.com'
//                 : _emailController.text,
//           );
//         },
//         style: TextButton.styleFrom(
//           padding: EdgeInsets.zero,
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         ),
//         child: Text(
//           AppLocalizations.of(context)!.forgotPassword,
//           style: getRegularStyle(
//             color: Colors.white.withOpacity(0.9),
//             fontSize: 14,
//           ).copyWith(
//             decoration: TextDecoration.underline,
//             decorationColor: Colors.white.withOpacity(0.9),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDivider() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: 1,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   Colors.white.withOpacity(0.3),
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             AppLocalizations.of(context)!.orContinueWith,
//             style: getRegularStyle(
//               color: Colors.white.withOpacity(0.7),
//               fontSize: 14,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Container(
//             height: 1,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   Colors.white.withOpacity(0.3),
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime(2010),
//       firstDate: DateTime(1950),
//       lastDate: DateTime(2010),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: ColorManager.primaryColor,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
//       });
//     }
//   }
//
//   void _handleSubmit() {
//     if (_formKey.currentState!.validate()) {
//       if (_isLoginMode) {
//         widget.viewModel.signIn(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//       } else {
//         widget.viewModel.signUp(
//           firstName: _firstNameController.text.trim(),
//           lastName: _lastNameController.text.trim(),
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//       }
//     }
//   }
//
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return AppLocalizations.of(context)!.pleaseEnterYourEmail;
//     }
//     if (!value.contains('@')) {
//       return AppLocalizations.of(context)!.pleaseEnterAValidEmail;
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return AppLocalizations.of(context)!.pleaseEnterYourPassword;
//     }
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }
//
//   String? _validateBirthday(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your birthday';
//     }
//     return null;
//   }
// }