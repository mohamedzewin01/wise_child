import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Auth/singin_singup/domain/entities/user_entity.dart';


part 'users_model.g.dart';

@JsonSerializable()
class UsersModelDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "user")
  final NewUser? user;

  UsersModelDto({this.status, this.message, this.user});

  factory UsersModelDto.fromJson(Map<String, dynamic> json) {
    return _$UsersModelDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UsersModelDtoToJson(this);
  }

  UserSignUpEntity toUserSignInEntity() {
    return UserSignUpEntity(user: user, status: status, message: message);
  }
}

@JsonSerializable()
class NewUser {
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
  @JsonKey(name: "profile_image")
  final String? profileImage;
  @JsonKey(name: "created_at")
  final String? createdAt;

  NewUser(
    this.firstName,
    this.lastName,
    this.email,
    this.id,
    this.gender,
    this.age,
    this.role,
    this.profileImage,
    this.createdAt,
  );

  factory NewUser.fromJson(Map<String, dynamic> json) {
    return _$NewUserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$NewUserToJson(this);
  }
}
