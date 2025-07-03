// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/di/di.dart';
// import '../bloc/StoryDetails_cubit.dart';
//
// class StoryDetailsPage extends StatefulWidget {
//   const StoryDetailsPage({super.key});
//
//   @override
//   State<StoryDetailsPage> createState() => _StoryDetailsPageState();
// }
//
// class _StoryDetailsPageState extends State<StoryDetailsPage> {
//
//   late StoryDetailsCubit viewModel;
//
//   @override
//   void initState() {
//     viewModel = getIt.get<StoryDetailsCubit>();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: viewModel,
//       child: Scaffold(
//         appBar: AppBar(title: const Text('StoryDetails')),
//         body: const Center(child: Text('Hello StoryDetails')),
//       ),
//     );
//   }
// }
//

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

class _StoryDetailsPageState extends State<StoryDetailsPage> {
  late StoryDetailsCubit viewModel;
  bool _isSaving = false;
  File? _selectedImage;
  bool _noImageConfirmed = false;
  final ImagePicker _picker = ImagePicker();

  bool get _canAddStory => _selectedImage != null || _noImageConfirmed;

  @override
  void initState() {
    viewModel = getIt.get<StoryDetailsCubit>();
    viewModel.getStoryDetails(widget.storyId,widget.childId);
    super.initState();
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
              return _buildLoadingState();
            } else if (state is StoryDetailsSuccess) {
              return _buildSuccessState(state.storyDetails.story!);
            } else if (state is StoryDetailsFailure) {
              return _buildErrorState();
            }
            return _buildInitialState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return _StoryDetailsLoadingWidget(
      onBack: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildErrorState() {
    return _StoryDetailsErrorWidget(
      onBack: () => Navigator.of(context).pop(),
      onRetry: () => viewModel.getStoryDetails(widget.storyId,widget.childId),
    );
  }

  Widget _buildInitialState() {
    return _StoryDetailsLoadingWidget(
      onBack: () => Navigator.of(context).pop(),
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
          _noImageConfirmed = false;
        });
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorMessage(context, 'حدث خطأ أثناء اختيار الصورة');
    }
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

  void _uploadFavoriteImage(StoryDetails story) {
    if (_selectedImage != null && widget.childId != null) {
      final addImageCubit = context.read<AddKidsFavoriteImageCubit>();
      addImageCubit.image = _selectedImage;
      addImageCubit.idChildren = widget.childId!;
      addImageCubit.storyId = story.storyId;
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
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          textColor: Colors.white,
          onPressed: () => _saveStory(
            context.read<StoryDetailsCubit>().state is StoryDetailsSuccess
                ? (context.read<StoryDetailsCubit>().state as StoryDetailsSuccess)
                .storyDetails
                .story!
                : StoryDetails(),
          ),
        ),
      ),
    );
  }
}

// Loading Widget
class _StoryDetailsLoadingWidget extends StatelessWidget {
  final VoidCallback onBack;

  const _StoryDetailsLoadingWidget({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorManager.primaryColor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل تفاصيل القصة...',
              style: getMediumStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Error Widget
class _StoryDetailsErrorWidget extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const _StoryDetailsErrorWidget({
    required this.onBack,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorManager.primaryColor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ في تحميل التفاصيل',
              style: getBoldStyle(
                color: Colors.grey.shade700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'يرجى المحاولة مرة أخرى',
              style: getRegularStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'إعادة المحاولة',
                style: getMediumStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}