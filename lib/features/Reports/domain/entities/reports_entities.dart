import 'package:wise_child/features/Reports/data/models/response/reports_dto.dart';

class ReportsEntity {

  final String? status;

  final String? message;

  final List<ReportData>? data;

  ReportsEntity ({
    this.status,
    this.message,
    this.data,
  });


}