

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/features/NewChildren/presentation/bloc/NewChildren_cubit.dart';
// import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
//
// class GenderToggle extends StatefulWidget {
//   const GenderToggle({super.key});
//
//   @override
//   State<GenderToggle> createState() => _GenderToggleState();
// }
//
// class _GenderToggleState extends State<GenderToggle> {
//   bool isMaleSelected = true; // الافتراضي: ذكر
//
//   @override
//   Widget build(BuildContext context) {
//     final isRtl = Directionality.of(context) == TextDirection.rtl;
//
//     return Center(
//       child: Column(
//         children: [
//           SectionHeader(
//             title: AppLocalizations.of(context)!.gender,
//           ),
//           Container(
//             height: 50,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: ColorManager.primaryColor.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Stack(
//               children: [
//                 // ✅ الخلفية المتحركة تحت الزر المحدد
//                 AnimatedAlign(
//                   duration: const Duration(milliseconds: 200),
//                   alignment: isMaleSelected
//                       ? AlignmentDirectional.centerStart
//                       : AlignmentDirectional.centerEnd,
//                   child: Container(
//                     height: 40,
//                     width: MediaQuery.of(context).size.width / 2 - 32,
//                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(30),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 4,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // ✅ زرّا الاختيار
//                 Row(
//                   children: [
//                     // ذكر
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             context.read<NewChildrenCubit>().gender = 'Male';
//                             isMaleSelected = true;
//                           });
//                         },
//                         child: Center(
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.male,
//                                 size: 20,
//                                 color: isMaleSelected
//                                     ? Colors.blueAccent
//                                     : Colors.grey,
//                               ),
//                               const SizedBox(width: 6),
//                               Text(
//                                 AppLocalizations.of(context)!.genderBoy,
//                                 style: getBoldStyle(
//                                   color: isMaleSelected
//                                       ? Colors.blueAccent
//                                       : Colors.grey,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     // أنثى
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             context.read<NewChildrenCubit>().gender = 'Female';
//                             isMaleSelected = false;
//                           });
//                         },
//                         child: Center(
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.female,
//                                 size: 20,
//                                 color: !isMaleSelected
//                                     ? Colors.pinkAccent
//                                     : Colors.grey,
//                               ),
//                               const SizedBox(width: 6),
//                               Text(
//                                 AppLocalizations.of(context)!.genderGirl,
//                                 style: getBoldStyle(
//                                   color: !isMaleSelected
//                                       ? Colors.pinkAccent
//                                       : Colors.grey,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/NewChildren/presentation/bloc/NewChildren_cubit.dart';

class GenderToggle extends StatefulWidget {
  const GenderToggle({super.key});

  @override
  State<GenderToggle> createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle>
    with SingleTickerProviderStateMixin {
  bool isMaleSelected = true;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _maleColorAnimation;
  late Animation<Color?> _femaleColorAnimation;

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
      curve: Curves.easeInOut,
    ));

    _maleColorAnimation = ColorTween(
      begin: Colors.blue.shade600,
      end: Colors.grey.shade400,
    ).animate(_animationController);

    _femaleColorAnimation = ColorTween(
      begin: Colors.grey.shade400,
      end: Colors.pink.shade600,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectGender(bool male) {
    if (male != isMaleSelected) {
      setState(() {
        isMaleSelected = male;
        context.read<NewChildrenCubit>().gender = male ? 'Male' : 'Female';
      });

      if (male) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Animated background slider
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                left: _slideAnimation.value * (MediaQuery.of(context).size.width - 80) / 2,
                top: 4,
                bottom: 4,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 80) / 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Gender options
          Row(
            children: [
              // Male option
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectGender(true),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isMaleSelected
                                      ? Colors.blue.shade50
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.male,
                                  size: 20,
                                  color: _maleColorAnimation.value,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  color: _maleColorAnimation.value,
                                  fontSize: 14,
                                  fontWeight: isMaleSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                                child: const Text('ذكر'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Female option
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectGender(false),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: !isMaleSelected
                                      ? Colors.pink.shade50
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.female,
                                  size: 20,
                                  color: _femaleColorAnimation.value,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  color: _femaleColorAnimation.value,
                                  fontSize: 14,
                                  fontWeight: !isMaleSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                                child: const Text('أنثى'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}