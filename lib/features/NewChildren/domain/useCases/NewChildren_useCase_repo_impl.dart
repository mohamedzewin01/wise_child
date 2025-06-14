import 'dart:io';

import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/domain/entities/add_entity.dart';
import 'package:wise_child/features/NewChildren/domain/entities/upload_image_entity.dart';
import '../repositories/NewChildren_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/NewChildren_useCase_repo.dart';

@Injectable(as: NewChildrenUseCaseRepo)
class NewChildrenUseCase implements NewChildrenUseCaseRepo {
  final NewChildrenRepository repository;

  NewChildrenUseCase(this.repository);

  @override
  Future<Result<AddChildEntity?>> addChild(AddNewChildRequest addChildRequest) {
 return repository.addChild(addChildRequest);
  }

  @override
  Future<Result<UploadImageEntity?>> uploadImage(File image, String idChildren) {
    return repository.uploadImage(image,idChildren);
  }


}
