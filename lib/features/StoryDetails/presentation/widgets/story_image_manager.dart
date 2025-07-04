import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/add_kids_favorite_image_cubit.dart';
import 'package:wise_child/features/StoryDetails/data/models/response/story_details_dto.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_snackbar_utils.dart';

class StoryImageManager {
  final BuildContext context;
  final ImagePicker _picker = ImagePicker();

  StoryImageManager(this.context);

  Future<File?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        HapticFeedback.lightImpact();
        return File(image.path);
      }
      return null;
    } catch (e) {
      StorySnackbarUtils.showError(context, 'حدث خطأ أثناء اختيار الصورة');
      return null;
    }
  }

  Future<bool> uploadImage({
    required File image,
    required int childId,
    required int storyId,
  }) async {
    try {
      final addImageCubit = context.read<KidsFavoriteImageCubit>();
      addImageCubit.image = image;
      addImageCubit.idChildren = childId;
      addImageCubit.storyId = storyId;

      await addImageCubit.addKidsFavoriteImage();

      StorySnackbarUtils.showSuccess(context, message: 'تم رفع الصورة بنجاح');
      return true;
    } catch (e) {
      StorySnackbarUtils.showError(context, 'حدث خطأ أثناء رفع الصورة');
      return false;
    }
  }

  Future<bool> deleteImage({
    required StoryDetails story,
    required int childId,
  }) async {

    try {

      if (story.favoriteImage?.idFavoriteImage == null) {
        StorySnackbarUtils.showWarning(context, 'لا توجد صورة مفضلة لحذفها');
        return false;
      }

      await KidsFavoriteImageCubit.get(context).deleteKidsFavoriteImage(
        storyId: story.storyId ?? 0,
        idChildren: childId,
      );
      if (context.mounted) {
        StorySnackbarUtils.showSuccess(context, message: 'تم حذف الصورة بنجاح');
      }

      return true;
    } catch (e, stack) {
      print("ERROR: $e");
      print("STACKTRACE: $stack");

      if (context.mounted) {
        StorySnackbarUtils.showError(context, 'حدث خطأ أثناء حذف الصورة');
      }

      return false;
    }
  }

  Future<void> showDeleteConfirmationDialog({
    required StoryDetails story,
    required int childId,
    required VoidCallback onConfirm,
  }) async {
    // التأكد من وجود صورة للحذف
    if (story.favoriteImage == null) {
      StorySnackbarUtils.showWarning(context, 'لا توجد صورة مفضلة لحذفها');
      return;
    }

    HapticFeedback.mediumImpact();

    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Colors.orange.shade600,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('تأكيد الحذف'),
            ],
          ),
          content: const Text(
            'هل أنت متأكد من أنك تريد حذف الصورة المفضلة؟\n\nلا يمكن التراجع عن هذا الإجراء.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'إلغاء',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      onConfirm();
    }
  }
}
