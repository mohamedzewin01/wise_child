import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/expandable_text.dart';
import 'package:wise_child/features/StoryDetails/data/models/response/story_details_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/save_story_cubit.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/add_kids_favorite_image_cubit.dart';

class StoryDetailsContent extends StatelessWidget {
  final StoryDetails story;
  final bool isRTL;
  final int? childId;
  final File? selectedImage;
  final bool noImageConfirmed;
  final bool isSaving;
  final bool canAddStory;
  final VoidCallback onImagePicked;
  final VoidCallback onImageRemoved;
  final ValueChanged<bool> onNoImageChanged;
  final VoidCallback onSaveStory;

  const StoryDetailsContent({
    required this.story,
    required this.isRTL,
    required this.childId,
    required this.selectedImage,
    required this.noImageConfirmed,
    required this.isSaving,
    required this.canAddStory,
    required this.onImagePicked,
    required this.onImageRemoved,
    required this.onNoImageChanged,
    required this.onSaveStory,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SaveStoryCubit, SaveStoryState>(
          listener: (context, state) {
            if (state is SaveStorySuccess) {
              if (selectedImage != null) {
                _uploadFavoriteImage(context);
              } else {
                _handleSuccessWithoutImage(context);
              }
            } else if (state is SaveStoryFailure) {
              Navigator.of(context).pop();
              _showErrorMessage(context, 'يمكنك اختيار قصة أخرى');
            }
          },
        ),
        BlocListener<AddKidsFavoriteImageCubit, AddKidsFavoriteImageState>(
          listener: (context, state) {
            if (state is AddKidsFavoriteImageSuccess) {
              Navigator.of(context).pop();
              _showSuccessMessage(context, withImage: true);
            } else if (state is AddKidsFavoriteImageFailure) {
              Navigator.of(context).pop();
              _showSuccessMessage(context, withImage: false, imageError: true);
            }
          },
        ),
      ],
      child: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Story Title
                  _buildStoryTitle(),
                  const SizedBox(height: 20),

                  // Add Favorite Image Section (only if childId is provided)
                  if (childId != null) ...[
                    _buildAddImageSection(),
                    const SizedBox(height: 24),
                  ],

                  // Story Info Cards
                  _buildStoryInfoCards(),
                  const SizedBox(height: 24),

                  // Story Description
                  if (story.storyDescription != null) ...[
                    _buildSectionTitle('وصف القصة'),
                    const SizedBox(height: 12),
                    _buildDescription(),
                    const SizedBox(height: 24),
                  ],

                  // Problem Info
                  if (story.problem != null) ...[
                    _buildProblemSection(),
                    const SizedBox(height: 24),
                  ],

                  // Category Info
                  if (story.category != null) ...[
                    _buildCategorySection(),
                    const SizedBox(height: 24),
                  ],

                  // Action Buttons (only if childId is provided)
                  if (childId != null) ...[
                    _buildActionButtons(context),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: ColorManager.primaryColor,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorManager.primaryColor,
            size: 20,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Share functionality
            },
            icon: Icon(
              Icons.share,
              color: ColorManager.primaryColor,
              size: 20,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildStoryImage(),
      ),
    );
  }

  Widget _buildStoryImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.3),
          ],
        ),
      ),
      child: story.imageCover != null && story.imageCover!.isNotEmpty
          ? Image.network(
        '${ApiConstants.urlImage}${story.imageCover}',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
              Icons.auto_stories,
              size: 80,
              color: Colors.white.withOpacity(0.9),
            ),
            const SizedBox(height: 16),
            Text(
              'غلاف القصة',
              style: getBoldStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor.withOpacity(0.1),
            Colors.purple.shade50.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorManager.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_stories,
                  color: ColorManager.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  story.storyTitle ?? 'عنوان القصة',
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 22,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              ),
            ],
          ),
          if (story.createdAt != null) ...[
            const SizedBox(height: 12),
            Row(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'تاريخ الإنشاء: ${_formatDate(story.createdAt!)}',
                  style: getRegularStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              ],
            ),
          ],
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
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
          const SizedBox(height: 16),

          // Image selection area
          selectedImage != null ? _buildSelectedImage() : _buildImageSelector(),

          const SizedBox(height: 16),

          // Checkbox for confirming no image
          _buildNoImageCheckbox(),
        ],
      ),
    );
  }

  Widget _buildImageSelector() {
    return InkWell(
      onTap: onImagePicked,
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
        width: 200,
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
                selectedImage!,
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
                  onPressed: onImageRemoved,
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

  Widget _buildNoImageCheckbox() {
    if (selectedImage != null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: noImageConfirmed
              ? ColorManager.primaryColor.withOpacity(0.5)
              : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        value: noImageConfirmed,
        onChanged: (bool? value) {
          onNoImageChanged(value ?? false);
          HapticFeedback.lightImpact();
        },
        title: Text(
          'متابعة بدون إضافة صورة مفضلة',
          style: getMediumStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        subtitle: Text(
          'يمكنك إضافة الصورة لاحقاً من إعدادات القصة',
          style: getMediumStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        activeColor: ColorManager.primaryColor,
        checkColor: Colors.white,
        controlAffinity: isRTL
            ? ListTileControlAffinity.trailing
            : ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildStoryInfoCards() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (story.ageGroup != null)
          _buildInfoCard(
            icon: Icons.child_care,
            title: 'الفئة العمرية',
            value: story.ageGroup!,
            color: ColorManager.primaryColor,
          ),
        if (story.gender != null)
          _buildInfoCard(
            icon: Icons.person,
            title: 'الجنس',
            value: story.gender!,
            color: Colors.green.shade600,
          ),
        if (story.isActive == true)
          _buildInfoCard(
            icon: Icons.check_circle,
            title: 'الحالة',
            value: 'نشطة',
            color: Colors.blue.shade600,
          ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: getMediumStyle(
                  color: color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: getBoldStyle(
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: getBoldStyle(
        color: ColorManager.primaryColor,
        fontSize: 18,
      ),
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpandableText(
        description: story.storyDescription!,
        isRTL: isRTL,
      ),
    );
  }

  Widget _buildProblemSection() {
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
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.psychology,
                  size: 20,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'تساعد في حل:',
                style: getBoldStyle(
                  color: Colors.orange.shade800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            story.problem!.problemTitle ?? 'مشكلة غير محددة',
            style: getBoldStyle(color: Colors.orange.shade700, fontSize: 18),
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
          if (story.problem!.problemDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              story.problem!.problemDescription!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange.shade600,
                height: 1.4,
              ),
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.category,
                  size: 20,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'تصنيف القصة:',
                style: getBoldStyle(
                  color: Colors.blue.shade800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            story.category!.categoryName ?? 'تصنيف غير محدد',
            style: getBoldStyle(color: Colors.blue.shade700, fontSize: 18),
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          ),
          if (story.category!.categoryDescription != null) ...[
            const SizedBox(height: 8),
            Text(
              story.category!.categoryDescription!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade600,
                height: 1.4,
              ),
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSaving ? null : () => Navigator.of(context).pop(),
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
              onPressed: (isSaving || !canAddStory) ? null : onSaveStory,
              style: ElevatedButton.styleFrom(
                backgroundColor: canAddStory
                    ? ColorManager.primaryColor
                    : Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: canAddStory ? 2 : 0,
              ),
              child: isSaving
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_sharp,
                    color: canAddStory
                        ? Colors.white
                        : Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'إضافة القصة',
                    style: TextStyle(
                      color: canAddStory
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
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _uploadFavoriteImage(BuildContext context) {
    if (selectedImage != null && childId != null) {
      final addImageCubit = context.read<AddKidsFavoriteImageCubit>();
      addImageCubit.image = selectedImage;
      addImageCubit.idChildren = childId!;
      addImageCubit.storyId = story.storyId;
      addImageCubit.addKidsFavoriteImage();
    }
  }

  void _handleSuccessWithoutImage(BuildContext context) {
    Navigator.of(context).pop();
    _showSuccessMessage(context, withImage: false);
  }

  void _showSuccessMessage(
      BuildContext context, {
        bool withImage = false,
        bool imageError = false,
      }) {
    HapticFeedback.lightImpact();
    String message = 'تم حفظ القصة بنجاح!';
    String subtitle = 'تم إضافة القصة إلى مكتبة الطفل';

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
      ),
    );
  }
}