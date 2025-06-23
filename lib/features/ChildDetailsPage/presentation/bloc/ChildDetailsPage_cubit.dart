import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/ChildDetailsPage_useCase_repo.dart';

part 'ChildDetailsPage_state.dart';

@injectable
class ChildDetailsPageCubit extends Cubit<ChildDetailsPageState> {
  ChildDetailsPageCubit(this._childdetailspageUseCaseRepo) : super(ChildDetailsPageInitial());
  final ChildDetailsPageUseCaseRepo _childdetailspageUseCaseRepo;
}
