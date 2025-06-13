import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../../presentation/person_model.dart';

part 'add_child_request.g.dart';

@JsonSerializable()
class AddChildRequest {
  @JsonKey(name: "user_id")
  final String? userId;
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
  @JsonKey(name: "siblings")
  final List<Siblings>? siblings;
  @JsonKey(name: "friends")
  final List<Friends>? friends;

  AddChildRequest ({
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.imageUrl,
    this.siblings,
    this.friends,
  });

  factory AddChildRequest.fromJson(Map<String, dynamic> json) {
    return _$AddChildRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddChildRequestToJson(this);
  }

}

@JsonSerializable()
class Siblings {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "age")
  final int? age;
  @JsonKey(name: "gender")
  final String? gender;

  Siblings ({
    this.name,
    this.age,
    this.gender,
  });

  factory Siblings.fromJson(Map<String, dynamic> json) {
    return _$SiblingsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SiblingsToJson(this);
  }
}

@JsonSerializable()
class Friends {

  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "age")
  final int? age;
  @JsonKey(name: "gender")
  final String? gender;

  Friends ({
    this.name,
    this.age,
    this.gender,
  });

  factory Friends.fromJson(Map<String, dynamic> json) {
    return _$FriendsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FriendsToJson(this);
  }
}


