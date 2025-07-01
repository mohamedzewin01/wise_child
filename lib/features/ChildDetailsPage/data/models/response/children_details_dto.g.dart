// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildrenDetailsDto _$ChildrenDetailsDtoFromJson(Map<String, dynamic> json) =>
    ChildrenDetailsDto(
      status: json['status'] as String?,
      child: json['child'] == null
          ? null
          : ChildDetails.fromJson(json['child'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChildrenDetailsDtoToJson(ChildrenDetailsDto instance) =>
    <String, dynamic>{'status': instance.status, 'child': instance.child};

ChildDetails _$ChildDetailsFromJson(Map<String, dynamic> json) => ChildDetails(
  idChildren: (json['id_children'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  imageUrl: json['imageUrl'] as String?,
  emailChildren: json['email_children'] as String?,
  userId: json['user_id'] as String?,
  siblingsCount: (json['siblings_count'] as num?)?.toInt(),
  friendsCount: (json['friends_count'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  stories: (json['stories'] as List<dynamic>?)
      ?.map((e) => Stories.fromJson(e as Map<String, dynamic>))
      .toList(),
  friends: (json['friends'] as List<dynamic>?)
      ?.map((e) => Friends.fromJson(e as Map<String, dynamic>))
      .toList(),
  siblings: (json['siblings'] as List<dynamic>?)
      ?.map((e) => Siblings.fromJson(e as Map<String, dynamic>))
      .toList(),
  bestPlaymate: json['best_playmate'] == null
      ? null
      : BestPlaymate.fromJson(json['best_playmate'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChildDetailsToJson(ChildDetails instance) =>
    <String, dynamic>{
      'id_children': instance.idChildren,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'gender': instance.gender,
      'date_of_birth': instance.dateOfBirth,
      'imageUrl': instance.imageUrl,
      'email_children': instance.emailChildren,
      'user_id': instance.userId,
      'siblings_count': instance.siblingsCount,
      'friends_count': instance.friendsCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'stories': instance.stories,
      'friends': instance.friends,
      'siblings': instance.siblings,
      'best_playmate': instance.bestPlaymate,
    };

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
  storyId: (json['story_id'] as num?)?.toInt(),
  storyTitle: json['story_title'] as String?,
  imageCover: json['image_cover'] as String?,
  storyDescription: json['story_description'] as String?,
  problemId: (json['problem_id'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  ageGroup: json['age_group'] as String?,
  categoryId: (json['category_id'] as num?)?.toInt(),
  isActive: (json['is_active'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
  'story_id': instance.storyId,
  'story_title': instance.storyTitle,
  'image_cover': instance.imageCover,
  'story_description': instance.storyDescription,
  'problem_id': instance.problemId,
  'gender': instance.gender,
  'age_group': instance.ageGroup,
  'category_id': instance.categoryId,
  'is_active': instance.isActive,
  'created_at': instance.createdAt,
};

Friends _$FriendsFromJson(Map<String, dynamic> json) => Friends(
  idFriend: (json['id_friend'] as num?)?.toInt(),
  childId: (json['child_id'] as num?)?.toInt(),
  friendName: json['friend_name'] as String?,
  friendAge: (json['friend_age'] as num?)?.toInt(),
  friendGender: json['friend_gender'] as String?,
  friendContact: (json['friend_contact'] as num?)?.toInt(),
);

Map<String, dynamic> _$FriendsToJson(Friends instance) => <String, dynamic>{
  'id_friend': instance.idFriend,
  'child_id': instance.childId,
  'friend_name': instance.friendName,
  'friend_age': instance.friendAge,
  'friend_gender': instance.friendGender,
  'friend_contact': instance.friendContact,
};

Siblings _$SiblingsFromJson(Map<String, dynamic> json) => Siblings(
  idSibling: (json['id_sibling'] as num?)?.toInt(),
  childId: (json['child_id'] as num?)?.toInt(),
  siblingName: json['sibling_name'] as String?,
  siblingAge: (json['sibling_age'] as num?)?.toInt(),
  siblingGender: json['sibling_gender'] as String?,
  relationship: (json['relationship'] as num?)?.toInt(),
);

Map<String, dynamic> _$SiblingsToJson(Siblings instance) => <String, dynamic>{
  'id_sibling': instance.idSibling,
  'child_id': instance.childId,
  'sibling_name': instance.siblingName,
  'sibling_age': instance.siblingAge,
  'sibling_gender': instance.siblingGender,
  'relationship': instance.relationship,
};

BestPlaymate _$BestPlaymateFromJson(Map<String, dynamic> json) => BestPlaymate(
  idPlaymate: (json['id_playmate'] as num?)?.toInt(),
  idChildren: (json['id_children'] as num?)?.toInt(),
  playmateName: json['playmate_name'] as String?,
  playmateAge: (json['playmate_age'] as num?)?.toInt(),
  playmateGender: json['playmate_gender'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$BestPlaymateToJson(BestPlaymate instance) =>
    <String, dynamic>{
      'id_playmate': instance.idPlaymate,
      'id_children': instance.idChildren,
      'playmate_name': instance.playmateName,
      'playmate_age': instance.playmateAge,
      'playmate_gender': instance.playmateGender,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
