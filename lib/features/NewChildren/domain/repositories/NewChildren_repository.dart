import 'dart:io';

import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/domain/entities/add_entity.dart';
import 'package:wise_child/features/NewChildren/domain/entities/upload_image_entity.dart';

abstract class NewChildrenRepository {
  Future<Result<AddChildEntity?>> addChild(AddNewChildRequest addChildRequest);
  Future<Result<UploadImageEntity?>> uploadImage(File image, String idChildren);
}
