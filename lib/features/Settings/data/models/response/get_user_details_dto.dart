import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Settings/domain/entities/user_entity.dart';

part 'get_user_details_dto.g.dart';

@JsonSerializable()
class GetUserDetailsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "user")
  final UserDetail? user;

  GetUserDetailsDto ({
    this.status,
    this.user,
  });

  factory GetUserDetailsDto.fromJson(Map<String, dynamic> json) {
    return _$GetUserDetailsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetUserDetailsDtoToJson(this);
  }
  GetUserDetailsEntity toEntity() {
    return GetUserDetailsEntity(
      status: status,
      user: user,
    );
  }
}

@JsonSerializable()
class UserDetail {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "profile_image")
  final String? profileImage;
  @JsonKey(name: "children")
  final List<UserChildren>? children;

  UserDetail ({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.profileImage,
    this.children,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return _$UserDetailFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserDetailToJson(this);
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
  final String? imageUrl;

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


