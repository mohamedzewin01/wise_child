import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Store_useCase_repo.dart';

part 'Store_state.dart';

@injectable
class StoreCubit extends Cubit<StoreState> {
  StoreCubit(this._storeUseCaseRepo) : super(StoreInitial());
  final StoreUseCaseRepo _storeUseCaseRepo;
}
