import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/app_constants.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/widgets/movable_icon_button.dart';
import 'package:wise_child/features/layout/presentation/widgets/custom_button_navigation_bar.dart';
import '../cubit/layout_cubit.dart';


class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = LayoutCubit.get(context);
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              AppConstants.viewOptions[cubit.index],
              if (cubit.isFloatingButtonVisible) MovableIcon(
                onTap: () {
                  // if (cubit.index == 1) {
                  //   Navigator.pushNamed(context, RoutesManager.chatBotAddChildScreen);
                  //   return;
                  // }
                  Navigator.pushNamed(context, RoutesManager.chatBotAssistantScreen);


                },
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: cubit.index,
            onItemTapped: (index) {
              cubit.changeIndex(index);
            },
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/resources/app_constants.dart';
// import 'package:wise_child/core/resources/routes_manager.dart';
// import 'package:wise_child/core/widgets/movable_icon_button.dart';
// import 'package:wise_child/features/layout/presentation/widgets/custom_button_navigation_bar.dart';
// import '../cubit/layout_cubit.dart';
//
// class LayoutScreen extends StatefulWidget {
//   const LayoutScreen({super.key});
//
//   @override
//   State<LayoutScreen> createState() => _LayoutScreenState();
// }
//
// class _LayoutScreenState extends State<LayoutScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LayoutCubit, LayoutState>(
//       builder: (context, state) {
//         final cubit = LayoutCubit.get(context);
//
//         return Scaffold(
//           backgroundColor: Colors.white,
//           body: Stack(
//             children: [
//               // المحتوى الرئيسي
//               _buildMainContent(cubit),
//
//               // الزر العائم (ChatBot Assistant) - يظهر حسب حالة الـ Cubit
//               if (cubit.isFloatingButtonVisible)
//                 _buildFloatingAssistantButton(context, cubit),
//             ],
//           ),
//           bottomNavigationBar: CustomBottomNavigationBar(
//             currentIndex: cubit.index,
//             onItemTapped: (index) => _onNavigationItemTapped(cubit, index),
//           ),
//         );
//       },
//     );
//   }
//
//   /// بناء المحتوى الرئيسي للصفحة
//   Widget _buildMainContent(LayoutCubit cubit) {
//     return IndexedStack(
//       index: cubit.index,
//       children: AppConstants.viewOptions,
//     );
//   }
//
//
//   /// بناء زر المساعد العائم مع تأثير انيميشن
//   Widget _buildFloatingAssistantButton(BuildContext context, LayoutCubit cubit) {
//     return AnimatedPositioned(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       bottom: cubit.isFloatingButtonVisible ? 100 : -80,
//       right: 16,
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 200),
//         opacity: cubit.isFloatingButtonVisible ? 1.0 : 0.0,
//         child: MovableIcon(
//           onTap: () => _onAssistantButtonPressed(context, cubit),
//         ),
//       ),
//     );
//   }
//
//   /// التعامل مع الضغط على عناصر شريط التنقل
//   void _onNavigationItemTapped(LayoutCubit cubit, int index) {
//     cubit.changeIndex(index);
//
//     // تطبيق قواعد إظهار/إخفاء الزر حسب الصفحة (اختياري)
//     // cubit.applyFloatingButtonRules();
//   }
//
//   /// التعامل مع الضغط على زر المساعد
//   void _onAssistantButtonPressed(BuildContext context, LayoutCubit cubit) {
//     // يمكنك إضافة منطق مختلف حسب الصفحة الحالية
//     switch (cubit.index) {
//       case 1: // صفحة الأطفال
//       // Navigator.pushNamed(context, RoutesManager.chatBotAddChildScreen);
//         Navigator.pushNamed(context, RoutesManager.chatBotAssistantScreen);
//         break;
//       default:
//         Navigator.pushNamed(context, RoutesManager.chatBotAssistantScreen);
//         break;
//     }
//   }
// }