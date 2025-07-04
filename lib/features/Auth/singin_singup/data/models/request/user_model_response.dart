import 'package:json_annotation/json_annotation.dart';

part 'user_model_response.g.dart';

@JsonSerializable()
class UserModelRequest {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "age")
  final int? age;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "profile_image")
  final String? profileImage;

  UserModelRequest ({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.age,
    this.email,
    this.role,
    this.password,
    this.profileImage,
  });

  factory UserModelRequest.fromJson(Map<String, dynamic> json) {
    return _$UserModelRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserModelRequestToJson(this);
  }
}


