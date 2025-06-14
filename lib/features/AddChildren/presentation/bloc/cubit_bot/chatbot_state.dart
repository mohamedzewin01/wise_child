// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:wise_child/features/AddChildren/presentation/child_profile_model.dart';
//
//
// // تعريف مراحل المحادثة المحدثة
// enum ConversationStage {
//   askingGender,
//   greeting,
//   askingFirstName,
//   askingLastName,
//   askingDob,
//   askingProfilePicture,
//
//   // --- مراحل الأخوة المفصلة ---
//   askingHasSiblings,
//   askingSiblingGender,
//   askingSiblingName,
//   askingSiblingAge,
//   askingAnotherSibling,
//
//   // --- مراحل الأقارب ---
//   askingHasRelatives,
//   collectingRelativeInfo,
//   askingAnotherRelative,
//
//   // --- مراحل الألعاب ---
//   askingFavoriteGame,
//   askingAnotherGame,
//
//   // --- المراحل النهائية ---
//   summary,
//   done
// }
//
// class ChatbotState extends Equatable {
//   final List<Widget> messages;
//   final ConversationStage stage;
//   final ChildProfileModel childProfile;
//   final bool isWaitingForTextInput;
//
//   const ChatbotState({
//     required this.messages,
//     required this.stage,
//     required this.childProfile,
//     required this.isWaitingForTextInput,
//   });
//
//   // الحالة الأولية للمحادثة
//   factory ChatbotState.initial() {
//     return ChatbotState(
//       messages: [],
//       stage: ConversationStage.greeting,
//       childProfile: ChildProfileModel(),
//       isWaitingForTextInput: false,
//     );
//   }
//
//   // دالة لإنشاء نسخة جديدة من الحالة مع تعديل بعض القيم
//   ChatbotState copyWith({
//     List<Widget>? messages,
//     ConversationStage? stage,
//     ChildProfileModel? childProfile,
//     bool? isWaitingForTextInput,
//   }) {
//     return ChatbotState(
//       messages: messages ?? this.messages,
//       stage: stage ?? this.stage,
//       childProfile: childProfile ?? this.childProfile,
//       isWaitingForTextInput: isWaitingForTextInput ?? this.isWaitingForTextInput,
//     );
//   }
//
//   @override
//   List<Object?> get props => [messages, stage, childProfile, isWaitingForTextInput];
// }