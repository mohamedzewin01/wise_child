import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/directions.dart';

part 'directions_dto.g.dart';

@JsonSerializable()
class DirectionsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "directions")
  final List<Directions>? directions;

  DirectionsDto ({
    this.status,
    this.message,
    this.directions,
  });

  factory DirectionsDto.fromJson(Map<String, dynamic> json) {
    return _$DirectionsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DirectionsDtoToJson(this);
  }
  DirectionsEntity toDirectionsEntity() {
    return DirectionsEntity(status: status, message: message, directions: directions);
  }
}

@JsonSerializable()
class Directions {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "description")
  final dynamic? description;
  @JsonKey(name: "created_at")
  final String? createdAt;

  Directions ({
    this.id,
    this.title,
    this.description,
    this.createdAt,
  });

  factory Directions.fromJson(Map<String, dynamic> json) {
    return _$DirectionsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DirectionsToJson(this);
  }
}


