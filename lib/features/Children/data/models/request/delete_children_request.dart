import 'package:json_annotation/json_annotation.dart';

part 'delete_children_request.g.dart';

@JsonSerializable()
class DeleteChildrenRequest {
  @JsonKey(name: "id_children")
  final int? idChildren;

  DeleteChildrenRequest ({
    this.idChildren,
  });

  factory DeleteChildrenRequest.fromJson(Map<String, dynamic> json) {
    return _$DeleteChildrenRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteChildrenRequestToJson(this);
  }
}


