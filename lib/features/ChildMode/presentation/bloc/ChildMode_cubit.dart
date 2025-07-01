import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/ChildMode_useCase_repo.dart';

part 'ChildMode_state.dart';

@injectable
class ChildModeCubit extends Cubit<ChildModeState> {
  ChildModeCubit(this._childmodeUseCaseRepo) : super(ChildModeInitial());
  final ChildModeUseCaseRepo _childmodeUseCaseRepo;
}
