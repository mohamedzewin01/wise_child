import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/story_request_entities.dart';

part 'get_children_dto.g.dart';

@JsonSerializable()
class GetChildrenUserDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "children")
  final List<UserChildren>? children;

  GetChildrenUserDto ({
    this.status,
    this.message,
    this.children,
  });

  factory GetChildrenUserDto.fromJson(Map<String, dynamic> json) {
    return _$GetChildrenUserDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildrenUserDtoToJson(this);
  }
  GetUserChildrenEntity toEntity() {
    return GetUserChildrenEntity(
      status: status,
      message: message,
      children: children,
    );
  }
}

@JsonSerializable()
class UserChildren {
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "date_of_birth")
  final String? dateOfBirth;
  @JsonKey(name: "imageUrl")
  final dynamic? imageUrl;

  UserChildren ({
    this.idChildren,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.imageUrl,
  });

  factory UserChildren.fromJson(Map<String, dynamic> json) {
    return _$UserChildrenFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserChildrenToJson(this);
  }
}


