// import 'package:json_annotation/json_annotation.dart';
// import 'package:wise_child/features/AddChildren/domain/entities/add_entity.dart';
//
// part 'add_child_dto.g.dart';
//
// @JsonSerializable()
// class AddChildDto {
//   @JsonKey(name: "status")
//   final String? status;
//   @JsonKey(name: "message")
//   final String? message;
//   @JsonKey(name: "child_id")
//   final String? childId;
//
//   AddChildDto ({
//     this.status,
//     this.message,
//     this.childId,
//   });
//
//   factory AddChildDto.fromJson(Map<String, dynamic> json) {
//     return _$AddChildDtoFromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     return _$AddChildDtoToJson(this);
//   }
//   AddChildEntity toEntity() {
//     return AddChildEntity(
//       status: status,
//       message: message,
//       childId: childId,
//     );
//   }
// }
//
//
