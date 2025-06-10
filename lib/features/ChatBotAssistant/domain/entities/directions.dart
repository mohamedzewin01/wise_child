




import 'package:wise_child/features/ChatBotAssistant/data/models/response/directions_dto.dart';

class DirectionsEntity{

  final String? status;

  final String? message;

  final List<Directions>? directions;

  DirectionsEntity({
    this.status,
    this.message,
    this.directions,
  });


}