// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
//
// class StoryFloatingActions extends StatelessWidget {
//   final bool hasChanges;
//   final bool isSaving;
//   final File? selectedImage;
//   final bool showDeleteConfirmation;
//   final VoidCallback onCancel;
//   final VoidCallback onUploadImage;
//   final VoidCallback onConfirmDelete;
//
//   const StoryFloatingActions({
//     super.key,
//     required this.hasChanges,
//     required this.isSaving,
//     this.selectedImage,
//     required this.showDeleteConfirmation,
//     required this.onCancel,
//     required this.onUploadImage,
//     required this.onConfirmDelete,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (!hasChanges) return const SizedBox.shrink();
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // Cancel Button (if there are changes)
//           if (hasChanges)
//             FloatingActionButton.extended(
//               onPressed: isSaving ? null : onCancel,
//               heroTag: "cancel",
//               backgroundColor: Colors.grey.shade600,
//               foregroundColor: Colors.white,
//               icon: const Icon(Icons.close),
//               label: const Text('إلغاء'),
//               elevation: 8,
//             ),
//
//           // Save/Send Button
//           if (selectedImage != null)
//             FloatingActionButton.extended(
//               onPressed: isSaving ? null : onUploadImage,
//               heroTag: "save_image",
//               backgroundColor: ColorManager.primaryColor,
//               foregroundColor: Colors.white,
//               icon: isSaving
//                   ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Colors.white,
//                   ),
//                 ),
//               )
//                   : const Icon(Icons.cloud_upload),
//               label: Text(isSaving ? 'جاري الحفظ...' : 'رفع الصورة'),
//               elevation: 8,
//             ),
//
//           // Confirm Delete Button
//           if (showDeleteConfirmation)
//             FloatingActionButton.extended(
//               onPressed: isSaving ? null : onConfirmDelete,
//               heroTag: "confirm_delete",
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//               icon: isSaving
//                   ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//                   : const Icon(Icons.delete_forever),
//               label: Text(isSaving ? 'جاري الحذف...' : 'تأكيد الحذف'),
//               elevation: 8,
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';

class StoryFloatingActions extends StatelessWidget {
  final bool hasChanges;
  final bool isSaving;
  final File? selectedImage;
  final bool showDeleteConfirmation;
  final VoidCallback onCancel;
  final VoidCallback onUploadImage;
  final VoidCallback onConfirmDelete;

  const StoryFloatingActions({
    super.key,
    required this.hasChanges,
    required this.isSaving,
    this.selectedImage,
    required this.showDeleteConfirmation,
    required this.onCancel,
    required this.onUploadImage,
    required this.onConfirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasChanges) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Cancel Button (if there are changes)
          if (hasChanges)
            FloatingActionButton.extended(
              onPressed: isSaving ? null : onCancel,
              heroTag: "cancel",
              backgroundColor: Colors.grey.shade600,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.close),
              label: const Text('إلغاء'),
              elevation: 8,
            ),

          // Save/Send Button
          if (selectedImage != null)
            FloatingActionButton.extended(
              onPressed: isSaving ? null : onUploadImage,
              heroTag: "save_image",
              backgroundColor: ColorManager.primaryColor,
              foregroundColor: Colors.white,
              icon: isSaving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
                  : const Icon(Icons.cloud_upload),
              label: Text(isSaving ? 'جاري الحفظ...' : 'رفع الصورة'),
              elevation: 8,
            ),

          // Confirm Delete Button
          if (showDeleteConfirmation)
            FloatingActionButton.extended(
              onPressed: isSaving ? null : onConfirmDelete,
              heroTag: "confirm_delete",
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: isSaving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Icon(Icons.delete_forever),
              label: Text(isSaving ? 'جاري الحذف...' : 'تأكيد الحذف'),
              elevation: 8,
            ),
        ],
      ),
    );
  }
}