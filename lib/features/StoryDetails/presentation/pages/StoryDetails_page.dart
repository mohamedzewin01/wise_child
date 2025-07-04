import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/di/di.dart';
import 'package:wise_child/features/StoryDetails/presentation/bloc/StoryDetails_cubit.dart';
import 'package:wise_child/features/StoryDetails/data/models/response/story_details_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/save_story_cubit.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/bloc/add_kids_favorite_image_cubit.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_details_content.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_loading_widget.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_error_widget.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_floating_actions.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_snackbar_utils.dart';
import 'package:wise_child/features/StoryDetails/presentation/widgets/story_image_manager.dart';

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
  late StoryImageManager imageManager;
  late KidsFavoriteImageCubit kidsFavoriteImageCubit;

  bool _isSaving = false;
  File? _selectedImage;
  bool _noImageConfirmed = false;
  bool _showDeleteConfirmation = false;

  bool get _canAddStory => _selectedImage != null || _noImageConfirmed;
  bool get _hasChanges => _selectedImage != null || _showDeleteConfirmation;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<StoryDetailsCubit>();
    kidsFavoriteImageCubit = getIt.get<KidsFavoriteImageCubit>();
    imageManager = StoryImageManager(context, kidsFavoriteImageCubit);
    viewModel.getStoryDetails(widget.storyId, widget.childId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: viewModel),
        BlocProvider.value(value: getIt.get<SaveStoryCubit>()),
        BlocProvider.value(value: kidsFavoriteImageCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          // معالجة حالة حذف الصورة
          BlocListener<KidsFavoriteImageCubit, AddKidsFavoriteImageState>(
            listener: (context, state) {
              if (state is DeleteKidsFavoriteImageSuccess) {
                setState(() {
                  _showDeleteConfirmation = false;
                  _isSaving = false;
                });
                StorySnackbarUtils.showSuccess(context, message: 'تم حذف الصورة المفضلة بنجاح');

                _reloadStoryDetails();
              } else if (state is DeleteKidsFavoriteImageFailure) {
                setState(() {
                  _isSaving = false;
                });
                StorySnackbarUtils.showError(context, 'فشل في حذف الصورة المفضلة');
              } else if (state is AddKidsFavoriteImageSuccess) {
                setState(() {
                  _selectedImage = null;
                  _isSaving = false;
                });
                StorySnackbarUtils.showSuccess(context, message: 'تم رفع الصورة بنجاح');

                _reloadStoryDetails();
              } else if (state is AddKidsFavoriteImageFailure) {
                setState(() {
                  _isSaving = false;
                });
                StorySnackbarUtils.showError(context, 'فشل في رفع الصورة');
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: BlocBuilder<StoryDetailsCubit, StoryDetailsState>(
            builder: (context, state) {
              if (state is StoryDetailsLoading) {
                return StoryLoadingWidget(onRetry: _retryLoading);
              } else if (state is StoryDetailsSuccess) {
                return _buildSuccessState(state.storyDetails.story!);
              } else if (state is StoryDetailsFailure) {
                return StoryErrorWidget(onRetry: _retryLoading);
              }
              return StoryLoadingWidget(onRetry: _retryLoading);
            },
          ),
          floatingActionButton: StoryFloatingActions(
            hasChanges: _hasChanges,
            isSaving: _isSaving,
            selectedImage: _selectedImage,
            showDeleteConfirmation: _showDeleteConfirmation,
            onCancel: _cancelChanges,
            onUploadImage: _uploadNewImage,
            onConfirmDelete: () {
              final state = viewModel.state;
              if (state is StoryDetailsSuccess) {
                _confirmDeleteExistingImage(state.storyDetails.story!);
              }
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  void _retryLoading() {
    viewModel.getStoryDetails(widget.storyId, widget.childId);
  }

  void _reloadStoryDetails() {
    // إعادة تحميل تفاصيل القصة
    viewModel.getStoryDetails(widget.storyId, widget.childId);
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
    final image = await imageManager.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _noImageConfirmed = false;
        _showDeleteConfirmation = false;
      });
    }
  }

  void _uploadNewImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isSaving = true;
    });

    final state = viewModel.state;
    if (state is StoryDetailsSuccess) {
      final success = await imageManager.uploadImage(
        image: _selectedImage!,
        childId: widget.childId,
        storyId: state.storyDetails.story!.storyId!,
      );

      if (success) {
        setState(() {
          _selectedImage = null;
        });
        // إعادة تحميل البيانات
        _reloadStoryDetails();
      }
    }

    setState(() {
      _isSaving = false;
    });
  }

  void _deleteExistingImage(StoryDetails story) async {
    await imageManager.showDeleteConfirmationDialog(
      story: story,
      childId: widget.childId,
      onConfirm: () => _confirmDeleteExistingImage(story),
    );
  }

  void _confirmDeleteExistingImage(StoryDetails story) async {
    setState(() {
      _isSaving = true;
    });

    final success = await imageManager.deleteImage(
      story: story,
      childId: widget.childId,
    );

    if (success) {
      setState(() {
        _showDeleteConfirmation = false;
      });
      // إعادة تحميل البيانات
      _reloadStoryDetails();
    }

    setState(() {
      _isSaving = false;
    });
  }

  void _saveStory(StoryDetails story) {
    if (story.storyId == null) {
      StorySnackbarUtils.showError(context, 'معرف القصة غير موجود');
      return;
    }

    if (story.problem?.problemId == null) {
      StorySnackbarUtils.showError(context, 'معرف المشكلة غير موجود');
      return;
    }

    HapticFeedback.lightImpact();

    final saveStoryCubit = context.read<SaveStoryCubit>();
    saveStoryCubit.saveStory(
      storyId: story.storyId!,
      childrenId: widget.childId,
      problemId: story.problem!.problemId!,
    );
  }
}

