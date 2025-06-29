// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:injectable/injectable.dart';
// import 'package:wise_child/core/common/api_result.dart';
// import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
// import 'package:wise_child/features/EditProfile/data/models/request/edit_profile_request.dart';
// import 'package:wise_child/features/EditProfile/domain/entities/edit_profile_entities.dart';
// import '../../domain/useCases/EditProfile_useCase_repo.dart';
//
// part 'EditProfile_state.dart';
//
// @injectable
// class EditProfileCubit extends Cubit<EditProfileState> {
//   EditProfileCubit(this._editProfileUseCaseRepo) : super(EditProfileInitial());
//   final EditProfileUseCaseRepo _editProfileUseCaseRepo;
//
//
//   Future<void> editProfile({
//     required String firstName,
//     required String lastName,
//     String? gender,
//
//     required String phone,
//     required int age,
//     required String password,
//     required String confirmPassword,
//   }) async {
//       emit(EditProfileLoading());
//       String? userId = CacheService.getData(key: CacheKeys.userId);
//       EditProfileRequest editProfileRequest = EditProfileRequest(
//        firstName: firstName,
//           lastName:lastName,
//         id: userId,
//         age: age,
//         password:password ,
//         gender: gender
//       );
//    var result =   await _editProfileUseCaseRepo.editProfile(
//           editProfileRequest
//       );
//
//    switch (result) {
//      case Success<EditProfileEntity?>():
//        {
//          if (!isClosed) {
//            emit(EditProfileSuccess(result.data!));
//          }
//        }
//        break;
//      case Fail<EditProfileEntity?>():
//        {
//          if (!isClosed) {
//            emit(EditProfileFailure(result.exception));
//          }
//        }
//        break;
//
//    }
//
//   }
// }

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/EditProfile/data/models/request/edit_profile_request.dart';
import 'package:wise_child/features/EditProfile/domain/entities/edit_profile_entities.dart';
import '../../domain/useCases/EditProfile_useCase_repo.dart';

part 'EditProfile_state.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._editProfileUseCaseRepo) : super(EditProfileInitial());
  final EditProfileUseCaseRepo _editProfileUseCaseRepo;


  File? profileImage;
  // Method to load current user data
  void loadUserData() {
    emit(EditProfileLoading());

    try {
      // Simulate loading user data from cache or API
      final userData = EditProfileEntity(
        status: 'success',
        message: 'User data loaded successfully',
        updatedAt: DateTime.now().toIso8601String(),
      );

      emit(EditProfileDataLoaded(userData));
    } catch (e) {
      emit(EditProfileFailure(Exception('Failed to load user data: $e')));
    }
  }

  Future<void> editProfile({
    required String firstName,
    required String lastName,
    String? gender,
    required String phone,
    required int age,

  }) async {
    try {
      // Validate input data
      final validationResult = _validateInput(
        firstName: firstName,
        lastName: lastName,
        // gender: gender,
        phone: phone,
        age: age,


      );

      if (validationResult != null) {
        emit(EditProfileFailure(Exception(validationResult)));
        return;
      }

      emit(EditProfileLoading());

      String? userId = CacheService.getData(key: CacheKeys.userId);

      if (userId == null || userId.isEmpty) {
        emit(EditProfileFailure(Exception('User ID not found. Please login again.')));
        return;
      }

      EditProfileRequest editProfileRequest = EditProfileRequest(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        id: userId,
        age: age,

        gender: gender,
      );

      var result = await _editProfileUseCaseRepo.editProfile(editProfileRequest);

      switch (result) {
        case Success<EditProfileEntity?>():
          {
            if (!isClosed) {
              // Update cached user data
              await _updateCachedUserData(
                firstName: firstName,
                lastName: lastName,
                gender: gender,
                phone: phone,
                age: age,
              );

              emit(EditProfileSuccess(result.data!));
            }
          }
          break;
        case Fail<EditProfileEntity?>():
          {
            if (!isClosed) {
              emit(EditProfileFailure(result.exception));
            }
          }
          break;
      }
    } catch (e) {
      if (!isClosed) {
        emit(EditProfileFailure(Exception('Unexpected error occurred: $e')));
      }
    }
  }

  String? _validateInput({
    required String firstName,
    required String lastName,
    String? gender,
    required String phone,
    required int age,


  }) {
    // Validate first name
    if (firstName.trim().isEmpty) {
      return 'First name is required';
    }
    if (firstName.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }

    // Validate last name
    if (lastName.trim().isEmpty) {
      return 'Last name is required';
    }
    if (lastName.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }



    // Validate phone number
    // if (phone.trim().isEmpty) {
    //   return 'Phone number is required';
    // }
    // if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone.trim())) {
    //   return 'Please enter a valid phone number';
    // }

    // Validate age
    if (age < 18 ) {
      return 'Please enter a valid age between 18 and 120';
    }



    return null; // No validation errors
  }

  Future<void> _updateCachedUserData({
    required String firstName,
    required String lastName,
    String? gender,
    required String phone,
    required int age,
  }) async {
    try {
      await CacheService.setData(key: CacheKeys.userFirstName, value: firstName);
      await CacheService.setData(key: CacheKeys.userLastName, value: lastName);
      // await CacheService.setData(key: CacheKeys.phone, value: phone);
      await CacheService.setData(key: CacheKeys.userAge, value: age.toString());
      if (gender != null) {
        await CacheService.setData(key: CacheKeys.userGender, value: gender);
      }
    } catch (e) {
      // Log error but don't fail the entire operation
      print('Error updating cached user data: $e');
    }
  }

  // Method to reset the state
  void resetState() {
    emit(EditProfileInitial());
  }

  // Method to check if profile data has been changed
  bool hasDataChanged({
    required String firstName,
    required String lastName,
    String? gender,
    required String phone,
    required int age,
  }) {
    final cachedFirstName = CacheService.getData(key: CacheKeys.userFirstName) ?? '';
    final cachedLastName = CacheService.getData(key: CacheKeys.userLastName) ?? '';
    // final cachedPhone = CacheService.getData(key: CacheKeys.phone) ?? '';
    final cachedAge = int.tryParse(CacheService.getData(key: CacheKeys.userAge) ?? '0') ?? 0;
    final cachedGender = CacheService.getData(key: CacheKeys.userGender);

    return firstName.trim() != cachedFirstName ||
        lastName.trim() != cachedLastName ||
        // phone.trim() != cachedPhone ||
        age != cachedAge ||
        gender != cachedGender;
  }
}