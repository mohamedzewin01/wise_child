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
import 'package:wise_child/features/StoryDetails/presentation/widgets/category_section.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/favorite_image_section.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/problem_section.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_info_section.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_title_section.dart';

class StoryDetailsContent extends StatefulWidget {
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
    super.key,
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
                        FavoriteImageSection(
                          story: widget.story,
                          isRTL: widget.isRTL,
                          hasExistingImage: _hasExistingFavoriteImage,
                          selectedImage: widget.selectedImage,
                          onImagePicked: widget.onImagePicked,
                          onImageRemoved: widget.onImageRemoved,
                        ),
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
    ];
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
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
      final addImageCubit = context.read<AddKidsFavoriteImageCubit>();
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
            Colors.black.withOpacity(0.3),
          ],
        ),
      ),
      child: story.imageCover != null && story.imageCover!.isNotEmpty
          ? Hero(
        tag: 'story_image_${story.storyId}',
        child: Image.network(
          '${ApiConstants.urlImage}${story.imageCover}',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(),
        ),
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