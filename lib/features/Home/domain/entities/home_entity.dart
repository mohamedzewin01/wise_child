import 'package:wise_child/features/Home/data/models/response/app_status_dto.dart';
import 'package:wise_child/features/Home/data/models/response/get_home_request.dart';

class GetHomeEntity {

  final String? status;

  final String? message;

  final DataHome? data;

  GetHomeEntity ({
    this.status,
    this.message,
    this.data,
  });


}

class AppStatusEntity {

  final String? status;

  final Data? data;

  AppStatusEntity ({
    this.status,
    this.data,
  });


}