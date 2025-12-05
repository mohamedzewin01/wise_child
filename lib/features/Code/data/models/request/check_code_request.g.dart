// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckCodeRequest _$CheckCodeRequestFromJson(Map<String, dynamic> json) =>
    CheckCodeRequest(
      code: json['code'] as String?,
      userId: json['user_id'] as String?,
    );

Map<String, dynamic> _$CheckCodeRequestToJson(CheckCodeRequest instance) =>
    <String, dynamic>{'code': instance.code, 'user_id': instance.userId};
