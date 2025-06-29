import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

import '../../features/layout/presentation/cubit/layout_cubit.dart';

class CustomAppBarApp extends StatefulWidget {
  const CustomAppBarApp({
    super.key,
    required this.title,
    required this.subtitle,
    this.backFunction, this.colorContainerStack,
  });

  final String title;
  final String subtitle;
  final void Function()? backFunction;
  final  Color? colorContainerStack;

  @override
  State<CustomAppBarApp> createState() => _CustomAppBarAppState();
}

class _CustomAppBarAppState extends State<CustomAppBarApp>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            bottom: 15,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.primaryColor.withOpacity(0.6),

                ColorManager.primaryColor.withOpacity(0.3),
                ColorManager.primaryColor.withOpacity(0.1),
                // Colors.transparent,      // Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: [
              // زر الرجوع
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: ColorManager.primaryColor,
                  ),
                  onPressed: () {
                    if (widget.backFunction != null) {
                      widget.backFunction!();
                    } else {
                      LayoutCubit.get(context).changeIndex(0);
                    }
                  },
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: FadeTransition(
                  opacity: _fadeController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: getBoldStyle(
                          color: ColorManager.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: getRegularStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              // أيقونة إضافية
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: ColorManager.primaryColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
         Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color:widget.colorContainerStack??Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color:Colors.grey.shade50,
              //     blurRadius: 10,
              //     offset: const Offset(0, 2),
              //   ),
              // ],
            ),
            width: double.infinity,
            height: 10,

          ),
        ),
      ],
    );
  }
}
