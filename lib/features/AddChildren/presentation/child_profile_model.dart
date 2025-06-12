// lib/models/child_profile_model.dart

import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../AddChildren/presentation/person_model.dart';

class ChildProfileModel extends Equatable {
  final String firstName;
  final String lastName;
  final String gender; // هذا الحقل لم نستخدمه للطفل الرئيسي، يمكنك إضافته للمحادثة إذا أردت
  final DateTime? dateOfBirth;
  final File? profileImage;
  final List<PersonModel> siblings;
  final List<PersonModel> relatives;
  final List<String> favoriteGames;

  ChildProfileModel({
    this.firstName = '',
    this.lastName = '',
    this.gender = '',
    this.dateOfBirth,
    this.profileImage,
    List<PersonModel>? siblings,
    List<PersonModel>? relatives,
    List<String>? favoriteGames,
  })  : this.siblings = siblings ?? [],
        this.relatives = relatives ?? [],
        this.favoriteGames = favoriteGames ?? [];

  // <-- دالة جديدة لتحويل الكائن إلى خريطة
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.toIso8601String(), // تحويل التاريخ إلى نص متوافق مع JSON
      // ملاحظة: مسار الصورة فقط يمكن تحويله لـ JSON، وليس الملف نفسه
      'profileImagePath': profileImage?.path,
      'siblings': siblings.map((sibling) => sibling.toJson()).toList(), // تحويل كل أخ إلى JSON
      'relatives': relatives.map((relative) => relative.toJson()).toList(), // تحويل كل قريب إلى JSON
      'favoriteGames': favoriteGames,
    };
  }

  ChildProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dateOfBirth,
    File? profileImage,
    List<PersonModel>? siblings,
    List<PersonModel>? relatives,
    List<String>? favoriteGames,
  }) {
    // ... (هذه الدالة تبقى كما هي)
    return ChildProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImage: profileImage ?? this.profileImage,
      siblings: siblings ?? this.siblings,
      relatives: relatives ?? this.relatives,
      favoriteGames: favoriteGames ?? this.favoriteGames,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    gender,
    dateOfBirth,
    profileImage,
    siblings,
    relatives,
    favoriteGames
  ];
}