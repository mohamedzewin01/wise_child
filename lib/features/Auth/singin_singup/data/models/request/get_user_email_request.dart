import 'package:json_annotation/json_annotation.dart';

part 'get_user_email_request.g.dart';

@JsonSerializable()
class GetUserByEmailRequest {
  @JsonKey(name: "email")
  final String? email;

  GetUserByEmailRequest ({
    this.email,
  });

  factory GetUserByEmailRequest.fromJson(Map<String, dynamic> json) {
    return _$GetUserByEmailRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetUserByEmailRequestToJson(this);
  }
}


