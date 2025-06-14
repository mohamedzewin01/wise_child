// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_child_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddNewChildRequest _$AddNewChildRequestFromJson(Map<String, dynamic> json) =>
    AddNewChildRequest(
      userId: json['user_id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      imageUrl: json['imageUrl'] as String?,
      siblings: (json['siblings'] as List<dynamic>?)
          ?.map((e) => Siblings.fromJson(e as Map<String, dynamic>))
          .toList(),
      friends: (json['friends'] as List<dynamic>?)
          ?.map((e) => Friends.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddNewChildRequestToJson(AddNewChildRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'gender': instance.gender,
      'date_of_birth': instance.dateOfBirth,
      'imageUrl': instance.imageUrl,
      'siblings': instance.siblings,
      'friends': instance.friends,
    };

Siblings _$SiblingsFromJson(Map<String, dynamic> json) => Siblings(
  name: json['name'] as String?,
  age: (json['age'] as num?)?.toInt(),
  gender: json['gender'] as String?,
);

Map<String, dynamic> _$SiblingsToJson(Siblings instance) => <String, dynamic>{
  'name': instance.name,
  'age': instance.age,
  'gender': instance.gender,
};

Friends _$FriendsFromJson(Map<String, dynamic> json) => Friends(
  name: json['name'] as String?,
  age: (json['age'] as num?)?.toInt(),
  gender: json['gender'] as String?,
);

Map<String, dynamic> _$FriendsToJson(Friends instance) => <String, dynamic>{
  'name': instance.name,
  'age': instance.age,
  'gender': instance.gender,
};
