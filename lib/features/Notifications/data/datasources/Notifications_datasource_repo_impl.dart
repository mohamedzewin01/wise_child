import 'Notifications_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: NotificationsDatasourceRepo)
class NotificationsDatasourceRepoImpl implements NotificationsDatasourceRepo {
  final ApiService apiService;
  NotificationsDatasourceRepoImpl(this.apiService);
}
