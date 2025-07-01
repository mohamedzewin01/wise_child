import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/features/Auth/data/models/request/get_user_email_request.dart';
import 'package:wise_child/features/Auth/data/models/request/user_model_response.dart';
import 'package:wise_child/features/Auth/data/models/response/users_model.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/request/get_filtered_questions_request.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/directions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';
import 'package:wise_child/features/ChildDetailsPage/data/models/request/children_details_request.dart';
import 'package:wise_child/features/ChildDetailsPage/data/models/response/children_details_dto.dart';
import 'package:wise_child/features/Children/data/models/request/delete_children_request.dart';
import 'package:wise_child/features/Children/data/models/request/get_children_request.dart';
import 'package:wise_child/features/Children/data/models/response/delete_children_dto.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/EditProfile/data/models/request/edit_profile_request.dart';
import 'package:wise_child/features/EditProfile/data/models/response/edit_profile_dto.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/data/models/response/add_child_dto.dart';
import 'package:wise_child/features/NewChildren/data/models/response/upload_image.dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/get_categories_stories_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/save_story_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/stories_by_category_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/get_categories_stories_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/save_story_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto.dart';
import 'package:wise_child/features/Stories/data/models/request/get_children_stories_request.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
import 'package:wise_child/features/StoriesPlay/data/models/request/story_play_request.dart';
import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';

part 'api_manager.g.dart';

@injectable
@singleton
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiService {
  @FactoryMethod()
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.signUp)
  Future<UsersModelDto?> signUp(@Body() UserModelRequest userModelRequest);

  @POST(ApiConstants.singWithGoogle)
  Future<UsersModelDto?> signUpWithGoogle(
    @Body() UserModelRequest userModelRequest,
  );

  @POST(ApiConstants.getUserByEmail)
  Future<UsersModelDto?> getUserByEmail(
    @Body() GetUserByEmailRequest getUserByEmailRequest,
  );

  @POST(ApiConstants.getDirections)
  Future<DirectionsDto?> getDirections();

  @POST(ApiConstants.getQuestionByDirection)
  Future<QuestionsDto?> getQuestionByDirection(
    @Body() GetFilteredQuestionsRequest getFilteredQuestionsRequest,
  );

  @POST(ApiConstants.getQuestions)
  Future<QuestionsDto?> getQuestions();

  @POST(ApiConstants.getChildrenByUser)
  Future<GetChildrenDto?> getChildrenByUser(
    @Body() GetChildrenRequest getChildrenRequest,
  );

  //
  // @POST(ApiConstants.newChild)
  // Future<AddChildDto?> addChild(@Body() AddNewChildRequest addChildRequest);

  @POST(ApiConstants.addChild)
  Future<AddChildDto?> addChild(@Body() AddNewChildRequest addChildRequest);

  @MultiPart()
  @POST(ApiConstants.imageChild)
  Future<UploadImageDto?> uploadImage(
    @Part(name: "image") File? image,
    @Part(name: "id_children") String? idChildren,
  );

  @POST(ApiConstants.deleteChildren)
  Future<DeleteChildrenDto?> deleteChildren(
    @Body() DeleteChildrenRequest deleteChildrenRequest,
  );

  @POST(ApiConstants.getClipsStory)
  Future<StoryPlayDto?> getClipsStory(
    @Body() StoryPlayRequestModel storyPlayRequestModel,
  );

  // @POST(ApiConstants.getChildrenStories)
  // Future<GetChildrenStoriesDto?> getChildrenStories(
  //     @Part(name: "childrenId") String? idChildren
  //     );

  @POST(ApiConstants.getChildrenStories3)
  Future<ChildrenStoriesModelDto?> getChildrenStories(
    @Body() GetChildrenStoriesRequest? getChildrenStoriesRequest,
  );

  @POST(ApiConstants.editProfile)
  Future<EditProfileDto?> editProfile(
    @Body() EditProfileRequest? editProfileRequest,
  );

  @POST(ApiConstants.getStoryCategories)
  Future<GetCategoriesStoriesDto?> getCategoriesStories(
    @Body() GetCategoriesStoriesRequest? getCategoriesStoriesRequest,
  );
  @POST(ApiConstants.storiesByCategory)
  Future<StoriesByCategoryDto?> storiesByCategory(
    @Body() StoriesByCategoryRequest? storiesByCategoryRequest,
  );

  @POST(ApiConstants.saveChildStory)
  Future<SaveStoryDto?> saveChildStory(
    @Body() SaveStoryRequest? saveStoryRequest,
  );
  @POST(ApiConstants.childrenDetails)
  Future<ChildrenDetailsDto?> childrenDetails(
    @Body() ChildrenDetailsRequest? childrenDetailsRequest,
  );


}

//  @MultiPart()
