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