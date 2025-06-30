import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/EditChildren_useCase_repo.dart';

part 'EditChildren_state.dart';

@injectable
class EditChildrenCubit extends Cubit<EditChildrenState> {
  EditChildrenCubit(this._editchildrenUseCaseRepo) : super(EditChildrenInitial());
  final EditChildrenUseCaseRepo _editchildrenUseCaseRepo;
}
