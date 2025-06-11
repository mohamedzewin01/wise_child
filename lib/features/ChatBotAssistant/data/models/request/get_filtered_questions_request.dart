import 'package:json_annotation/json_annotation.dart';

part 'get_filtered_questions_request.g.dart';

@JsonSerializable()
class GetFilteredQuestionsRequest {
  @JsonKey(name: "directions")
  final String? directions;

  GetFilteredQuestionsRequest ({
    this.directions,
  });

  factory GetFilteredQuestionsRequest.fromJson(Map<String, dynamic> json) {
    return _$GetFilteredQuestionsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetFilteredQuestionsRequestToJson(this);
  }
}


