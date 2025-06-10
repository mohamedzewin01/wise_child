import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/directions.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/useCases/ChatBotAssistant_useCase_repo.dart';

part 'directions_state.dart';

@injectable
class DirectionsCubit extends Cubit<DirectionsState> {
  DirectionsCubit(this._assistantUseCaseRepo) : super(DirectionsInitial());
  final ChatBotAssistantUseCaseRepo _assistantUseCaseRepo;
  static DirectionsCubit get(context) => BlocProvider.of(context);
  Future<void> getDirections() async {

    var result = await _assistantUseCaseRepo.getDirections();
    switch (result) {
      case Success<DirectionsEntity?>():
        {
          if (!isClosed) {
            emit(DirectionsSuccess(result.data!));
          }
        }
      case Fail<DirectionsEntity?>():
        {
          if (!isClosed) {
            emit(DirectionsError(result.exception));
          }
        }
    }

  }

}

