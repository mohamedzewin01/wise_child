import 'package:json_annotation/json_annotation.dart';

part 'check_code_request.g.dart';

@JsonSerializable()
class CheckCodeRequest {
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "user_id")
  final String? userId;

  CheckCodeRequest ({
    this.code,
    this.userId,
  });

  factory CheckCodeRequest.fromJson(Map<String, dynamic> json) {
    return _$CheckCodeRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CheckCodeRequestToJson(this);
  }
}


