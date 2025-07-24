import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/features/AllStoriesByUser/data/models/request/get_user_stories_request.dart';
import 'package:wise_child/features/AllStoriesByUser/data/models/response/user_stories_dto.dart';
import 'package:wise_child/features/Analysis/data/models/request/add_view_story_request.dart';
import 'package:wise_child/features/Analysis/data/models/response/add_view_story_dto.dart';
import 'package:wise_child/features/Auth/singin_singup/data/models/request/get_user_email_request.dart';
import 'package:wise_child/features/Auth/singin_singup/data/models/request/user_model_response.dart';
import 'package:wise_child/features/Auth/singin_singup/data/models/response/users_model.dart';

import 'package:wise_child/features/ChatBotAssistant/data/models/request/get_filtered_questions_request.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/directions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';
import 'package:wise_child/features/ChildDetailsPage/data/models/request/children_details_request.dart';
import 'package:wise_child/features/ChildDetailsPage/data/models/response/children_details_dto.dart';
import 'package:wise_child/features/ChildStories/data/models/request/get_child_stories_request.dart';
import 'package:wise_child/features/ChildStories/data/models/response/get_child_stories_dto.dart';
import 'package:wise_child/features/Children/data/models/request/delete_children_request.dart';
import 'package:wise_child/features/Children/data/models/request/get_children_request.dart';
import 'package:wise_child/features/Children/data/models/response/delete_children_dto.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/EditProfile/data/models/request/edit_profile_request.dart';
import 'package:wise_child/features/EditProfile/data/models/response/edit_profile_dto.dart';
import 'package:wise_child/features/Welcome/data/models/response/app_status_dto.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/data/models/response/add_child_dto.dart';
import 'package:wise_child/features/NewChildren/data/models/response/upload_image.dto.dart';
import 'package:wise_child/features/Reports/data/models/request/reports_request.dart';
import 'package:wise_child/features/Reports/data/models/response/reports_dto.dart';
import 'package:wise_child/features/Reviews/data/models/request/add_child_review_request.dart';
import 'package:wise_child/features/Reviews/data/models/request/get_child_review_request.dart';
import 'package:wise_child/features/Reviews/data/models/response/add_child_review_dto.dart';
import 'package:wise_child/features/Reviews/data/models/response/get_children_review_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/categories_stories_request/get_categories_stories_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/kids_favorite_image_request/delete_kid_fav_image_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/save_story_request/save_story_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/request/stories_by_category_request/stories_by_category_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/kids_favorite_image_dto/add_kids_favorite_image_request.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/categories_stories_dto/get_categories_stories_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/kids_favorite_image_dto/delete_kid_fav_image_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/save_story_dto/save_story_dto.dart';
import 'package:wise_child/features/SelectStoriesScreen/data/models/response/stories_by_category_dto/stories_by_category_dto.dart';
import 'package:wise_child/features/Settings/data/models/request/get_story_requests_replies_request.dart';
import 'package:wise_child/features/Settings/data/models/request/get_user_details_request.dart';
import 'package:wise_child/features/Settings/data/models/response/get_story_requests_replies_dto.dart';
import 'package:wise_child/features/Settings/data/models/response/get_user_details_dto.dart';
import 'package:wise_child/features/Stories/data/models/request/get_children_stories_request.dart';
import 'package:wise_child/features/Stories/data/models/response/children_stories_model_dto.dart';
import 'package:wise_child/features/StoriesPlay/data/models/request/story_play_request.dart';
import 'package:wise_child/features/StoriesPlay/data/models/response/story_play_dto.dart';
import 'package:wise_child/features/StoriesUnderCategory/data/models/request/stories_under_category_request.dart';
import 'package:wise_child/features/StoriesUnderCategory/data/models/response/stories_under_category_dto.dart';
import 'package:wise_child/features/StoryDetails/data/models/request/story_details_request.dart';
import 'package:wise_child/features/StoryDetails/data/models/response/story_details_dto.dart';
import 'package:wise_child/features/StoryInfo/data/models/request/story_info_request.dart';
import 'package:wise_child/features/StoryInfo/data/models/response/story_info_dto.dart';
import 'package:wise_child/features/StoryRequest/data/models/request/add_story_requests_model.dart';
import 'package:wise_child/features/StoryRequest/data/models/request/get_children_request.dart';
import 'package:wise_child/features/StoryRequest/data/models/response/add_story_requests_dto.dart';
import 'package:wise_child/features/StoryRequest/data/models/response/get_children_dto.dart';

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

  @MultiPart()
  @POST(ApiConstants.addKidsFavoriteImage)
  Future<AddKidsFavoriteImageRequest?> addKidsFavoriteImage(
    @Part(name: "image") File? image,
    @Part(name: "id_children") int? idChildren,
    @Part(name: "story_id") int? storyId,
  );

  @POST(ApiConstants.deleteKidsFavoriteImage)
  Future<DeleteKidFavImageDto?> deleteKidsFavoriteImage(
    @Body() DeleteKidFavImageRequest? deleteKidFavImage,
  );

  @POST(ApiConstants.deleteChildren)
  Future<DeleteChildrenDto?> deleteChildren(
    @Body() DeleteChildrenRequest deleteChildrenRequest,
  );

  @POST(ApiConstants.getClipsStory)
  Future<StoryPlayDto?> getClipsStory(
    @Body() StoryPlayRequestModel storyPlayRequestModel,
  );

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

  @POST(ApiConstants.getUserDetails)
  Future<GetUserDetailsDto?> getUserDetails(
    @Body() GetUserDetailsRequest? getUserDetailsRequest,
  );

  @POST(ApiConstants.storyChildrenDetails)
  Future<StoryDetailsDto?> storyChildrenDetails(
    @Body() StoryDetailsRequest? storyDetailsRequest,
  );

  @POST(ApiConstants.storiesView)
  Future<AddViewStoryDto?> addStoryView(
    @Body() AddViewStoryRequest? addViewStoryRequest,
  );

  @POST(ApiConstants.getUserStories)
  Future<UserStoriesDto?> getUserStories(
    @Body() GetUserStoriesRequest? getUserStoriesRequest,
  );

  @POST(ApiConstants.getHomeData)
  Future<GetHomeRequest?> getHomeData();

  @POST(ApiConstants.getChildrenUser)
  Future<GetChildrenUserDto?> getChildrenUser(
    @Body() GetChildrenUserRequest? getChildrenUserRequest,
  );

  @POST(ApiConstants.addStoryRequests)
  Future<AddStoryRequestsDto?> addStoryRequests(
    @Body() AddStoryRequestsModel? addStoryRequestsModel,
  );

  @POST(ApiConstants.childrenViewsReport)
  Future<ReportsDto?> childrenViewsReport(
    @Body() ReportsRequest? reportsRequest,
  );

  @POST(ApiConstants.addChildReview)
  Future<AddChildReviewDto?> addChildReview(
    @Body() AddChildReviewRequest? reportsRequest,
  );

  @POST(ApiConstants.getChildReview)
  Future<GetChildrenReviewDto?> getChildReview(
    @Body() GetChildReviewRequest? getChildReviewRequest,
  );

  @POST(ApiConstants.storyInfo)
  Future<StoryInfoDto?> storyInfo(@Body() StoryInfoRequest? storyInfoRequest);

  @POST(ApiConstants.storiesUnderCategory)
  Future<StoriesUnderCategoryDto?> storiesUnderCategory(
    @Body() StoriesUnderCategoryRequest? storiesUnderCategoryRequest,
  );

  @POST(ApiConstants.getStoryRequestsWithReplies)
  Future<GetStoryRequestsRepliesDto?> getStoryRequestsWithReplies(
    @Body() GetStoryRequestsRepliesRequest? getStoryRequestsRepliesRequest,
  );

  @POST(ApiConstants.appStatus)
  Future<AppStatusDto?> getAppStatus();

  @POST(ApiConstants.getChildStories)
  Future<GetChildStoriesDto?> getChildStories(
      @Body() GetChildStoriesRequest? getChildStoriesRequest,
      );





}

//  @MultiPart()
