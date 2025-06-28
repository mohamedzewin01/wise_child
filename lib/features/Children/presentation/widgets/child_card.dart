// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/functions/calculate_age.dart';
// import 'package:wise_child/core/functions/gender_to_text.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/core/resources/values_manager.dart';
// import 'package:wise_child/core/widgets/delete_confirmation_dialog.dart';
// import 'package:wise_child/features/ChildDetailsPage/presentation/pages/ChildDetailsPage_page.dart';
// import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
// import 'package:wise_child/features/Children/presentation/bloc/Children_cubit.dart';
// import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
// import 'package:wise_child/l10n/app_localizations.dart';
//
// import '../../../../core/di/di.dart';
// import '../../../../localization/locale_cubit.dart';
//
// class ChildCard extends StatelessWidget {
//   const ChildCard({super.key, required this.children});
//
//   final Children children;
//
//   @override
//   Widget build(BuildContext context) {
//     final languageCode = LocaleCubit.get(context).state.languageCode;
//
//     final ageString = calculateAgeInYearsAndMonths(
//       children.dateOfBirth ?? '',
//       languageCode,
//     );
//     return  InkWell(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(
//           builder: (context) {
//             return BlocProvider.value(
//               value: getIt.get<ChildrenCubit>(),
//               child: ChildDetailsPage(child:children),
//             );
//           },
//         ));
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.0),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.white,
//               offset: Offset(-2, -2),
//               blurRadius: 4,
//               spreadRadius: 1,
//             ),
//             BoxShadow(
//               color: Colors.black12,
//               offset: Offset(2, 2),
//               blurRadius: 4,
//               spreadRadius: 1,
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               AvatarWidget(
//                 firstName: children.firstName ?? '',
//                 lastName: children.lastName ?? '',
//                 backgroundColor: Colors.purple.shade300,
//                 textColor: Colors.white,
//                 imageUrl: children.imageUrl,
//                 radius: 30.0,
//               ),
//               const SizedBox(width: 16.0),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${children.firstName} ${children.lastName}',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: getBoldStyle(
//                       color: ColorManager.primaryColor,
//                       fontSize: 16,
//                     ),
//                   ),
//                   Text(
//                     ageString,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: getSemiBoldStyle(
//                       color: ColorManager.textSecondary.withOpacity(0.7),
//                       fontSize: 14,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Icon(
//                         children.gender?.toLowerCase() == 'male'
//                             ? Icons.male
//                             : Icons.female,
//                         size: 16,
//                         color: children.gender?.toLowerCase() == 'male'
//                             ? Colors.blue.shade400
//                             : Colors.pink.shade400,
//                       ),
//                       const SizedBox(width: 4.0),
//                       Text(
//                         genderToText(children.gender ?? '', languageCode),
//                         style: getSemiBoldStyle(
//                           color: ColorManager.textSecondary.withOpacity(0.8),
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                 ],
//               ),
//               const Spacer(),
//               Row(
//                 children: [
//                   _buildActionButton(
//                     icon: Icons.edit_rounded,
//                     color: ColorManager.primaryColor,
//                     onTap: () {
//                       // context.read<ChildrenCubit>().editChild(widget.children);
//                     },
//                     tooltip: 'تعديل',
//                   ),
//
//                   const SizedBox(width: 8.0),
//
//                   _buildActionButton(
//                     icon: Icons.delete_rounded,
//                     color: ColorManager.red,
//                     onTap: () {
//                       _showDeleteConfirmation(context);
//                     },
//                     tooltip: 'حذف',
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//     required String tooltip,
//   }) {
//     return Tooltip(
//       message: tooltip,
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: onTap,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12.0),
//               border: Border.all(
//                 color: color.withOpacity(0.2),
//                 width: 1,
//               ),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 20,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteConfirmation(BuildContext context) {
//     DeleteConfirmationDialog.show(
//       context,
//       childName: '${children.firstName} ${children.lastName}',
//       onConfirm: () async {
//         await context.read<ChildrenCubit>().deleteChild(
//           children.idChildren!,
//         );
//       },
//       onCancel: () {},
//     );
//   }
// }
//
///
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/functions/calculate_age.dart';
import 'package:wise_child/core/functions/gender_to_text.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/resources/values_manager.dart';
import 'package:wise_child/core/widgets/delete_confirmation_dialog.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/pages/ChildDetailsPage_page.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/bloc/Children_cubit.dart';
import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
import 'package:wise_child/l10n/app_localizations.dart';

import '../../../../core/di/di.dart';
import '../../../../localization/locale_cubit.dart';

class ChildCard extends StatefulWidget {
  const ChildCard({super.key, required this.children});

  final Children children;

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final ageString = calculateAgeInYearsAndMonths(
      widget.children.dateOfBirth ?? '',
      languageCode,
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return BlocProvider.value(
                    value: getIt.get<ChildrenCubit>(),
                    child: ChildDetailsPage(child: widget.children),
                  );
                },
              ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Avatar with status indicator
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.2),
                                    offset: const Offset(0, 4),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: AvatarWidget(
                                firstName: widget.children.firstName ?? '',
                                lastName: widget.children.lastName ?? '',
                                backgroundColor: Colors.purple.shade300,
                                textColor: Colors.white,
                                imageUrl: widget.children.imageUrl,
                                radius: 32.0,
                              ),
                            ),
                            // Online status indicator
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 20.0),

                        // Child information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                '${widget.children.firstName} ${widget.children.lastName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getBoldStyle(
                                  color: ColorManager.primaryColor,
                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Age
                              Text(
                                ageString,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getSemiBoldStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Gender and stats row
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  // Gender chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.children.gender?.toLowerCase() == 'male'
                                          ? Colors.blue.shade50
                                          : Colors.pink.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: widget.children.gender?.toLowerCase() == 'male'
                                            ? Colors.blue.shade200
                                            : Colors.pink.shade200,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          widget.children.gender?.toLowerCase() == 'male'
                                              ? Icons.male
                                              : Icons.female,
                                          size: 14,
                                          color: widget.children.gender?.toLowerCase() == 'male'
                                              ? Colors.blue.shade600
                                              : Colors.pink.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          genderToText(widget.children.gender ?? '', languageCode),
                                          style: getSemiBoldStyle(
                                            color: widget.children.gender?.toLowerCase() == 'male'
                                                ? Colors.blue.shade700
                                                : Colors.pink.shade700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Stats
                                  if (widget.children.friendsCount != null)
                                    _buildStatChip(
                                      icon: Icons.people_outline,
                                      count: widget.children.friendsCount!,
                                      color: Colors.orange.shade700,
                                    ),

                                  if (widget.children.siblingsCount != null)
                                    _buildStatChip(
                                      icon: Icons.family_restroom,
                                      count: widget.children.siblingsCount!,
                                      color: Colors.teal.shade700,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Action buttons
                        SizedBox(
                          width: 50,
                          child: Column(
                            children: [
                              _buildActionButton(
                                icon: Icons.edit_rounded,
                                color: ColorManager.primaryColor,
                                onTap: () {
                                  // Handle edit action
                                },
                                tooltip: 'تعديل',
                              ),

                              const SizedBox(height: 8),

                              _buildActionButton(
                                icon: Icons.delete_rounded,
                                color: ColorManager.red,
                                onTap: () {
                                  _showDeleteConfirmation(context);
                                },
                                tooltip: 'حذف',
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildStatChip({
    required IconData icon,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    DeleteConfirmationDialog.show(
      context,
      childName: '${widget.children.firstName} ${widget.children.lastName}',
      onConfirm: () async {
        await context.read<ChildrenCubit>().deleteChild(
          widget.children.idChildren!,
        );
      },
      onCancel: () {},
    );
  }
}