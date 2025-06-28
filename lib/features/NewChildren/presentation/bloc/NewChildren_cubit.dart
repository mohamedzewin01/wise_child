import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/domain/entities/add_entity.dart';
import 'package:wise_child/features/NewChildren/domain/entities/upload_image_entity.dart';
import '../../domain/useCases/NewChildren_useCase_repo.dart';

part 'NewChildren_state.dart';

@injectable
class NewChildrenCubit extends Cubit<NewChildrenState> {
  NewChildrenCubit(this._newChildrenUseCaseRepo) : super(NewChildrenInitial());
  final NewChildrenUseCaseRepo _newChildrenUseCaseRepo;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String? birthDate;
  String? gender='Male';
  List<Siblings> siblings = [];
  List<Friends> friends = [];
  List<BestPlaymate> bestPlaymates = [];
  File? profileImage;

  Future<void> saveChild() async {
    emit(NewChildrenLoading());
    final result = await _newChildrenUseCaseRepo.addChild(
      AddNewChildRequest(
        userId: CacheService.getData(key: CacheKeys.userId),
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        dateOfBirth: birthDate,
        gender: gender,
        siblings: siblings,
        friends: friends,
        bestPlaymate: bestPlaymates,
      ),
    );
    switch (result) {
      case Success<AddChildEntity?>():
        {
          if (!isClosed) {
            emit(NewChildrenSuccess(result.data!));
            final childId = result.data!.childId;

            if (profileImage != null) {
              await updateImage(childId??'');
            }
          }
        }
        break;
      case Fail<AddChildEntity?>():
        {
          if (!isClosed) {
            emit(NewChildrenFailure(result.exception));
          }
        }
        break;
    }
  }

  void updateBirthDate(String date) {
    birthDate = date;
    emit(UpdateBirthDate());
  }

  void changeImage(File image) {
    profileImage = image;
    emit(UpdateImage());
  }

  Future<void> updateImage(String id) async{
    emit(UploadImageLoading());
    final result =await _newChildrenUseCaseRepo.uploadImage(profileImage!,id);
    switch (result) {
      case Success<UploadImageEntity?>():
        {
          if (!isClosed) {
            emit(UploadImageSuccess(result.data!));
          }
        }
        break;
      case Fail<UploadImageEntity?>():
        {
          if (!isClosed) {
            emit(UploadImageFailure(result.exception));
          }
        }
        break;
    }

  }


}
