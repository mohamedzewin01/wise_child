// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_story_requests_replies_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetStoryRequestsRepliesDto _$GetStoryRequestsRepliesDtoFromJson(
  Map<String, dynamic> json,
) => GetStoryRequestsRepliesDto(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => DataStoryRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetStoryRequestsRepliesDtoToJson(
  GetStoryRequestsRepliesDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

DataStoryRequest _$DataStoryRequestFromJson(Map<String, dynamic> json) =>
    DataStoryRequest(
      requestId: (json['request_id'] as num?)?.toInt(),
      childId: (json['child_id'] as num?)?.toInt(),
      problemTitle: json['problem_title'] as String?,
      problemText: json['problem_text'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      reply: json['reply'] == null
          ? null
          : Reply.fromJson(json['reply'] as Map<String, dynamic>),
      child: json['child'] == null
          ? null
          : Child.fromJson(json['child'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataStoryRequestToJson(DataStoryRequest instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'child_id': instance.childId,
      'problem_title': instance.problemTitle,
      'problem_text': instance.problemText,
      'notes': instance.notes,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'reply': instance.reply,
      'child': instance.child,
    };

Reply _$ReplyFromJson(Map<String, dynamic> json) => Reply(
  replyId: (json['reply_id'] as num?)?.toInt(),
  replyText: json['reply_text'] as String?,
  attachedStory: json['attached_story'] == null
      ? null
      : AttachedStory.fromJson(json['attached_story'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
  'reply_id': instance.replyId,
  'reply_text': instance.replyText,
  'attached_story': instance.attachedStory,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

AttachedStory _$AttachedStoryFromJson(Map<String, dynamic> json) =>
    AttachedStory(
      storyId: (json['story_id'] as num?)?.toInt(),
      storyTitle: json['story_title'] as String?,
      imageCover: json['image_cover'] as String?,
      storyDescription: json['story_description'] as String?,
    );

Map<String, dynamic> _$AttachedStoryToJson(AttachedStory instance) =>
    <String, dynamic>{
      'story_id': instance.storyId,
      'story_title': instance.storyTitle,
      'image_cover': instance.imageCover,
      'story_description': instance.storyDescription,
    };

Child _$ChildFromJson(Map<String, dynamic> json) => Child(
  idChildren: (json['id_children'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  imageUrl: json['imageUrl'] as String?,
  emailChildren: json['email_children'] as String?,
  siblingsCount: (json['siblings_count'] as num?)?.toInt(),
  friendsCount: (json['friends_count'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$ChildToJson(Child instance) => <String, dynamic>{
  'id_children': instance.idChildren,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'gender': instance.gender,
  'date_of_birth': instance.dateOfBirth,
  'imageUrl': instance.imageUrl,
  'email_children': instance.emailChildren,
  'siblings_count': instance.siblingsCount,
  'friends_count': instance.friendsCount,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
