import 'package:json_annotation/json_annotation.dart';

part 'reports_request.g.dart';

@JsonSerializable()
class ReportsRequest {
  @JsonKey(name: "user_id")
  final String? userId;

  ReportsRequest ({
    this.userId,
  });

  factory ReportsRequest.fromJson(Map<String, dynamic> json) {
    return _$ReportsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ReportsRequestToJson(this);
  }
}


