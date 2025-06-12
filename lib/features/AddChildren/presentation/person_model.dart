import 'dart:io'; // استيراد مكتبة الإدخال/الإخراج
import 'person_model.dart';




// lib/models/person_model.dart

class PersonModel {
  String name;
  String age;
  String gender;
  final int id;

  PersonModel({
    this.name = '',
    this.age = '',
    this.gender = '',
    required this.id,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
    };
  }
}