
import 'package:wise_child/features/Auth/data/models/response/users_model.dart';

class UserSignUpEntity {
  final NewUser? user;
  final String? message;
  final String? status;

  UserSignUpEntity({this.user, this.message, this.status});
}

class UserSingUpEntity {
  final String id;
  final String email;
  final String name;
  final String image;

  UserSingUpEntity({required this.id, required this.email, required this.name,required this.image});
}

