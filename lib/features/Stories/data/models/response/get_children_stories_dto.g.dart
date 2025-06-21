// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_children_stories_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChildrenStoriesDto _$GetChildrenStoriesDtoFromJson(
  Map<String, dynamic> json,
) => GetChildrenStoriesDto(
  status: json['status'] as String?,
  data: json['data'] == null
      ? null
      : Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetChildrenStoriesDtoToJson(
  GetChildrenStoriesDto instance,
) => <String, dynamic>{'status': instance.status, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  storiesList: (json['storiesList'] as List<dynamic>?)
      ?.map((e) => StoriesList.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'storiesList': instance.storiesList,
};

StoriesList _$StoriesListFromJson(Map<String, dynamic> json) => StoriesList(
  childrenStoriesId: (json['children_stories_id'] as num?)?.toInt(),
  childrenId: (json['children_id'] as num?)?.toInt(),
  storiesId: (json['stories_id'] as num?)?.toInt(),
  creatorUserId: json['creator_user_id'] as String?,
  storyProblemId: (json['story_problem_id'] as num?)?.toInt(),
  storyCreationDate: json['story_creation_date'] as String?,
  idChildren: (json['id_children'] as num?)?.toInt(),
  childFirstName: json['child_first_name'] as String?,
  childLastName: json['child_last_name'] as String?,
  childGender: json['child_gender'] as String?,
  childDob: json['child_dob'] as String?,
  childImage: json['child_image'] as String?,
  childEmail: json['child_email'],
  siblingsCount: (json['siblings_count'] as num?)?.toInt(),
  friendsCount: (json['friends_count'] as num?)?.toInt(),
  childCreatedAt: json['child_created_at'] as String?,
  childUpdatedAt: json['child_updated_at'] as String?,
  userId: json['user_id'] as String?,
  userFirstName: json['user_first_name'] as String?,
  userLastName: json['user_last_name'] as String?,
  userGender: json['user_gender'],
  userAge: json['user_age'],
  userEmail: json['user_email'] as String?,
  userRole: json['user_role'] as String?,
  userProfileImage: json['user_profile_image'] as String?,
  userCreatedAt: json['user_created_at'] as String?,
  userUpdatedAt: json['user_updated_at'] as String?,
  problemId: (json['problem_id'] as num?)?.toInt(),
  problemTitle: json['problem_title'] as String?,
  problemDescription: json['problem_description'] as String?,
  problemCreatedAt: json['problem_created_at'] as String?,
  storyId: (json['story_id'] as num?)?.toInt(),
  storyTitle: json['story_title'] as String?,
  storyDescription: json['story_description'] as String?,
  storyCoverImage: json['story_cover_image'] as String?,
  storyCreatedAt: json['story_created_at'] as String?,
);

Map<String, dynamic> _$StoriesListToJson(StoriesList instance) =>
    <String, dynamic>{
      'children_stories_id': instance.childrenStoriesId,
      'children_id': instance.childrenId,
      'stories_id': instance.storiesId,
      'creator_user_id': instance.creatorUserId,
      'story_problem_id': instance.storyProblemId,
      'story_creation_date': instance.storyCreationDate,
      'id_children': instance.idChildren,
      'child_first_name': instance.childFirstName,
      'child_last_name': instance.childLastName,
      'child_gender': instance.childGender,
      'child_dob': instance.childDob,
      'child_image': instance.childImage,
      'child_email': instance.childEmail,
      'siblings_count': instance.siblingsCount,
      'friends_count': instance.friendsCount,
      'child_created_at': instance.childCreatedAt,
      'child_updated_at': instance.childUpdatedAt,
      'user_id': instance.userId,
      'user_first_name': instance.userFirstName,
      'user_last_name': instance.userLastName,
      'user_gender': instance.userGender,
      'user_age': instance.userAge,
      'user_email': instance.userEmail,
      'user_role': instance.userRole,
      'user_profile_image': instance.userProfileImage,
      'user_created_at': instance.userCreatedAt,
      'user_updated_at': instance.userUpdatedAt,
      'problem_id': instance.problemId,
      'problem_title': instance.problemTitle,
      'problem_description': instance.problemDescription,
      'problem_created_at': instance.problemCreatedAt,
      'story_id': instance.storyId,
      'story_title': instance.storyTitle,
      'story_description': instance.storyDescription,
      'story_cover_image': instance.storyCoverImage,
      'story_created_at': instance.storyCreatedAt,
    };
