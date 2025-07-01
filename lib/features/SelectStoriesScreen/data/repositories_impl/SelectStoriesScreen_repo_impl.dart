import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/datasources/SelectStoriesScreen_datasource_repo.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/save_story_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/domain/entities/select_stories_entity.dart';
import '../../domain/repositories/SelectStoriesScreen_repository.dart';

@Injectable(as: SelectStoriesScreenRepository)
class SelectStoriesScreenRepositoryImpl
    implements SelectStoriesScreenRepository {
  final SelectStoriesScreenDatasourceRepo selectStoriesScreenDatasourceRepo;

  SelectStoriesScreenRepositoryImpl(this.selectStoriesScreenDatasourceRepo);

  @override
  Future<Result<GetCategoriesStoriesEntity?>> getCategoriesStories() {
    return selectStoriesScreenDatasourceRepo.getCategoriesStories();
  }

  @override
  Future<Result<StoriesByCategoryEntity?>> storiesByCategory({
    int? categoryId,
    int? idChildren,
    int? page,
  }) {
    return selectStoriesScreenDatasourceRepo.storiesByCategory(
      categoryId: categoryId,
      idChildren: idChildren,
      page: page,
    );
  }

  @override
  Future<Result<SaveStoryEntity?>> saveChildrenStories(
      SaveStoryRequest saveStoryRequest) {
    return selectStoriesScreenDatasourceRepo.saveChildrenStories(
        saveStoryRequest);
  }

  @override
  Future<Result<AddKidsFavoriteImageEntity?>> addKidsFavoriteImage(
      {File? image, int? idChildren, int? storyId}) {
    return selectStoriesScreenDatasourceRepo.addKidsFavoriteImage(
        image: image, idChildren: idChildren, storyId: storyId);

  }

// implementation
}
