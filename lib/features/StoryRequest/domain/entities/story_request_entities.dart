

import '../../data/models/response/get_children_dto.dart';

class GetUserChildrenEntity {
  final String? status;
  final String? message;
  final List<UserChildren>? children;

  GetUserChildrenEntity ({
    this.status,
    this.message,
    this.children,
  });

}

class AddStoryRequestsEntity {

  final String? status;

  final String? message;

  AddStoryRequestsEntity ({
    this.status,
    this.message,
  });

}