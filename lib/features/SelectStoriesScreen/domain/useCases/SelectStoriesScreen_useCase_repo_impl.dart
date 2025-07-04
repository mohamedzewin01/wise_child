import 'dart:io';

import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/save_story_request/save_story_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/_add_kids_fav_image_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/delete_kid_fav_image_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/save_story_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/stories_by_category_entity.dart';
import '../repositories/SelectStoriesScreen_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/SelectStoriesScreen_useCase_repo.dart';

@Injectable(as: SelectStoriesScreenUseCaseRepo)
class SelectStoriesScreenUseCase implements SelectStoriesScreenUseCaseRepo {
  final SelectStoriesScreenRepository repository;

  SelectStoriesScreenUseCase(this.repository);

  @override
  Future<Result<GetCategoriesStoriesEntity?>> getCategoriesStories() {
    return repository.getCategoriesStories();
  }

  @override
  Future<Result<StoriesByCategoryEntity?>> storiesByCategory({
    int? categoryId,
    int? idChildren,
    int? page,
  }) {
    return repository.storiesByCategory(
      categoryId: categoryId,
      idChildren: idChildren,
      page: page,
    );
  }

  @override
  Future<Result<SaveStoryEntity?>> saveChildrenStories(
    SaveStoryRequest saveStoryRequest,
  ) {
    return repository.saveChildrenStories(saveStoryRequest);
  }

  @override
  Future<Result<AddKidsFavoriteImageEntity?>> addKidsFavoriteImage({
    File? image,
    int? idChildren,
    int? storyId,
  }) {
    return repository.addKidsFavoriteImage(
      image: image,
      idChildren: idChildren,
      storyId: storyId,
    );
  }

  @override
  Future<Result<DeleteKidFavImageEntity?>> deleteKidsFavImage(
      {required int? storyId,required int? idChildren}) {
    return repository.deleteKidsFavImage(storyId, idChildren);
  }
}
