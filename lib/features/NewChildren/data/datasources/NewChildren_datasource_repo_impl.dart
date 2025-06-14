import 'dart:io';

import 'package:wise_child/core/api/api_extentions.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/domain/entities/add_entity.dart';
import 'package:wise_child/features/NewChildren/domain/entities/upload_image_entity.dart';
import 'NewChildren_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: NewChildrenDatasourceRepo)
class NewChildrenDatasourceRepoImpl implements NewChildrenDatasourceRepo {
  final ApiService apiService;
  NewChildrenDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<AddChildEntity?>> addChild(AddNewChildRequest addChildRequest) {
    return executeApi(() async {
      var addChild = await apiService.addChild(addChildRequest);
      return addChild?.toEntity();
    });
  }

  @override
  Future<Result<UploadImageEntity?>> uploadImage(File image, String idChildren) {
    return executeApi(() async {
      var uploadImage = await apiService.uploadImage(image, idChildren);
      return uploadImage?.toEntity();
    });
  }
}
