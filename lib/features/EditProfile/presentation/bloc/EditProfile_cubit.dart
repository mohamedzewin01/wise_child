import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/EditProfile_useCase_repo.dart';

part 'EditProfile_state.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._editprofileUseCaseRepo) : super(EditProfileInitial());
  final EditProfileUseCaseRepo _editprofileUseCaseRepo;
}
