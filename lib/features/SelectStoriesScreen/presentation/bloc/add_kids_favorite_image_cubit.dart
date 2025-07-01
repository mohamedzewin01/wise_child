import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/useCases/SelectStoriesScreen_useCase_repo.dart';

part 'add_kids_favorite_image_state.dart';

@injectable
class AddKidsFavoriteImageCubit extends Cubit<AddKidsFavoriteImageState> {
  AddKidsFavoriteImageCubit(this._selectStoriesScreenUseCaseRepo)
    : super(AddKidsFavoriteImageInitial());
  final SelectStoriesScreenUseCaseRepo _selectStoriesScreenUseCaseRepo;

  static AddKidsFavoriteImageCubit get(context) => BlocProvider.of(context);

  File? image;
  int? idChildren;
  int? storyId;

  Future<void> addKidsFavoriteImage() async {
    emit(AddKidsFavoriteImageLoading());
    var result = await _selectStoriesScreenUseCaseRepo.addKidsFavoriteImage(
      idChildren: idChildren,
      storyId: storyId,
      image: image,
    );
    switch (result) {
      case Success<AddKidsFavoriteImageEntity?>():
        {
          if (!isClosed) {
            emit(AddKidsFavoriteImageSuccess(result.data!));
          }
        }
        break;
      case Fail<AddKidsFavoriteImageEntity?>():
        {
          if (!isClosed) {
            emit(AddKidsFavoriteImageFailure(result.exception));
          }
        }
        break;
    }
  }
}
