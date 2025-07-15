// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppStatusDto _$AppStatusDtoFromJson(Map<String, dynamic> json) => AppStatusDto(
  status: json['status'] as String?,
  data: json['data'] == null
      ? null
      : Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppStatusDtoToJson(AppStatusDto instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  isActive: json['is_active'] as bool?,
  message: json['message'] as String?,
  imageUrl: json['image_url'] as String?,
  maintenanceUntil: json['maintenance_until'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'is_active': instance.isActive,
  'message': instance.message,
  'image_url': instance.imageUrl,
  'maintenance_until': instance.maintenanceUntil,
};
