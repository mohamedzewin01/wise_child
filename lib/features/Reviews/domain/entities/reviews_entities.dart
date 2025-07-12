




import 'package:wise_child/features/Reviews/data/models/response/get_children_review_dto.dart';

class AddChildReviewEntity {
  final String? status;

  final String? message;

  AddChildReviewEntity({this.status, this.message});
}

class GetChildrenReviewEntity {

  final String? status;

  final String? message;

  final ChildrenReviewData? review;

  GetChildrenReviewEntity ({
    this.status,
    this.message,
    this.review,
  });


}