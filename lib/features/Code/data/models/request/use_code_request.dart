import 'package:json_annotation/json_annotation.dart';

part 'use_code_request.g.dart';

@JsonSerializable()
class UseCodeRequest {
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "user_id")
  final String? userId;

  UseCodeRequest ({
    this.code,
    this.userId,
  });

  factory UseCodeRequest.fromJson(Map<String, dynamic> json) {
    return _$UseCodeRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UseCodeRequestToJson(this);
  }
}


