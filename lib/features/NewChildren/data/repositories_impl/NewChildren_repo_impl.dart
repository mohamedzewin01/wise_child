import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/NewChildren/data/datasources/NewChildren_datasource_repo.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/domain/entities/add_entity.dart';
import 'package:wise_child/features/NewChildren/domain/entities/upload_image_entity.dart';
import '../../domain/repositories/NewChildren_repository.dart';

@Injectable(as: NewChildrenRepository)
class NewChildrenRepositoryImpl implements NewChildrenRepository {
  final NewChildrenDatasourceRepo newChildrenDatasourceRepo;
  NewChildrenRepositoryImpl(this.newChildrenDatasourceRepo);
  @override
  Future<Result<AddChildEntity?>> addChild(AddNewChildRequest addChildRequest) {
   return newChildrenDatasourceRepo.addChild(addChildRequest);
  }

  @override
  Future<Result<UploadImageEntity?>> uploadImage(File image,String idChildren) {
  return newChildrenDatasourceRepo.uploadImage(image,idChildren);
  }
  // implementation
}
