import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_request.g.dart';

@JsonSerializable()
class EditProfileRequest {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "age")
  final int? age;
  @JsonKey(name: "gender")
  final String? gender;


  EditProfileRequest ({
    this.id,
    this.firstName,
    this.lastName,
    this.age,

    this.gender
  });

  factory EditProfileRequest.fromJson(Map<String, dynamic> json) {
    return _$EditProfileRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$EditProfileRequestToJson(this);
  }
}


