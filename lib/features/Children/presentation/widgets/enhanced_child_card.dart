// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wise_child/core/functions/calculate_age.dart';
// import 'package:wise_child/core/functions/gender_to_text.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/core/widgets/delete_confirmation_dialog.dart';
// import 'package:wise_child/features/ChildDetailsPage/presentation/pages/ChildDetailsPage_page.dart';
// import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
// import 'package:wise_child/features/Children/presentation/bloc/Children_cubit.dart';
// import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
// import '../../../../core/di/di.dart';
// import '../../../../localization/locale_cubit.dart';
//
// class EnhancedChildCard extends StatefulWidget {
//   final Children children;
//   final int index;
//
//   const EnhancedChildCard({
//     super.key,
//     required this.children,
//     required this.index,
//   });
//
//   @override
//   State<EnhancedChildCard> createState() => _EnhancedChildCardState();
// }
//
// class _EnhancedChildCardState extends State<EnhancedChildCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _elevationAnimation;
//   bool _isPressed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.95,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _elevationAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.5,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _onTapDown() {
//     setState(() => _isPressed = true);
//     _animationController.forward();
//     HapticFeedback.lightImpact();
//   }
//
//   void _onTapUp() {
//     setState(() => _isPressed = false);
//     _animationController.reverse();
//   }
//
//   void _onTapCancel() {
//     setState(() => _isPressed = false);
//     _animationController.reverse();
//   }
//
//   void _navigateToDetails() {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             BlocProvider.value(
//               value: getIt.get<ChildrenCubit>(),
//               child: ChildDetailsPage(child: widget.children),
//             ),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(1.0, 0.0),
//               end: Offset.zero,
//             ).animate(CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeInOutCubic,
//             )),
//             child: FadeTransition(
//               opacity: animation,
//               child: child,
//             ),
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 400),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final languageCode = LocaleCubit.get(context).state.languageCode;
//     final ageString = calculateAgeInYearsAndMonths(
//       widget.children.dateOfBirth ?? '',
//       languageCode,
//     );
//
//     final gradientColors = _getGradientColors();
//
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: GestureDetector(
//             onTapDown: (_) => _onTapDown(),
//             onTapUp: (_) => _onTapUp(),
//             onTapCancel: _onTapCancel,
//             onTap: _navigateToDetails,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08 * _elevationAnimation.value),
//                     blurRadius: 20 * _elevationAnimation.value,
//                     offset: Offset(0, 8 * _elevationAnimation.value),
//                     spreadRadius: 2 * _elevationAnimation.value,
//                   ),
//                   BoxShadow(
//                     color: gradientColors[0].withOpacity(0.2 * _elevationAnimation.value),
//                     blurRadius: 15 * _elevationAnimation.value,
//                     offset: Offset(0, 4 * _elevationAnimation.value),
//                     spreadRadius: 1 * _elevationAnimation.value,
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(24),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Colors.white,
//                         gradientColors[0].withOpacity(0.02),
//                         Colors.white,
//                       ],
//                       stops: const [0.0, 0.5, 1.0],
//                     ),
//                     border: Border.all(
//                       color: gradientColors[0].withOpacity(0.1),
//                       width: 1,
//                     ),
//                   ),
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//
//                       _buildBackgroundPattern(),
//                       Positioned(
//                           top: -25,
//                           left: -25,
//
//
//                           child: _buildAvatarSection(gradientColors)),
//                       // Main Content
//                       Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Row(
//                           children: [
//                             // Avatar Section
//
//
//                             const SizedBox(width: 20),
//
//                             // Content Section
//                             Expanded(
//                               child: _buildContentSection(
//                                 ageString,
//                                 languageCode,
//                                 gradientColors,
//                               ),
//                             ),
//
//                             // Actions Section
//                             _buildActionsSection(gradientColors),
//                           ],
//                         ),
//                       ),
//
//                       // Top Badge
//                       _buildTopBadge(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildBackgroundPattern() {
//     return Positioned.fill(
//       child: CustomPaint(
//         painter: PatternPainter(
//           color: _getGradientColors()[0].withOpacity(0.03),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAvatarSection(List<Color> gradientColors) {
//     return Hero(
//       tag: 'child_avatar_${widget.children.idChildren}',
//       child: Stack(
//         children: [
//           // Glow Effect
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: RadialGradient(
//                 colors: [
//                   gradientColors[0].withOpacity(0.3),
//                   gradientColors[0].withOpacity(0.1),
//                   Colors.transparent,
//                 ],
//                 stops: const [0.0, 0.7, 1.0],
//               ),
//             ),
//           ),
//
//           // Avatar
//           Container(
//             margin: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.white,
//                   gradientColors[0].withOpacity(0.1),
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: gradientColors[0].withOpacity(0.2),
//                   blurRadius: 15,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(4),
//               child: AvatarWidget(
//                 firstName: widget.children.firstName ?? '',
//                 lastName: widget.children.lastName ?? '',
//                 backgroundColor: gradientColors[0],
//                 textColor: Colors.white,
//                 imageUrl: widget.children.imageUrl,
//                 radius: 32,
//                 showBorder: true,
//                 borderColor: Colors.white,
//                 borderWidth: 2,
//               ),
//             ),
//           ),
//
//           // Status Indicator
//           Positioned(
//             bottom: 8,
//             right: 8,
//             child: Container(
//               width: 16,
//               height: 16,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.green.shade400,
//                     Colors.green.shade600,
//                   ],
//                 ),
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: Colors.white,
//                   width: 2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.green.withOpacity(0.4),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContentSection(
//       String ageString,
//       String languageCode,
//       List<Color> gradientColors,
//       ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Name
//         Text(
//           '${widget.children.firstName} ${widget.children.lastName}',
//           style: getBoldStyle(
//             color: ColorManager.primaryColor,
//             fontSize: 20,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//
//         const SizedBox(height: 6),
//
//         // Age
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 gradientColors[0].withOpacity(0.1),
//                 gradientColors[1].withOpacity(0.1),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: gradientColors[0].withOpacity(0.2),
//               width: 1,
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.cake_outlined,
//                 size: 14,
//                 color: gradientColors[0],
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 ageString,
//                 style: getSemiBoldStyle(
//                   color: gradientColors[0],
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 12),
//
//         // Tags Row
//         Wrap(
//           spacing: 8,
//           runSpacing: 6,
//           children: [
//             // Gender Tag
//             _buildInfoTag(
//               icon: widget.children.gender?.toLowerCase() == 'male'
//                   ? Icons.male
//                   : Icons.female,
//               text: genderToText(widget.children.gender ?? '', languageCode),
//               color: widget.children.gender?.toLowerCase() == 'male'
//                   ? Colors.blue.shade600
//                   : Colors.pink.shade600,
//             ),
//
//             // Friends Count
//             if (widget.children.friendsCount != null)
//               _buildInfoTag(
//                 icon: Icons.people_outline,
//                 text: '${widget.children.friendsCount}',
//                 color: Colors.orange.shade600,
//               ),
//
//             // Siblings Count
//             if (widget.children.siblingsCount != null)
//               _buildInfoTag(
//                 icon: Icons.family_restroom,
//                 text: '${widget.children.siblingsCount}',
//                 color: Colors.teal.shade600,
//               ),
//           ],
//         ),
//
//         const SizedBox(height: 12),
//
//         // Progress Indicator
//         _buildProgressSection(gradientColors),
//       ],
//     );
//   }
//
//   Widget _buildInfoTag({
//     required IconData icon,
//     required String text,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: color),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressSection(List<Color> gradientColors) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(
//               Icons.auto_stories_outlined,
//               size: 14,
//               color: gradientColors[0],
//             ),
//             const SizedBox(width: 6),
//             Text(
//               'التقدم التعليمي',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: gradientColors[0],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Container(
//           height: 6,
//           decoration: BoxDecoration(
//             color: gradientColors[0].withOpacity(0.1),
//             borderRadius: BorderRadius.circular(3),
//           ),
//           child: FractionallySizedBox(
//             alignment: Alignment.centerLeft,
//             widthFactor: 0.7, // يمكن تخصيصها حسب التقدم الفعلي
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: gradientColors,
//                 ),
//                 borderRadius: BorderRadius.circular(3),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionsSection(List<Color> gradientColors) {
//     return Column(
//       children: [
//         _buildActionButton(
//           icon: Icons.edit_rounded,
//           color: gradientColors[0],
//           onTap: () {
//             HapticFeedback.selectionClick();
//             // Handle edit action
//           },
//           tooltip: 'تعديل',
//         ),
//
//         const SizedBox(height: 12),
//
//         _buildActionButton(
//           icon: Icons.delete_rounded,
//           color: Colors.red.shade400,
//           onTap: () => _showDeleteConfirmation(),
//           tooltip: 'حذف',
//         ),
//
//         const SizedBox(height: 12),
//
//         _buildActionButton(
//           icon: Icons.more_vert_rounded,
//           color: Colors.grey.shade600,
//           onTap: () {
//             HapticFeedback.selectionClick();
//             _showMoreOptions();
//           },
//           tooltip: 'المزيد',
//         ),
//       ],
//     );
//   }
//
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
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: color.withOpacity(0.2),
//                 width: 1,
//               ),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 18,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTopBadge() {
//     if (widget.index >= 3) return const SizedBox.shrink();
//
//     final badges = [
//       {'text': 'الأحدث', 'color': Colors.green},
//       {'text': 'مميز', 'color': Colors.blue},
//       {'text': 'نشط', 'color': Colors.orange},
//     ];
//
//     final badge = badges[widget.index];
//
//     return Positioned(
//       top: 16,
//       left: 16,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               badge['color'] as Color,
//               (badge['color'] as Color).withOpacity(0.8),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: (badge['color'] as Color).withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Text(
//           badge['text'] as String,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<Color> _getGradientColors() {
//     final colorSets = [
//       [Colors.blue.shade300, Colors.blue.shade400],
//       [Colors.purple.shade200, Colors.purple.shade600],
//       [Colors.green.shade400, Colors.green.shade600],
//       [Colors.orange.shade400, Colors.orange.shade600],
//       [Colors.pink.shade400, Colors.pink.shade600],
//       [Colors.teal.shade400, Colors.teal.shade600],
//       [Colors.indigo.shade400, Colors.indigo.shade600],
//       [Colors.red.shade400, Colors.red.shade600],
//     ];
//     return colorSets[widget.index % colorSets.length];
//   }
//
//   void _showDeleteConfirmation() {
//     HapticFeedback.mediumImpact();
//     DeleteConfirmationDialog.show(
//       context,
//       childName: '${widget.children.firstName} ${widget.children.lastName}',
//       onConfirm: () async {
//         await context.read<ChildrenCubit>().deleteChild(
//           widget.children.idChildren!,
//         );
//       },
//       onCancel: () {},
//     );
//   }
//
//   void _showMoreOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               '${widget.children.firstName} ${widget.children.lastName}',
//               style: getBoldStyle(
//                 color: ColorManager.primaryColor,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildMoreOption(
//               icon: Icons.visibility_outlined,
//               title: 'عرض التفاصيل',
//               onTap: () {
//                 Navigator.pop(context);
//                 _navigateToDetails();
//               },
//             ),
//             _buildMoreOption(
//               icon: Icons.auto_stories_outlined,
//               title: 'عرض القصص',
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to stories
//               },
//             ),
//             _buildMoreOption(
//               icon: Icons.analytics_outlined,
//               title: 'الإحصائيات',
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to analytics
//               },
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMoreOption({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: ColorManager.primaryColor.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(
//           icon,
//           color: ColorManager.primaryColor,
//           size: 20,
//         ),
//       ),
//       title: Text(
//         title,
//         style: getSemiBoldStyle(
//           color: ColorManager.primaryColor,
//           fontSize: 16,
//         ),
//       ),
//       trailing: Icon(
//         Icons.arrow_forward_ios_rounded,
//         size: 16,
//         color: Colors.grey.shade400,
//       ),
//       onTap: onTap,
//     );
//   }
// }
//
// // Custom Painter for Background Pattern
// class PatternPainter extends CustomPainter {
//   final Color color;
//
//   PatternPainter({required this.color});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//
//     const double spacing = 10;
//
//     for (double x = 0; x < size.width; x += spacing) {
//       for (double y = 0; y < size.height; y += spacing) {
//         canvas.drawCircle(
//           Offset(x, y),
//           1,
//           paint,
//         );
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/functions/calculate_age.dart';
import 'package:wise_child/core/functions/gender_to_text.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/delete_confirmation_dialog.dart';
import 'package:wise_child/features/ChildDetailsPage/presentation/pages/ChildDetailsPage_page.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/bloc/Children_cubit.dart';
import 'package:wise_child/core/widgets/avatar_image.dart';
import '../../../../core/di/di.dart';
import '../../../../localization/locale_cubit.dart';

class EnhancedChildCard extends StatefulWidget {
  final Children children;
  final int index;

  const EnhancedChildCard({
    super.key,
    required this.children,
    required this.index,
  });

  @override
  State<EnhancedChildCard> createState() => _EnhancedChildCardState();
}

class _EnhancedChildCardState extends State<EnhancedChildCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _avatarScaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _avatarScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _navigateToDetails() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BlocProvider.value(
              value: getIt.get<ChildrenCubit>(),
              child: ChildDetailsPage(child: widget.children),
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
  void _navigateToStoriesChild() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BlocProvider.value(
              value: getIt.get<ChildrenCubit>(),
              child: ChildDetailsPage(child: widget.children),
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final isRTL = languageCode == 'ar';
    final ageString = calculateAgeInYearsAndMonths(
      widget.children.dateOfBirth ?? '',
      languageCode,
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(top: 0, bottom: 8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main Card
                _buildMainCard(ageString, languageCode, isRTL),

                // Floating Avatar (positioned based on RTL/LTR)
                _buildFloatingAvatar(isRTL),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainCard(String ageString, String languageCode, bool isRTL) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: _onTapCancel,
      onTap: _navigateToDetails,
      child: Container(
        margin: EdgeInsets.only(
          top: 30,
          // left: isRTL ? 28 : 0,
          // right: isRTL ? 0 : 28,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: ColorManager.primaryColor.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06 * _elevationAnimation.value),
              blurRadius: 25 * _elevationAnimation.value,
              offset: Offset(0, 12 * _elevationAnimation.value),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: ColorManager.primaryColor.withOpacity(0.08 * _elevationAnimation.value),
              blurRadius: 20 * _elevationAnimation.value,
              offset: Offset(0, 6 * _elevationAnimation.value),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(
                isRTL ? 20 : 88,
                20,
                isRTL ? 88 : 20,
                20,
              ),
              child: Row(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  // Content Section
                  Expanded(
                    child: _buildContentSection(ageString, languageCode, isRTL),
                  ),

                  const SizedBox(width: 16),

                  // Actions Section
                  _buildActionsSection(),
                ],
              ),
            ),

            // Top Badge
            // _buildTopBadge(isRTL),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingAvatar(bool isRTL) {
    return Positioned(
      top: 0,
      left: isRTL ? null : 0,
      right: isRTL ? 0 : null,
      child: Transform.scale(
        scale: _avatarScaleAnimation.value,
        child: Hero(
          tag: 'child_avatar_${widget.children.idChildren}',
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                // Inner glow
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Stack(
                children: [
                  // Main Avatar
                  AvatarWidget(
                    firstName: widget.children.firstName ?? '',
                    lastName: widget.children.lastName ?? '',
                    backgroundColor: ColorManager.primaryColor,
                    textColor: Colors.white,
                    imageUrl: widget.children.imageUrl,
                    radius: 31,
                    showBorder: true,
                    borderColor: Colors.white,
                    borderWidth: 3,
                  ),

                  // Status Indicator
                  Positioned(
                    bottom: 2,
                    right: isRTL ? null : 2,
                    left: isRTL ? 2 : null,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade600,
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildContentSection(String ageString, String languageCode, bool isRTL) {
    return Column(
      crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Name
        Text(
          '${widget.children.firstName} ${widget.children.lastName}',
          style: getBoldStyle(
            color: ColorManager.primaryColor,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),

        const SizedBox(height: 8),

        // Age Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: ColorManager.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorManager.primaryColor.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                Icons.cake_outlined,
                size: 14,
                color: ColorManager.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                ageString,
                style: getSemiBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Info Tags with the required Wrap structure
        Wrap(
          spacing: 8,
          runSpacing: 6,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            // Gender Tag
            _buildInfoTag(
              icon: widget.children.gender?.toLowerCase() == 'male'
                  ? Icons.male
                  : Icons.female,
              text: genderToText(widget.children.gender ?? '', languageCode),
              color: widget.children.gender?.toLowerCase() == 'male'
                  ? Colors.blue.shade600
                  : Colors.pink.shade600,
              isRTL: isRTL,
            ),

            // Friends Count
            if (widget.children.friendsCount != null)
              _buildInfoTag(
                icon: Icons.people_outline,
                text: '${widget.children.friendsCount}',
                color: Colors.orange.shade600,
                isRTL: isRTL,
              ),

            // Siblings Count
            if (widget.children.siblingsCount != null)
              _buildInfoTag(
                icon: Icons.family_restroom,
                text: '${widget.children.siblingsCount}',
                color: Colors.teal.shade600,
                isRTL: isRTL,
              ),
          ],
        ),

        // const SizedBox(height: 16),
        //
        // // Progress Section
        // _buildProgressSection(isRTL),
      ],
    );
  }

  Widget _buildInfoTag({
    required IconData icon,
    required String text,
    required Color color,
    required bool isRTL,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildActionsSection() {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.edit_rounded,
          color: ColorManager.primaryColor,
          onTap: () {
            HapticFeedback.selectionClick();
            // Handle edit action
          },
          tooltip: 'تعديل',
        ),

        const SizedBox(height: 10),

        _buildActionButton(
          icon: Icons.delete_rounded,
          color: Colors.red.shade400,
          onTap: () => _showDeleteConfirmation(),
          tooltip: 'حذف',
        ),

        const SizedBox(height: 10),

        _buildActionButton(
          icon: Icons.more_vert_rounded,
          color: Colors.grey.shade500,
          onTap: () {
            HapticFeedback.selectionClick();
            _showMoreOptions();
          },
          tooltip: 'المزيد',
        ),
      ],
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
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withOpacity(0.15),
                width: 1,
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

  // Widget _buildTopBadge(bool isRTL) {
  //   if (widget.index >= 3) return const SizedBox.shrink();
  //
  //   final badges = [
  //     {'text': 'الأحدث', 'color': Colors.green.shade400},
  //     {'text': 'مميز', 'color': Colors.blue.shade400},
  //     {'text': 'نشط', 'color': Colors.orange.shade400},
  //   ];
  //
  //   final badge = badges[widget.index];
  //
  //   return Positioned(
  //     top: 12,
  //     right: isRTL ? null : 16,
  //     left: isRTL ? 16 : null,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [
  //             badge['color'] as Color,
  //             (badge['color'] as Color).withOpacity(0.8),
  //           ],
  //         ),
  //         borderRadius: BorderRadius.circular(12),
  //         boxShadow: [
  //           BoxShadow(
  //             color: (badge['color'] as Color).withOpacity(0.3),
  //             blurRadius: 6,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Text(
  //         badge['text'] as String,
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 9,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showDeleteConfirmation() {
    HapticFeedback.mediumImpact();
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

  void _showMoreOptions() {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final isRTL = languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                textDirection: isRTL ?  TextDirection.ltr:TextDirection.rtl ,
                children: [
                  AvatarWidget(
                    firstName: widget.children.firstName ?? '',
                    lastName: widget.children.lastName ?? '',
                    backgroundColor: ColorManager.primaryColor,
                    textColor: Colors.white,
                    imageUrl: widget.children.imageUrl,
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${widget.children.firstName} ${widget.children.lastName}',
                    style: getBoldStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 16,
                    ),
                    textDirection: isRTL ?  TextDirection.ltr:TextDirection.rtl ,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Options
            _buildMoreOption(
              icon: Icons.visibility_outlined,
              title: 'عرض التفاصيل',
              subtitle: 'مشاهدة جميع معلومات الطفل',
              isRTL: isRTL,
              onTap: () {
                Navigator.pop(context);
                _navigateToDetails();
              },
            ),
            _buildMoreOption(
              icon: Icons.auto_stories_outlined,
              title: 'عرض القصص',
              subtitle: 'استعراض القصص المخصصة',
              isRTL: isRTL,
              onTap: () {
                Navigator.pop(context);
                _navigateToStoriesChild();
                // Navigate to stories
              },
            ),
            // _buildMoreOption(
            //   icon: Icons.analytics_outlined,
            //   title: 'الإحصائيات',
            //   subtitle: 'تتبع التقدم والأنشطة',
            //   isRTL: isRTL,
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Navigate to analytics
            //   },
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isRTL,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorManager.primaryColor.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              textDirection:  isRTL ?  TextDirection.ltr:TextDirection.rtl ,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: ColorManager.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: getSemiBoldStyle(
                          color: ColorManager.primaryColor,
                          fontSize: 15,
                        ),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isRTL ? Icons.arrow_back_ios_rounded :Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: ColorManager.primaryColor.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

