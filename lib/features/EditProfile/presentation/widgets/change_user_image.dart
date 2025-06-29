import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wise_child/core/functions/reduce_image_size.dart';
import 'package:wise_child/core/resources/app_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/values_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_dialog.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/l10n/app_localizations.dart';
import 'package:wise_child/features/EditProfile/presentation/bloc/EditProfile_cubit.dart';

class ChangeUserImage extends StatefulWidget {
  const ChangeUserImage({super.key});

  @override
  State<ChangeUserImage> createState() => _ChangeUserImageState();
}

class _ChangeUserImageState extends State<ChangeUserImage> {
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingImage();
  }

  void _loadExistingImage() {
    // Load existing profile image from cache or API
    String? imagePath = CacheService.getData(key: CacheKeys.userPhoto);
    if (imagePath != null && imagePath.isNotEmpty) {
      File imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        setState(() {
          _selectedImage = imageFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfileImageSection(),
        const SizedBox(height: AppSize.s16),
        _buildImageActions(),
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.2),
            blurRadius: AppSize.s20,
            spreadRadius: AppSize.s5,
            offset: const Offset(0, AppSize.s5),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _showImagePicker,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: AppSize.s120,
              width: AppSize.s120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.white,
                border: Border.all(
                  color: ColorManager.primaryColor,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
                    : _buildDefaultAvatar(),
              ),
            ),
            if (_isLoading)
              Container(
                height: AppSize.s120,
                width: AppSize.s120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: AppSize.s36,
                width: AppSize.s36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.primaryColor,
                  border: Border.all(
                    color: ColorManager.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: AppSize.s8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: ColorManager.white,
                  size: AppSize.s18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.primaryColor.withOpacity(0.8),
            ColorManager.primaryColor,
          ],
        ),
      ),
      child: Icon(
        Icons.person,
        size: AppSize.s60,
        color: ColorManager.white,
      ),
    );
  }

  Widget _buildImageActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: _showImagePicker,
          icon: Icon(
            Icons.edit,
            size: AppSize.s16,
            color: ColorManager.primaryColor,
          ),
          label: Text(
            AppLocalizations.of(context)!.changePhoto,
            style: getMediumStyle(
              color: ColorManager.primaryColor,
              fontSize: AppSize.s14,
            ),
          ),
        ),
        if (_selectedImage != null) ...[
          const SizedBox(width: AppSize.s16),
          TextButton.icon(
            onPressed: _removeImage,
            icon: Icon(
              Icons.delete_outline,
              size: AppSize.s16,
              color: ColorManager.error,
            ),
            label: Text(
              AppLocalizations.of(context)!.remove,
              style: getMediumStyle(
                color: ColorManager.error,
                fontSize: AppSize.s14,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.s20),
            topRight: Radius.circular(AppSize.s20),
          ),
        ),
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.s40,
              height: AppSize.s4,
              decoration: BoxDecoration(
                color: ColorManager.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppSize.s2),
              ),
            ),
            const SizedBox(height: AppSize.s20),
            Text(
              AppLocalizations.of(context)!.selectPhoto,
              style: getBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: AppSize.s18,
              ),
            ),
            const SizedBox(height: AppSize.s24),
            Row(
              children: [
                Expanded(
                  child: _buildImageOption(
                    icon: Icons.camera_alt,
                    label: AppLocalizations.of(context)!.camera,
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: AppSize.s16),
                Expanded(
                  child: _buildImageOption(
                    icon: Icons.photo_library,
                    label: AppLocalizations.of(context)!.gallery,
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s16),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p16,
          horizontal: AppPadding.p12,
        ),
        decoration: BoxDecoration(
          color: ColorManager.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSize.s12),
          border: Border.all(
            color: ColorManager.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: ColorManager.primaryColor,
              size: AppSize.s32,
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              label,
              style: getMediumStyle(
                color: ColorManager.primaryColor,
                fontSize: AppSize.s14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop(); // Close bottom sheet

    setState(() {
      _isLoading = true;
    });

    try {
      XFile? xFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (xFile != null) {
        File originalImageFile = File(xFile.path);

        // Compress and resize image
        final File resizedImageFile = await resizeAndCompressImage(
          imageFile: originalImageFile,
        );

        setState(() {
          _selectedImage = resizedImageFile;
        });

        // Save image path to cache
        await CacheService.setData(
          key: CacheKeys.userPhoto,
          value: resizedImageFile.path,
        );

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.imageUpdatedSuccessfully,
              ),
              backgroundColor: ColorManager.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToUpdateImage,
            ),
            backgroundColor: ColorManager.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s8),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.removePhoto,
          style: getBoldStyle(
            color: ColorManager.darkGrey,
            fontSize: AppSize.s18,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.areYouSureRemovePhoto,
          style: getRegularStyle(
            color: ColorManager.grey,
            fontSize: AppSize.s14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: getMediumStyle(
                color: ColorManager.grey,
                fontSize: AppSize.s14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedImage = null;
              });
              // CacheService.removeData(key: CacheKeys.profileImage);
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.imageRemovedSuccessfully,
                  ),
                  backgroundColor: ColorManager.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s8),
                  ),
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.remove,
              style: getMediumStyle(
                color: ColorManager.error,
                fontSize: AppSize.s14,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    );
  }
}