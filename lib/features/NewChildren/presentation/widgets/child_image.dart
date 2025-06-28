// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:wise_child/core/functions/reduce_image_size.dart';
// import 'package:wise_child/features/NewChildren/presentation/bloc/NewChildren_cubit.dart';
// import '../../../../core/resources/app_constants.dart';
// import '../../../../core/resources/assets_manager.dart';
// import '../../../../core/resources/color_manager.dart';
// import '../../../../core/resources/values_manager.dart';
// import '../../../../core/widgets/custom_dialog.dart';
//
// class ChangeChildrenImage extends StatefulWidget {
//   const ChangeChildrenImage({super.key});
//
//   @override
//   State<ChangeChildrenImage> createState() => _ChangeChildrenImageState();
// }
//
// class _ChangeChildrenImageState extends State<ChangeChildrenImage> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         CustomDialog.showDialogAddImage(
//           context,
//           camera: () async {
//             XFile? xFile = await ImagePicker().pickImage(
//               source: ImageSource.camera,
//             );
//             if (xFile != null) {
//               File originalImageFile = File(xFile.path);
//
//               final File resizedImageFile = await resizeAndCompressImage(
//                 imageFile: originalImageFile,
//               );
//               setState(() {});
//               if (context.mounted) {
//                 context.read<NewChildrenCubit>().changeImage(resizedImageFile);
//               }
//             }
//           },
//           gallery: () async {
//             XFile? xFile = await ImagePicker().pickImage(
//               source: ImageSource.gallery,
//             );
//             if (xFile != null) {
//               File originalImageFile = File(xFile.path);
//
//               final File resizedImageFile = await resizeAndCompressImage(
//                 imageFile: originalImageFile,
//               );
//               setState(() {});
//               if (context.mounted) {
//                 context.read<NewChildrenCubit>().changeImage(resizedImageFile);
//               }
//             }
//           },
//         );
//       },
//
//       child: BlocBuilder<NewChildrenCubit, NewChildrenState>(
//         builder: (context, state) {
//           final profileImage = context.read<NewChildrenCubit>().profileImage;
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Stack(
//                 alignment: Alignment.center,
//                 clipBehavior: Clip.none,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(AppSize.s0),
//                     clipBehavior: Clip.antiAlias,
//                     height: AppSize.s100,
//                     width:  AppSize.s100,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: ColorManager.primaryColor,
//                       boxShadow: [
//                         BoxShadow(
//                           color: ColorManager.primaryColor.withAlpha(AppSizeInt.s65),
//                           blurRadius: AppSize.s10,
//                           spreadRadius: AppSize.s3,
//                           offset: Offset(AppSize.s0, AppSize.s0),
//                         ),
//                       ],
//                     ),
//                     child: profileImage != null
//                         ? Image.file(
//                       profileImage,
//                       fit: BoxFit.fill,
//                       width: double.infinity,
//                     )
//                         :Icon(Icons.person,size: AppSize.s50,color: ColorManager.white,),
//                   ),
//                   Positioned(
//                     bottom: -2,
//                     right: -2,
//
//                     child: Container(
//                       height: AppSize.s30,
//                       width: AppSize.s30,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: ColorManager.white,
//                       ),
//                       child: Icon(
//                         Icons.edit,
//                         color: ColorManager.primaryColor,
//                         size: AppSize.s20,),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wise_child/core/functions/reduce_image_size.dart';
import 'package:wise_child/features/NewChildren/presentation/bloc/NewChildren_cubit.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/widgets/custom_dialog.dart';

class ChangeChildrenImage extends StatefulWidget {
  const ChangeChildrenImage({super.key});

  @override
  State<ChangeChildrenImage> createState() => _ChangeChildrenImageState();
}

class _ChangeChildrenImageState extends State<ChangeChildrenImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? xFile = await ImagePicker().pickImage(source: source);
      if (xFile != null) {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });

        File originalImageFile = File(xFile.path);
        final File resizedImageFile = await resizeAndCompressImage(
          imageFile: originalImageFile,
        );

        if (context.mounted) {
          context.read<NewChildrenCubit>().changeImage(resizedImageFile);
        }
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ في اختيار الصورة'),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'اختر مصدر الصورة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSourceOption(
                          icon: Icons.camera_alt_outlined,
                          label: 'الكاميرا',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSourceOption(
                          icon: Icons.photo_library_outlined,
                          label: 'المعرض',
                          color: Colors.green,
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'إلغاء',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewChildrenCubit, NewChildrenState>(
      builder: (context, state) {
        final profileImage = context.read<NewChildrenCubit>().profileImage;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: profileImage != null
                          ? null
                          : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorManager.primaryColor.withOpacity(0.8),
                          ColorManager.primaryColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.primaryColor.withOpacity(0.3),
                          offset: const Offset(0, 8),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: profileImage != null
                          ? Image.file(
                        profileImage,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      )
                          : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              ColorManager.primaryColor.withOpacity(0.8),
                              ColorManager.primaryColor,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'إضافة صورة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}