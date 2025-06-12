import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Children/domain/entities/children_entity.dart';

part 'get_children_dto.g.dart';

@JsonSerializable()
class GetChildrenDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "children")
  final List<Children>? children;

  GetChildrenDto ({
    this.status,
    this.children,
  });

  factory GetChildrenDto.fromJson(Map<String, dynamic> json) {
    return _$GetChildrenDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetChildrenDtoToJson(this);
  }
  GetChildrenEntity toEntity() {
    return GetChildrenEntity(
      status: status,
      children: children,
    );
  }
}

@JsonSerializable()
class Children {
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
  @JsonKey(name: "email_children")
  final dynamic? emailChildren;
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "siblings_count")
  final int? siblingsCount;
  @JsonKey(name: "friends_count")
  final int? friendsCount;

  Children ({
    this.idChildren,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.imageUrl,
    this.emailChildren,
    this.userId,
    this.siblingsCount,
    this.friendsCount,
  });

  factory Children.fromJson(Map<String, dynamic> json) {
    return _$ChildrenFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChildrenToJson(this);
  }
}


