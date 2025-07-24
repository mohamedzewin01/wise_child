import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Notifications_useCase_repo.dart';

part 'Notifications_state.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._notificationsUseCaseRepo) : super(NotificationsInitial());
  final NotificationsUseCaseRepo _notificationsUseCaseRepo;
}
