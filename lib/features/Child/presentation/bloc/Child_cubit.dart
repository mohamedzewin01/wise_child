import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Child_useCase_repo.dart';

part 'Child_state.dart';

@injectable
class ChildCubit extends Cubit<ChildState> {
  ChildCubit(this._childUseCaseRepo) : super(ChildInitial());
  final ChildUseCaseRepo _childUseCaseRepo;
}
