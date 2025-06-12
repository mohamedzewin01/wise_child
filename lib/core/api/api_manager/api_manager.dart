import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/features/AddChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/AddChildren/data/models/response/add_child_dto.dart';
import 'package:wise_child/features/Auth/data/models/request/get_user_email_request.dart';
import 'package:wise_child/features/Auth/data/models/request/user_model_response.dart';
import 'package:wise_child/features/Auth/data/models/response/users_model.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/request/get_filtered_questions_request.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/directions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';
import 'package:wise_child/features/Children/data/models/request/get_children_request.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';

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


  @POST(ApiConstants.newChild)
  Future<AddChildDto?> addChild(
    @Body() AddChildRequest addChildRequest,
  );
}

//  @MultiPart()
