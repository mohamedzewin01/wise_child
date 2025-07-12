import 'package:json_annotation/json_annotation.dart';

part 'add_story_requests_model.g.dart';

@JsonSerializable()
class AddStoryRequestsModel {
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_text")
  final String? problemText;
  @JsonKey(name: "notes")
  final String? notes;

  AddStoryRequestsModel ({
    this.userId,
    this.idChildren,
    this.problemTitle,
    this.problemText,
    this.notes,
  });

  factory AddStoryRequestsModel.fromJson(Map<String, dynamic> json) {
    return _$AddStoryRequestsModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AddStoryRequestsModelToJson(this);
  }

}


