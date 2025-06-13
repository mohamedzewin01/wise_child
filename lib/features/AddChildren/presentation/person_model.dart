import 'dart:io'; // استيراد مكتبة الإدخال/الإخراج
import 'package:wise_child/features/AddChildren/data/models/request/add_child_request.dart';

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