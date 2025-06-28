// part of 'Settings_cubit.dart';
//
// @immutable
// sealed class SettingsState {}
//
// final class SettingsInitial extends SettingsState {}
// final class SettingsLoading extends SettingsState {}
// final class SettingsSuccess extends SettingsState {}
// final class SettingsFailure extends SettingsState {
//   final Exception exception;
//
//   SettingsFailure(this.exception);
// }
part of 'Settings_cubit.dart';

@immutable
sealed class SettingsState {}

// Initial States
final class SettingsInitial extends SettingsState {}
final class SettingsLoading extends SettingsState {}
final class SettingsSuccess extends SettingsState {}
final class SettingsFailure extends SettingsState {
  final Exception exception;
  SettingsFailure(this.exception);
}

// Setting Change States
final class NotificationSettingChanged extends SettingsState {
  final bool enabled;
  NotificationSettingChanged(this.enabled);
}

final class ChatbotSettingChanged extends SettingsState {
  final bool enabled;
  ChatbotSettingChanged(this.enabled);
}

final class ChildModeSettingChanged extends SettingsState {
  final bool enabled;
  ChildModeSettingChanged(this.enabled);
}

final class LanguageSettingChanged extends SettingsState {
  final String languageCode;
  LanguageSettingChanged(this.languageCode);
}

// Action States
final class BackupCreated extends SettingsState {}
final class BackupRestored extends SettingsState {}
final class FeedbackSent extends SettingsState {}
final class AccountDeleted extends SettingsState {}
final class LoggedOut extends SettingsState {}
final class SettingsReset extends SettingsState {}