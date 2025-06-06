import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/features/Auth/data/models/request/get_user_email_request.dart';
import 'package:wise_child/features/Auth/data/models/request/user_model_response.dart';
import 'package:wise_child/features/Auth/data/models/response/users_model.dart';

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
  Future<UsersModelDto?> signUpWithGoogle(@Body() UserModelRequest userModelRequest);
  @POST(ApiConstants.getUserByEmail)
  Future<UsersModelDto?> getUserByEmail(@Body() GetUserByEmailRequest getUserByEmailRequest);


}

//  @MultiPart()
