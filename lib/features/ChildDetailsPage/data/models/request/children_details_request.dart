import 'package:json_annotation/json_annotation.dart';

part 'children_details_request.g.dart';

@JsonSerializable()
class ChildrenDetailsRequest {
  @JsonKey(name: "child_id")
  final int? childId;

  ChildrenDetailsRequest ({
    this.childId,
  });

  factory ChildrenDetailsRequest.fromJson(Map<String, dynamic> json) {
    return _$ChildrenDetailsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChildrenDetailsRequestToJson(this);
  }
}


