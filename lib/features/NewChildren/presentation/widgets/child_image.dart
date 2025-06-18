import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wise_child/core/functions/reduce_image_size.dart';
import 'package:wise_child/features/NewChildren/presentation/bloc/NewChildren_cubit.dart';
import '../../../../core/resources/app_constants.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/values_manager.dart';
import '../../../../core/widgets/custom_dialog.dart';

class ChangeUserImage extends StatefulWidget {
  const ChangeUserImage({super.key});

  @override
  State<ChangeUserImage> createState() => _ChangeUserImageState();
}

class _ChangeUserImageState extends State<ChangeUserImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CustomDialog.showDialogAddImage(
          context,
          camera: () async {
            XFile? xFile = await ImagePicker().pickImage(
              source: ImageSource.camera,
            );
            if (xFile != null) {
              File originalImageFile = File(xFile.path);

              final File resizedImageFile = await resizeAndCompressImage(
                imageFile: originalImageFile,
              );
              setState(() {});
              if (context.mounted) {
                context.read<NewChildrenCubit>().changeImage(resizedImageFile);
              }
            }
          },
          gallery: () async {
            XFile? xFile = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (xFile != null) {
              File originalImageFile = File(xFile.path);

              final File resizedImageFile = await resizeAndCompressImage(
                imageFile: originalImageFile,
              );
              setState(() {});
              if (context.mounted) {
                context.read<NewChildrenCubit>().changeImage(resizedImageFile);
              }
            }
          },
        );
      },

      child: BlocBuilder<NewChildrenCubit, NewChildrenState>(
        builder: (context, state) {
          final profileImage = context.read<NewChildrenCubit>().profileImage;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSize.s0),
                    clipBehavior: Clip.antiAlias,
                    height: AppSize.s100,
                    width:  AppSize.s100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.white.withAlpha(AppSizeInt.s65),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.white.withAlpha(AppSizeInt.s65),
                          blurRadius: AppSize.s10,
                          spreadRadius: AppSize.s3,
                          offset: Offset(AppSize.s0, AppSize.s0),
                        ),
                      ],
                    ),
                    child: profileImage != null
                        ? Image.file(
                      profileImage,
                      fit: BoxFit.fill,
                      width: double.infinity,
                    )
                        :Icon(Icons.person,size: AppSize.s50,color: ColorManager.white,),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,

                    child: Container(
                      height: AppSize.s30,
                      width: AppSize.s30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorManager.white.withAlpha(AppSizeInt.s65),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: ColorManager.white,
                        size: AppSize.s20,),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

