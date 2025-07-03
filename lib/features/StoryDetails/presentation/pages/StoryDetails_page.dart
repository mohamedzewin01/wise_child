import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/di/di.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/StoryDetails/presentation/bloc/StoryDetails_cubit.dart';
import 'package:wise_child/features/StoryDetails/data/models/response/story_details_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/save_story_cubit.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/add_kids_favorite_image_cubit.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_details_content.dart';

class StoryDetailsPage extends StatefulWidget {
  final int storyId;
  final int childId;
  final bool isRTL;

  const StoryDetailsPage({
    super.key,
    required this.storyId,
    required this.childId,
    this.isRTL = true,
  });

  @override
  State<StoryDetailsPage> createState() => _StoryDetailsPageState();
}

class _StoryDetailsPageState extends State<StoryDetailsPage>
    with TickerProviderStateMixin {
  late StoryDetailsCubit viewModel;
  bool _isSaving = false;
  File? _selectedImage;
  bool _noImageConfirmed = false;
  bool _showDeleteConfirmation = false;
  final ImagePicker _picker = ImagePicker();

  // Animation controllers for improved loading
  late AnimationController _loadingController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  bool get _canAddStory => _selectedImage != null || _noImageConfirmed;
  bool get _hasChanges => _selectedImage != null || _showDeleteConfirmation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    viewModel = getIt.get<StoryDetailsCubit>();
    viewModel.getStoryDetails(widget.storyId, widget.childId);
  }

  void _setupAnimations() {
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _loadingController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: viewModel),
        BlocProvider.value(value: getIt.get<SaveStoryCubit>()),
        BlocProvider.value(value: getIt.get<AddKidsFavoriteImageCubit>()),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: BlocBuilder<StoryDetailsCubit, StoryDetailsState>(
          builder: (context, state) {
            if (state is StoryDetailsLoading) {
              return _buildImprovedLoadingState();
            } else if (state is StoryDetailsSuccess) {
              return _buildSuccessState(state.storyDetails.story!);
            } else if (state is StoryDetailsFailure) {
              return _buildErrorState();
            }
            return _buildImprovedLoadingState();
          },
        ),
        floatingActionButton: _buildFloatingActionButtons(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildImprovedLoadingState() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorManager.primaryColor.withOpacity(0.1),
              Colors.white,
              ColorManager.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Loading Icon
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: ColorManager.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorManager.primaryColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.auto_stories,
                                size: 50,
                                color: ColorManager.primaryColor,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Loading Indicator
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorManager.primaryColor,
                            ),
                            strokeWidth: 3,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Loading Text
                        Text(
                          'جاري تحميل تفاصيل القصة...',
                          style: getBoldStyle(
                            color: ColorManager.primaryColor,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'يرجى الانتظار قليلاً',
                          style: getRegularStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Loading Animation Bars
                        _buildLoadingBars(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: 20 + (10 * (_fadeAnimation.value * (index + 1) / 5)),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor.withOpacity(
                  0.3 + (0.7 * _fadeAnimation.value * (index + 1) / 5),
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.withOpacity(0.1),
              Colors.white,
              Colors.red.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // App Bar
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Error Icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.error_outline,
                            size: 50,
                            color: Colors.red.shade400,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'حدث خطأ في تحميل التفاصيل',
                          style: getBoldStyle(
                            color: Colors.grey.shade700,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
                          style: getRegularStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Retry Button
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton.icon(
                            onPressed: () => viewModel.getStoryDetails(
                              widget.storyId,
                              widget.childId,
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 4,
                            ),
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
      ),
    );
  }

  Widget _buildSuccessState(StoryDetails story) {
    return StoryDetailsContent(
      story: story,
      isRTL: widget.isRTL,
      childId: widget.childId,
      selectedImage: _selectedImage,
      noImageConfirmed: _noImageConfirmed,
      isSaving: _isSaving,
      canAddStory: _canAddStory,
      showDeleteConfirmation: _showDeleteConfirmation,
      onImagePicked: _pickImage,
      onImageRemoved: () {
        setState(() {
          _selectedImage = null;
        });
      },
      onNoImageChanged: (value) {
        setState(() {
          _noImageConfirmed = value;
        });
      },
      onSaveStory: () => _saveStory(story),
      onDeleteExistingImage: () {
        setState(() {
          _showDeleteConfirmation = true;
        });
      },
      onCancelDelete: () {
        setState(() {
          _showDeleteConfirmation = false;
        });
      },
      onConfirmDelete: () {
        setState(() {
          _showDeleteConfirmation = false;
        });
        _deleteExistingImage(story);
      },
    );
  }

  Widget? _buildFloatingActionButtons() {
    if (!_hasChanges) return null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Cancel Button (if there are changes)
          if (_hasChanges)
            FloatingActionButton.extended(
              onPressed: _isSaving ? null : _cancelChanges,
              heroTag: "cancel",
              backgroundColor: Colors.grey.shade600,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.close),
              label: const Text('إلغاء'),
              elevation: 8,
            ),

          // Save/Send Button
          if (_selectedImage != null)
            FloatingActionButton.extended(
              onPressed: _isSaving ? null : () => _uploadNewImage(),
              heroTag: "save_image",
              backgroundColor: ColorManager.primaryColor,
              foregroundColor: Colors.white,
              icon: _isSaving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Icon(Icons.cloud_upload),
              label: Text(_isSaving ? 'جاري الحفظ...' : 'رفع الصورة'),
              elevation: 8,
            ),

          // Confirm Delete Button
          if (_showDeleteConfirmation)
            FloatingActionButton.extended(
              onPressed: _isSaving ? null : () {
                final state = viewModel.state;
                if (state is StoryDetailsSuccess) {
                  _confirmDeleteExistingImage(state.storyDetails.story!);
                }
              },
              heroTag: "confirm_delete",
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: _isSaving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Icon(Icons.delete_forever),
              label: Text(_isSaving ? 'جاري الحذف...' : 'تأكيد الحذف'),
              elevation: 8,
            ),
        ],
      ),
    );
  }

  void _cancelChanges() {
    setState(() {
      _selectedImage = null;
      _showDeleteConfirmation = false;
      _noImageConfirmed = false;
    });
    HapticFeedback.lightImpact();
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
          _noImageConfirmed = false;
          _showDeleteConfirmation = false;
        });
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorMessage(context, 'حدث خطأ أثناء اختيار الصورة');
    }
  }

  void _uploadNewImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final addImageCubit = context.read<AddKidsFavoriteImageCubit>();
      addImageCubit.image = _selectedImage;
      addImageCubit.idChildren = widget.childId;

      final state = viewModel.state;
      if (state is StoryDetailsSuccess) {
        addImageCubit.storyId = state.storyDetails.story!.storyId;
      }

      await addImageCubit.addKidsFavoriteImage();
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      _showErrorMessage(context, 'حدث خطأ أثناء رفع الصورة');
    }
  }

  void _deleteExistingImage(StoryDetails story) {
    setState(() {
      _showDeleteConfirmation = true;
    });
    HapticFeedback.lightImpact();
  }

  void _confirmDeleteExistingImage(StoryDetails story) async {
    setState(() {
      _isSaving = true;
    });

    // هنا يمكنك إضافة منطق حذف الصورة من الخادم
    // مثال:
    // final deleteImageCubit = context.read<DeleteFavoriteImageCubit>();
    // await deleteImageCubit.deleteImage(story.favoriteImage!.idFavoriteImage!);

    // محاكاة عملية الحذف
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSaving = false;
      _showDeleteConfirmation = false;
    });

    _showSuccessMessage(context, message: 'تم حذف الصورة بنجاح');

    // إعادة تحميل البيانات
    viewModel.getStoryDetails(widget.storyId, widget.childId);
  }

  void _saveStory(StoryDetails story) {
    if (widget.childId == null) {
      _showErrorMessage(context, 'معرف الطفل غير موجود');
      return;
    }

    if (story.storyId == null) {
      _showErrorMessage(context, 'معرف القصة غير موجود');
      return;
    }

    if (story.problem?.problemId == null) {
      _showErrorMessage(context, 'معرف المشكلة غير موجود');
      return;
    }

    HapticFeedback.lightImpact();

    final saveStoryCubit = context.read<SaveStoryCubit>();
    saveStoryCubit.saveStory(
      storyId: story.storyId!,
      childrenId: widget.childId!,
      problemId: story.problem!.problemId!,
    );
  }

  void _showSuccessMessage(BuildContext context, {
    String? message,
    bool withImage = false,
    bool imageError = false,
  }) {
    HapticFeedback.lightImpact();
    String finalMessage = message ?? 'تم بنجاح!';
    String subtitle = 'العملية تمت بنجاح';

    if (withImage) {
      finalMessage = 'تم حفظ القصة والصورة بنجاح!';
      subtitle = 'ستظهر الصورة المفضلة داخل القصة';
    } else if (imageError) {
      finalMessage = 'تم حفظ القصة بنجاح!';
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
                    finalMessage,
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
                    'حدث خطأ',
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