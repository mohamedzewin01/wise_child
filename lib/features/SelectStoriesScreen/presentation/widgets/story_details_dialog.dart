//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:wise_child/core/api/api_constants.dart';
// import 'package:wise_child/core/di/di.dart';
// import 'package:wise_child/core/resources/color_manager.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
// import 'package:wise_child/core/widgets/expandable_text.dart';
// import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto.dart';
// import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/save_story_cubit.dart';
// import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/add_kids_favorite_image_cubit.dart';
//
// class StoryDetailsDialog {
//   static void show({
//     required BuildContext context,
//     required StoriesCategory story,
//     required bool isRTL,
//     required int childId,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: getIt.get<SaveStoryCubit>()),
//           BlocProvider.value(value: getIt.get<AddKidsFavoriteImageCubit>()),
//         ],
//         child: _StoryDetailsContent(
//           story: story,
//           isRTL: isRTL,
//           childId: childId,
//         ),
//       ),
//     );
//   }
// }
//
// class _StoryDetailsContent extends StatefulWidget {
//   final StoriesCategory story;
//   final bool isRTL;
//   final int childId;
//
//   const _StoryDetailsContent({
//     required this.story,
//     required this.isRTL,
//     required this.childId,
//   });
//
//   @override
//   State<_StoryDetailsContent> createState() => _StoryDetailsContentState();
// }
//
// class _StoryDetailsContentState extends State<_StoryDetailsContent> {
//   bool _isSaving = false;
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.90,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         children: [
//           // Handle
//           _buildHandle(),
//
//           // Header
//           _buildHeader(context),
//
//           // Content
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Story Image
//                   if (widget.story.imageCover != null && widget.story.imageCover!.isNotEmpty)
//                     _buildStoryImage(),
//
//                   const SizedBox(height: 20),
//
//                   // Add Favorite Image Section
//                   _buildAddImageSection(),
//
//                   const SizedBox(height: 20),
//
//                   // Story Description
//                   if (widget.story.storyDescription != null) ...[
//                     _buildSectionTitle('وصف القصة:'),
//                     const SizedBox(height: 8),
//                     _buildDescription(),
//                     const SizedBox(height: 20),
//                   ],
//
//                   // Story Info
//                   _buildSectionTitle('معلومات القصة:'),
//                   const SizedBox(height: 12),
//                   _buildStoryInfo(),
//
//                   // Problem Info
//                   if (widget.story.problem != null) ...[
//                     const SizedBox(height: 20),
//                     _buildProblemInfo(),
//                   ],
//
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//
//           // Action Buttons
//           _buildActionButtons(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHandle() {
//     return Container(
//       margin: const EdgeInsets.only(top: 12),
//       width: 40,
//       height: 4,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(2),
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
//         children: [
//           Expanded(
//             child: Text(
//               widget.story.storyTitle ?? 'تفاصيل القصة',
//               style: getBoldStyle(
//                 color: ColorManager.primaryColor,
//                 fontSize: 20,
//               ),
//               textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade300,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: IconButton(
//               onPressed: () => Navigator.of(context).pop(),
//               icon: const Icon(Icons.close),
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAddImageSection() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             ColorManager.primaryColor.withOpacity(0.05),
//             Colors.purple.shade50.withOpacity(0.3),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorManager.primaryColor.withOpacity(0.2), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: ColorManager.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   Icons.favorite,
//                   size: 20,
//                   color: ColorManager.primaryColor,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   'أضف صورة مفضلة للطفل',
//                   style: getBoldStyle(
//                     color: ColorManager.primaryColor,
//                     fontSize: 16,
//                   ),
//                   textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'اختر صورة للعبة المفضلة لطفلك أو المكان الذي يحب اللعب فيه. ستظهر هذه الصورة داخل القصة لجعلها أكثر تشويقاً وقرباً منه! 📸✨',
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.grey.shade600,
//               height: 1.4,
//             ),
//             textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
//           ),
//           const SizedBox(height: 16),
//
//           // Image selection area
//           _selectedImage != null ? _buildSelectedImage() : _buildImageSelector(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImageSelector() {
//     return InkWell(
//       onTap: _pickImage,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         height: 120,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: ColorManager.primaryColor.withOpacity(0.3),
//             width: 2,
//             style: BorderStyle.solid,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.add_photo_alternate_rounded,
//               size: 36,
//               color: ColorManager.primaryColor.withOpacity(0.7),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'اضغط لاختيار صورة',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: ColorManager.primaryColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '(اختياري)',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSelectedImage() {
//     return Container(
//       height: 120,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: ColorManager.primaryColor.withOpacity(0.3),
//           width: 2,
//         ),
//       ),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.file(
//               _selectedImage!,
//               width: double.infinity,
//               height: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             top: 8,
//             right: 8,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: IconButton(
//                 onPressed: () {
//                   setState(() {
//                     _selectedImage = null;
//                   });
//                 },
//                 icon: const Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 padding: const EdgeInsets.all(4),
//                 constraints: const BoxConstraints(
//                   minWidth: 32,
//                   minHeight: 32,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 8,
//             right: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.8),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.check_circle,
//                     color: Colors.white,
//                     size: 14,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     'تم اختيار الصورة',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                     ),
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
//   Widget _buildStoryImage() {
//     return Container(
//       height: 200,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: ColorManager.primaryColor.withOpacity(0.1),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Image.network(
//           '${ApiConstants.urlImage}${widget.story.imageCover}',
//           fit: BoxFit.fill,
//           errorBuilder: (context, error, stackTrace) {
//             return _buildPlaceholderImage();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlaceholderImage() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.auto_stories,
//             size: 48,
//             color: ColorManager.primaryColor.withOpacity(0.7),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'غلاف القصة',
//             style: TextStyle(
//               fontSize: 16,
//               color: ColorManager.primaryColor.withOpacity(0.7),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: getBoldStyle(color: ColorManager.primaryColor, fontSize: 16),
//     );
//   }
//
//   Widget _buildDescription() {
//     return ExpandableText(
//       description: widget.story.storyDescription!,
//       isRTL: widget.isRTL,
//     );
//   }
//
//   Widget _buildStoryInfo() {
//     return Wrap(
//       spacing: 12,
//       runSpacing: 8,
//       children: [
//         if (widget.story.ageGroup != null)
//           _buildDetailChip(
//             icon: Icons.child_care,
//             label: widget.story.ageGroup!,
//             color: ColorManager.primaryColor,
//           ),
//         if (widget.story.gender != null)
//           _buildDetailChip(
//             icon: Icons.person,
//             label: widget.story.gender!,
//             color: Colors.green.shade600,
//           ),
//         if (widget.story.isActive == true)
//           _buildDetailChip(
//             icon: Icons.check_circle,
//             label: 'نشطة',
//             color: Colors.blue.shade600,
//           ),
//       ],
//     );
//   }
//
//   Widget _buildProblemInfo() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.orange.shade50,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.orange.shade200, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
//             children: [
//               Icon(Icons.psychology, size: 20, color: Colors.orange.shade700),
//               const SizedBox(width: 8),
//               Text(
//                 'تساعد في حل:',
//                 style: getBoldStyle(
//                   color: Colors.orange.shade800,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             widget.story.problem!.problemTitle ?? 'مشكلة غير محددة',
//             style: getBoldStyle(
//               color: Colors.orange.shade700,
//               fontSize: 16,
//             ),
//             textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
//           ),
//           if (widget.story.problem!.problemDescription != null) ...[
//             const SizedBox(height: 6),
//             Text(
//               widget.story.problem!.problemDescription!,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.orange.shade600,
//                 height: 1.4,
//               ),
//               textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3), width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: color),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 13,
//               color: color,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener<SaveStoryCubit, SaveStoryState>(
//             listener: (context, state) {
//               if (state is SaveStorySuccess) {
//                 // إذا تم حفظ القصة بنجاح، قم برفع الصورة إذا كانت موجودة
//                 if (_selectedImage != null) {
//                   _uploadFavoriteImage();
//                 } else {
//                   // إذا لم تكن هناك صورة، أكمل العملية
//                   _handleSuccessWithoutImage();
//                 }
//               } else if (state is SaveStoryFailure) {
//                 setState(() {
//                   _isSaving = false;
//                 });
//                 Navigator.of(context).pop();
//                 _showErrorMessage(context, 'يمكنك اختيار قصة أخرى');
//               } else if (state is SaveStoryLoading) {
//                 setState(() {
//                   _isSaving = true;
//                 });
//               }
//             },
//           ),
//           BlocListener<AddKidsFavoriteImageCubit, AddKidsFavoriteImageState>(
//             listener: (context, state) {
//               if (state is AddKidsFavoriteImageSuccess) {
//                 setState(() {
//                   _isSaving = false;
//                 });
//                 Navigator.of(context).pop();
//                 _showSuccessMessage(context, withImage: true);
//               } else if (state is AddKidsFavoriteImageFailure) {
//                 setState(() {
//                   _isSaving = false;
//                 });
//                 Navigator.of(context).pop();
//                 // حتى لو فشل رفع الصورة، فإن القصة تم حفظها بنجاح
//                 _showSuccessMessage(context, withImage: false, imageError: true);
//               }
//             },
//           ),
//         ],
//         child: Row(
//           children: [
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: ColorManager.primaryColor),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: Text(
//                   'إلغاء',
//                   style: TextStyle(color: ColorManager.primaryColor),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               flex: 2,
//               child: ElevatedButton(
//                 onPressed: _isSaving ? null : _saveStory,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ColorManager.primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   elevation: 2,
//                 ),
//                 child: _isSaving
//                     ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                     : const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.add_circle_sharp,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       'إضافة القصة',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1024,
//         maxHeight: 1024,
//         imageQuality: 85,
//       );
//
//       if (image != null) {
//         setState(() {
//           _selectedImage = File(image.path);
//         });
//         HapticFeedback.lightImpact();
//       }
//     } catch (e) {
//       _showErrorMessage(context, 'حدث خطأ أثناء اختيار الصورة');
//     }
//   }
//
//   void _saveStory() {
//     // التحقق من وجود المعطيات المطلوبة
//     if (widget.story.storyId == null) {
//       _showErrorMessage(context, 'معرف القصة غير موجود');
//       return;
//     }
//
//     if (widget.story.problem?.problemId == null) {
//       _showErrorMessage(context, 'معرف المشكلة غير موجود');
//       return;
//     }
//
//     HapticFeedback.lightImpact();
//
//     final saveStoryCubit = context.read<SaveStoryCubit>();
//     saveStoryCubit.saveStory(
//       storyId: widget.story.storyId!,
//       childrenId: widget.childId,
//       problemId: widget.story.problem!.problemId!,
//     );
//   }
//
//   void _uploadFavoriteImage() {
//     if (_selectedImage != null) {
//       final addImageCubit = context.read<AddKidsFavoriteImageCubit>();
//       addImageCubit.image = _selectedImage;
//       addImageCubit.idChildren = widget.childId;
//       addImageCubit.storyId = widget.story.storyId;
//       addImageCubit.addKidsFavoriteImage();
//     }
//   }
//
//   void _handleSuccessWithoutImage() {
//     setState(() {
//       _isSaving = false;
//     });
//     Navigator.of(context).pop();
//     _showSuccessMessage(context, withImage: false);
//   }
//
//   void _showSuccessMessage(BuildContext context, {bool withImage = false, bool imageError = false}) {
//     HapticFeedback.lightImpact();
//     String message = 'تم حفظ القصة بنجاح!';
//     String subtitle = widget.story.storyTitle ?? 'القصة المحددة';
//
//     if (withImage) {
//       message = 'تم حفظ القصة والصورة بنجاح!';
//       subtitle = 'ستظهر الصورة المفضلة داخل القصة';
//     } else if (imageError) {
//       message = 'تم حفظ القصة بنجاح!';
//       subtitle = 'لكن حدث خطأ في رفع الصورة';
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 imageError ? Icons.warning : Icons.check_circle,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     message,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: imageError ? Colors.orange.shade600 : Colors.green.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   void _showErrorMessage(BuildContext context, String errorMessage) {
//     HapticFeedback.heavyImpact();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.error_outline,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'القصة مضافة بالفعل',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     errorMessage,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.white70,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.red.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         duration: const Duration(seconds: 4),
//         action: SnackBarAction(
//           label: 'إعادة المحاولة',
//           textColor: Colors.white,
//           onPressed: _saveStory,
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/di/di.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/expandable_text.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto/stories_by_category_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/save_story_cubit.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/add_kids_favorite_image_cubit.dart';

class StoryDetailsDialog {
  static void show({
    required BuildContext context,
    required StoriesCategory story,
    required bool isRTL,
    required int childId,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: getIt.get<SaveStoryCubit>()),
          BlocProvider.value(value: getIt.get<KidsFavoriteImageCubit>()),
        ],
        child: _StoryDetailsContent(
          story: story,
          isRTL: isRTL,
          childId: childId,
        ),
      ),
    );
  }
}

class _StoryDetailsContent extends StatefulWidget {
  final StoriesCategory story;
  final bool isRTL;
  final int childId;

  const _StoryDetailsContent({
    required this.story,
    required this.isRTL,
    required this.childId,
  });

  @override
  State<_StoryDetailsContent> createState() => _StoryDetailsContentState();
}

class _StoryDetailsContentState extends State<_StoryDetailsContent> {
  bool _isSaving = false;
  File? _selectedImage;
  bool _noImageConfirmed = false;
  final ImagePicker _picker = ImagePicker();

  bool get _canAddStory => _selectedImage != null || _noImageConfirmed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          _buildHandle(),

          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Story Image
                  if (widget.story.imageCover != null &&
                      widget.story.imageCover!.isNotEmpty)
                    _buildStoryImage(),

                  const SizedBox(height: 20),

                  // Add Favorite Image Section
                  _buildAddImageSection(),

                  const SizedBox(height: 20),

                  // Story Description
                  if (widget.story.storyDescription != null) ...[
                    _buildSectionTitle('وصف القصة:'),
                    const SizedBox(height: 8),
                    _buildDescription(),
                    const SizedBox(height: 20),
                  ],

                  // Story Info
                  _buildSectionTitle('معلومات القصة:'),
                  const SizedBox(height: 12),
                  _buildStoryInfo(),

                  // Problem Info
                  if (widget.story.problem != null) ...[
                    const SizedBox(height: 20),
                    _buildProblemInfo(),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Action Buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.transparent,
      child: Row(
        textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Expanded(
            child: Text(
              widget.story.storyTitle ?? 'تفاصيل القصة',
              style: getBoldStyle(
                color: ColorManager.primaryColor,
                fontSize: 20,
              ),
              textDirection: widget.isRTL
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor.withOpacity(0.05),
            Colors.purple.shade50.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorManager.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.favorite,
                  size: 20,
                  color: ColorManager.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'أضف صورة مفضلة للطفل',
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 16,
                  ),
                  textDirection: widget.isRTL
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'اختر صورة للعبة المفضلة لطفلك أو المكان الذي يحب اللعب فيه. ستظهر هذه الصورة داخل القصة لجعلها أكثر تشويقاً وقرباً منه! 📸✨',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
            textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
          const SizedBox(height: 16),

          // Image selection area
          _selectedImage != null
              ? _buildSelectedImage()
              : _buildImageSelector(),

          const SizedBox(height: 16),

          // Checkbox for confirming no image
          _buildNoImageCheckbox(),
        ],
      ),
    );
  }

  Widget _buildImageSelector() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.primaryColor.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_rounded,
              size: 36,
              color: ColorManager.primaryColor.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            Text(
              'اضغط لاختيار صورة',
              style: TextStyle(
                fontSize: 14,
                color: ColorManager.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '(اختياري)',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImage() {
    return Center(
      child: Container(
        height: 250,
        width:200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _selectedImage!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                      // لا نلغي _noImageConfirmed هنا لأن المستخدم قد يريد الاستمرار بدون صورة
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.white, size: 18),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'تم اختيار الصورة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorManager.primaryColor.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          '${ApiConstants.urlImage}${widget.story.imageCover}',
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories,
            size: 48,
            color: ColorManager.primaryColor.withOpacity(0.7),
          ),
          const SizedBox(height: 12),
          Text(
            'غلاف القصة',
            style: TextStyle(
              fontSize: 16,
              color: ColorManager.primaryColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: getBoldStyle(color: ColorManager.primaryColor, fontSize: 16),
    );
  }

  Widget _buildDescription() {
    return ExpandableText(
      description: widget.story.storyDescription!,
      isRTL: widget.isRTL,
    );
  }

  Widget _buildStoryInfo() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        if (widget.story.ageGroup != null)
          _buildDetailChip(
            icon: Icons.child_care,
            label: widget.story.ageGroup!,
            color: ColorManager.primaryColor,
          ),
        if (widget.story.gender != null)
          _buildDetailChip(
            icon: Icons.person,
            label: widget.story.gender!,
            color: Colors.green.shade600,
          ),
        if (widget.story.isActive == true)
          _buildDetailChip(
            icon: Icons.check_circle,
            label: 'نشطة',
            color: Colors.blue.shade600,
          ),
      ],
    );
  }

  Widget _buildProblemInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(Icons.psychology, size: 20, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Text(
                'تساعد في حل:',
                style: getBoldStyle(
                  color: Colors.orange.shade800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.story.problem!.problemTitle ?? 'مشكلة غير محددة',
            style: getBoldStyle(color: Colors.orange.shade700, fontSize: 16),
            textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
          if (widget.story.problem!.problemDescription != null) ...[
            const SizedBox(height: 6),
            Text(
              widget.story.problem!.problemDescription!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange.shade600,
                height: 1.4,
              ),
              textDirection: widget.isRTL
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SaveStoryCubit, SaveStoryState>(
            listener: (context, state) {
              if (state is SaveStorySuccess) {
                // إذا تم حفظ القصة بنجاح، قم برفع الصورة إذا كانت موجودة
                if (_selectedImage != null) {
                  _uploadFavoriteImage();
                } else {
                  // إذا لم تكن هناك صورة، أكمل العملية
                  _handleSuccessWithoutImage();
                }
              } else if (state is SaveStoryFailure) {
                setState(() {
                  _isSaving = false;
                });
                Navigator.of(context).pop();
                _showErrorMessage(context, 'يمكنك اختيار قصة اخرى ');

              } else if (state is SaveStoryLoading) {
                setState(() {
                  _isSaving = true;
                });
              }
            },
          ),
          BlocListener<KidsFavoriteImageCubit, AddKidsFavoriteImageState>(
            listener: (context, state) {
              if (state is AddKidsFavoriteImageSuccess) {
                setState(() {
                  _isSaving = false;
                });
                Navigator.of(context).pop();
                _showSuccessMessage(context, withImage: true);
              } else if (state is AddKidsFavoriteImageFailure) {
                setState(() {
                  _isSaving = false;
                });
                Navigator.of(context).pop();
                // حتى لو فشل رفع الصورة، فإن القصة تم حفظها بنجاح
                _showSuccessMessage(
                  context,
                  withImage: false,
                  imageError: true,
                );
              }
            },
          ),
        ],
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: ColorManager.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'إلغاء',
                  style: TextStyle(color: ColorManager.primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: (_isSaving || !_canAddStory) ? null : _saveStory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canAddStory
                      ? ColorManager.primaryColor
                      : Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: _canAddStory ? 2 : 0,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_sharp,
                            color: _canAddStory
                                ? Colors.white
                                : Colors.grey.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'إضافة القصة',
                            style: TextStyle(
                              color: _canAddStory
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _noImageConfirmed =
              false;
        });
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorMessage(context, 'حدث خطأ أثناء اختيار الصورة');
    }
  }

  void _saveStory() {

    if (widget.story.storyId == null) {
      _showErrorMessage(context, 'معرف القصة غير موجود');
      return;
    }

    if (widget.story.problem?.problemId == null) {
      _showErrorMessage(context, 'معرف المشكلة غير موجود');
      return;
    }

    HapticFeedback.lightImpact();

    final saveStoryCubit = context.read<SaveStoryCubit>();
    saveStoryCubit.saveStory(
      storyId: widget.story.storyId!,
      childrenId: widget.childId,
      problemId: widget.story.problem!.problemId!,
    );
  }

  void _uploadFavoriteImage() {
    if (_selectedImage != null) {
      final addImageCubit = context.read<KidsFavoriteImageCubit>();
      addImageCubit.image = _selectedImage;
      addImageCubit.idChildren = widget.childId;
      addImageCubit.storyId = widget.story.storyId;
      addImageCubit.addKidsFavoriteImage();
    }
  }

  void _handleSuccessWithoutImage() {
    setState(() {
      _isSaving = false;
    });
    Navigator.of(context).pop();
    _showSuccessMessage(context, withImage: false);
  }

  Widget _buildNoImageCheckbox() {

    if (_selectedImage != null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _noImageConfirmed
              ? ColorManager.primaryColor.withOpacity(0.5)
              : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        value: _noImageConfirmed,
        onChanged: (bool? value) {
          setState(() {
            _noImageConfirmed = value ?? false;
          });
          HapticFeedback.lightImpact();
        },
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          'متابعة بدون إضافة صورة مفضلة',
          style: getMediumStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),

          textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        subtitle: Text(
          'يمكنك إضافة الصورة لاحقاً من إعدادات القصة',
          style: getMediumStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        activeColor: ColorManager.primaryColor,
        checkColor: Colors.white,
        controlAffinity: widget.isRTL
            ? ListTileControlAffinity.trailing
            : ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessMessage(
    BuildContext context, {
    bool withImage = false,
    bool imageError = false,
  }) {
    HapticFeedback.lightImpact();
    String message = 'تم حفظ القصة بنجاح!';
    String subtitle = widget.story.storyTitle ?? 'القصة المحددة';

    if (withImage) {
      message = 'تم حفظ القصة والصورة بنجاح!';
      subtitle = 'ستظهر الصورة المفضلة داخل القصة';
    } else if (imageError) {
      message = 'تم حفظ القصة بنجاح!';
      subtitle = 'لكن حدث خطأ في رفع الصورة';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                imageError ? Icons.warning : Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: imageError
            ? Colors.orange.shade600
            : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String errorMessage) {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'القصة مضافة بالفعل',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          textColor: Colors.white,
          onPressed: _saveStory,
        ),
      ),
    );
  }
}
