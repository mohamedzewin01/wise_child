import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/delete_kid_fav_image_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/useCases/SelectStoriesScreen_useCase_repo.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/_add_kids_fav_image_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/save_story_entity.dart';
part 'add_kids_favorite_image_state.dart';

@injectable
class KidsFavoriteImageCubit extends Cubit<AddKidsFavoriteImageState> {
  KidsFavoriteImageCubit(this._selectStoriesScreenUseCaseRepo)
    : super(AddKidsFavoriteImageInitial());
  final SelectStoriesScreenUseCaseRepo _selectStoriesScreenUseCaseRepo;

  static KidsFavoriteImageCubit get(context) => BlocProvider.of(context);

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

  Future<void> deleteKidsFavoriteImage({required int storyId,required int idChildren}) async {
    print(storyId);
    print(idChildren);
    emit(DeleteKidsFavoriteImageLoading());
    var result = await _selectStoriesScreenUseCaseRepo.deleteKidsFavImage(
      idChildren: idChildren,
      storyId: storyId,

    );
    switch (result) {
      case Success<DeleteKidFavImageEntity?>():
        {
          if (!isClosed) {
            emit(DeleteKidsFavoriteImageSuccess(result.data!));
          }
        }
        break;
      case Fail<DeleteKidFavImageEntity?>():
        {
          if (!isClosed) {
            emit(DeleteKidsFavoriteImageFailure(result.exception));
          }
        }
        break;
    }
  }

}
