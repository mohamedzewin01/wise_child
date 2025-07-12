import 'package:json_annotation/json_annotation.dart';
import 'package:wise_child/features/Reports/domain/entities/reports_entities.dart';

part 'reports_dto.g.dart';

@JsonSerializable()
class ReportsDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final List<ReportData>? data;

  ReportsDto ({
    this.status,
    this.message,
    this.data,
  });

  factory ReportsDto.fromJson(Map<String, dynamic> json) {
    return _$ReportsDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ReportsDtoToJson(this);
  }
  ReportsEntity toEntity() {
    return ReportsEntity(
      status: status,
      message: message,
      data: data,
    );
  }
}

@JsonSerializable()
class ReportData {
  @JsonKey(name: "child_id")
  final int? childId;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "date_of_birth")
  final String? dateOfBirth;
  @JsonKey(name: "stories")
  final List<Stories>? stories;

  ReportData ({
    this.childId,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.stories,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return _$ReportDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ReportDataToJson(this);
  }
}

@JsonSerializable()
class Stories {
  @JsonKey(name: "story_id")
  final int? storyId;
  @JsonKey(name: "story_title")
  final String? storyTitle;
  @JsonKey(name: "story_created_at")
  final String? storyCreatedAt;
  @JsonKey(name: "total_views")
  final int? totalViews;
  @JsonKey(name: "last_viewed")
  final String? lastViewed;

  Stories ({
    this.storyId,
    this.storyTitle,
    this.storyCreatedAt,
    this.totalViews,
    this.lastViewed,
  });

  factory Stories.fromJson(Map<String, dynamic> json) {
    return _$StoriesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoriesToJson(this);
  }
}


