import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Home/domain/entities/home_entity.dart';
import 'package:wise_child/features/Welcome/domain/entities/app_status_entity.dart';

part 'app_status_dto.g.dart';

@JsonSerializable()
class AppStatusDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "data")
  final Data? data;

  AppStatusDto ({
    this.status,
    this.data,
  });

  factory AppStatusDto.fromJson(Map<String, dynamic> json) {
    return _$AppStatusDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AppStatusDtoToJson(this);
  }
  AppStatusEntity toEntity() {
    return AppStatusEntity(
      status: status,
      data: data,
    );
  }
}

@JsonSerializable()
class Data {
  @JsonKey(name: "is_active")
  final bool? isActive;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "image_url")
  final String? imageUrl;
  @JsonKey(name: "maintenance_until")
  final String? maintenanceUntil;

  Data ({
    this.isActive,
    this.message,
    this.imageUrl,
    this.maintenanceUntil,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return _$DataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataToJson(this);
  }
}


