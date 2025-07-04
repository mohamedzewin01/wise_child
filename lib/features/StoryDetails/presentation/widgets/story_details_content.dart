import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoryDetails/data/models/response/story_details_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/save_story_cubit.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/add_kids_favorite_image_cubit.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/category_section.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/problem_section.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_info_section.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_title_section.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_description_section.dart';

class StoryDetailsContent extends StatefulWidget {
  final StoryDetails story;
  final bool isRTL;
  final int? childId;
  final File? selectedImage;
  final bool noImageConfirmed;
  final bool isSaving;
  final bool canAddStory;
  final bool showDeleteConfirmation;
  final VoidCallback onImagePicked;
  final VoidCallback onImageRemoved;
  final ValueChanged<bool> onNoImageChanged;
  final VoidCallback onSaveStory;
  final VoidCallback onDeleteExistingImage;
  final VoidCallback onCancelDelete;
  final VoidCallback onConfirmDelete;

  const StoryDetailsContent({
    super.key,
    required this.story,
    required this.isRTL,
    required this.childId,
    required this.selectedImage,
    required this.noImageConfirmed,
    required this.isSaving,
    required this.canAddStory,
    required this.showDeleteConfirmation,
    required this.onImagePicked,
    required this.onImageRemoved,
    required this.onNoImageChanged,
    required this.onSaveStory,
    required this.onDeleteExistingImage,
    required this.onCancelDelete,
    required this.onConfirmDelete,
  });

  @override
  State<StoryDetailsContent> createState() => _StoryDetailsContentState();
}

class _StoryDetailsContentState extends State<StoryDetailsContent>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool get _hasExistingFavoriteImage =>
      widget.story.favoriteImage?.imageUrl != null &&
          widget.story.favoriteImage!.imageUrl!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: _buildBlocListeners(),
      child: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StoryTitleSection(
                        story: widget.story,
                        isRTL: widget.isRTL,
                      ),
                      const SizedBox(height: 20),

                      if (widget.childId != null) ...[
                        _buildImprovedFavoriteImageSection(),
                        const SizedBox(height: 24),
                      ],

                      StoryInfoSection(story: widget.story),
                      const SizedBox(height: 24),

                      if (widget.story.storyDescription != null) ...[
                        StoryDescriptionSection(
                          story: widget.story,
                          isRTL: widget.isRTL,
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (widget.story.problem != null) ...[
                        ProblemSection(
                          problem: widget.story.problem!,
                          isRTL: widget.isRTL,
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (widget.story.category != null) ...[
                        CategorySection(
                          category: widget.story.category!,
                          isRTL: widget.isRTL,
                        ),
                        const SizedBox(height: 100), // Extra space for FAB
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovedFavoriteImageSection() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorManager.primaryColor.withOpacity(0.08),
                    Colors.purple.shade50.withOpacity(0.4),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorManager.primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(),
                  const SizedBox(height: 16),
                  _buildSectionDescription(),
                  const SizedBox(height: 20),
                  _buildImageContent(),
                  if (widget.showDeleteConfirmation) ...[
                    const SizedBox(height: 16),
                    _buildDeleteConfirmationWidget(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorManager.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.favorite,
            size: 24,
            color: ColorManager.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _hasExistingFavoriteImage
                    ? 'الصورة المفضلة للطفل'
                    : 'أضف صورة مفضلة للطفل',
                style: getBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 18,
                ),
                textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
              if (_hasExistingFavoriteImage)
                Text(
                  'يمكنك تغيير الصورة أو حذفها',
                  style: getRegularStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
            ],
          ),
        ),
        if (_hasExistingFavoriteImage && !widget.showDeleteConfirmation)
          _buildEditButton(),
      ],
    );
  }

  Widget _buildEditButton() {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ColorManager.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Icon(
          Icons.more_vert,
          size: 20,
          color: ColorManager.primaryColor,
        ),
      ),
      onSelected: (String value) {
        if (value == 'change') {
          widget.onImagePicked();
        } else if (value == 'delete') {
          widget.onDeleteExistingImage();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'change',
          child: Row(
            children: [
              Icon(Icons.photo_camera, color: ColorManager.primaryColor, size: 18),
              const SizedBox(width: 8),
              const Text('تغيير الصورة'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red.shade600, size: 18),
              const SizedBox(width: 8),
              Text('حذف الصورة', style: TextStyle(color: Colors.red.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Text(
        _hasExistingFavoriteImage
            ? widget.showDeleteConfirmation
            ? 'هل أنت متأكد من حذف الصورة المفضلة؟ لن تتمكن من استرجاعها بعد الحذف.'
            : 'هذه هي الصورة المفضلة الحالية للطفل. يمكنك تغييرها أو حذفها من خلال القائمة أعلاه.'
            : 'اختر صورة للعبة المفضلة لطفلك أو المكان الذي يحب اللعب فيه. ستظهر هذه الصورة داخل القصة لجعلها أكثر تشويقاً وقرباً منه! 📸✨',
        style: TextStyle(
          fontSize: 14,
          color: widget.showDeleteConfirmation
              ? Colors.red.shade700
              : Colors.grey.shade700,
          height: 1.5,
          fontWeight: widget.showDeleteConfirmation
              ? FontWeight.w600
              : FontWeight.normal,
        ),
        textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
      ),
    );
  }

  Widget _buildImageContent() {
    if (widget.selectedImage != null) {
      return _buildSelectedImage();
    } else if (_hasExistingFavoriteImage && !widget.showDeleteConfirmation) {
      return _buildExistingImage();
    } else if (widget.showDeleteConfirmation) {
      return _buildExistingImageWithDeleteOverlay();
    } else {
      return _buildImageSelector();
    }
  }

  Widget _buildExistingImage() {
    return Center(
      child: Hero(
        tag: 'favorite_image_${widget.story.favoriteImage?.idFavoriteImage}',
        child: Container(
          height: 280,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorManager.primaryColor.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  '${ApiConstants.urlImage}${widget.story.favoriteImage!.imageUrl}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildImageLoadingPlaceholder();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImageErrorPlaceholder();
                  },
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'الصورة المفضلة الحالية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
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
      ),
    );
  }

  Widget _buildExistingImageWithDeleteOverlay() {
    return Center(
      child: Container(
        height: 280,
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.red.withOpacity(0.3),
                  BlendMode.multiply,
                ),
                child: Image.network(
                  '${ApiConstants.urlImage}${widget.story.favoriteImage!.imageUrl}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImageErrorPlaceholder();
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'سيتم حذف هذه الصورة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSelectedImage() {
    return Center(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.9 + (0.1 * value),
            child: Opacity(
              opacity: value,
              child: Container(
                height: 280,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        widget.selectedImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: widget.onImageRemoved,
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_camera, color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'صورة جديدة محددة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSelector() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: InkWell(
              onTap: widget.onImagePicked,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ColorManager.primaryColor.withOpacity(0.4),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.primaryColor.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, iconValue, child) {
                        return Transform.scale(
                          scale: 0.8 + (0.2 * iconValue),
                          child: Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 48,
                            color: ColorManager.primaryColor.withOpacity(0.7 * iconValue),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'اضغط لاختيار صورة',
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorManager.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(اختياري)',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeleteConfirmationWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red.shade600,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'تأكد من رغبتك في حذف الصورة. هذا الإجراء لا يمكن التراجع عنه.',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل الصورة...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'فشل في تحميل الصورة',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // إعادة تحميل الصورة
                setState(() {});
              },
              child: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BlocListener> _buildBlocListeners() {
    return [
      BlocListener<SaveStoryCubit, SaveStoryState>(
        listener: (context, state) {
          if (state is SaveStorySuccess) {
            if (widget.selectedImage != null) {
              _uploadFavoriteImage(context);
            } else {
              _handleSuccessWithoutImage(context);
            }
          } else if (state is SaveStoryFailure) {
            Navigator.of(context).pop();
            _showErrorMessage(context, 'القصة مضافة بالفعل أو حدث خطأ');
          }
        },
      ),
      BlocListener<KidsFavoriteImageCubit, AddKidsFavoriteImageState>(
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
    ];
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: ColorManager.primaryColor,
      leading: _AppBarButton(
        icon: Icons.arrow_back_ios,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        _AppBarButton(
          icon: Icons.share,
          onPressed: () {
            HapticFeedback.lightImpact();
            // Share functionality
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _StoryImageWidget(story: widget.story),
      ),
    );
  }

  void _uploadFavoriteImage(BuildContext context) {
    if (widget.selectedImage != null && widget.childId != null) {
      final addImageCubit = context.read<KidsFavoriteImageCubit>();
      addImageCubit.image = widget.selectedImage;
      addImageCubit.idChildren = widget.childId!;
      addImageCubit.storyId = widget.story.storyId;
      addImageCubit.addKidsFavoriteImage();
    }
  }

  void _handleSuccessWithoutImage(BuildContext context) {
    Navigator.of(context).pop();
    _showSuccessMessage(context, withImage: false);
  }

  void _showSuccessMessage(BuildContext context, {
    bool withImage = false,
    bool imageError = false,
  }) {
    HapticFeedback.lightImpact();
    String message = 'تم إضافة القصة بنجاح!';
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
                    'لا يمكن إضافة القصة',
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

// AppBar Button Component
class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AppBarButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: ColorManager.primaryColor,
          size: 20,
        ),
      ),
    );
  }
}

// Story Image Widget
class _StoryImageWidget extends StatelessWidget {
  final StoryDetails story;

  const _StoryImageWidget({required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.4),
          ],
        ),
      ),
      child: story.imageCover != null && story.imageCover!.isNotEmpty
          ? Hero(
        tag: 'story_image_${story.storyId}',
        child: Image.network(
          '${ApiConstants.urlImage}${story.imageCover}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildImageLoadingWidget();
          },
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(),
        ),
      )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildImageLoadingWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor.withOpacity(0.3),
            ColorManager.primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل صورة القصة...',
              style: getBoldStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
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
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Icon(
                    Icons.auto_stories,
                    size: 80,
                    color: Colors.white.withOpacity(0.9 * value),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    'غلاف القصة',
                    style: getBoldStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}