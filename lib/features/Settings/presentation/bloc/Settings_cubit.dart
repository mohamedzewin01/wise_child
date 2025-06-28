// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:injectable/injectable.dart';
// import '../../domain/useCases/Settings_useCase_repo.dart';
//
// part 'Settings_state.dart';
//
// @injectable
// class SettingsCubit extends Cubit<SettingsState> {
//   SettingsCubit(this._settingsUseCaseRepo) : super(SettingsInitial());
//   final SettingsUseCaseRepo _settingsUseCaseRepo;
// }

// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:injectable/injectable.dart';
// import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
// import '../../domain/useCases/Settings_useCase_repo.dart';
//
// part 'Settings_state.dart';
//
// @injectable
// class SettingsCubit extends Cubit<SettingsState> {
//   SettingsCubit(this._settingsUseCaseRepo) : super(SettingsInitial());
//   final SettingsUseCaseRepo _settingsUseCaseRepo;
//
//   // Settings Properties
//   bool _areNotificationsEnabled = true;
//   bool _isChatbotEnabled = true;
//   bool _isChildModeActive = false;
//   String _selectedLanguage = 'ar';
//
//   // Getters
//   bool get areNotificationsEnabled => _areNotificationsEnabled;
//   bool get isChatbotEnabled => _isChatbotEnabled;
//   bool get isChildModeActive => _isChildModeActive;
//   String get selectedLanguage => _selectedLanguage;
//
//   // Initialize settings from cache
//   Future<void> initializeSettings() async {
//     emit(SettingsLoading());
//
//     try {
//       // Load settings from cache
//       _areNotificationsEnabled = await CacheService.getData(
//         key: 'notifications_enabled',
//       ) ?? true;
//
//       _isChatbotEnabled = await CacheService.getData(
//         key: 'chatbot_enabled',
//       ) ?? true;
//
//       _isChildModeActive = await CacheService.getData(
//         key: 'child_mode_active',
//       ) ?? false;
//
//       _selectedLanguage = await CacheService.getData(
//         key: 'selected_language',
//       ) ?? 'ar';
//
//       emit(SettingsSuccess());
//     } catch (e) {
//       emit(SettingsFailure(Exception('Failed to load settings')));
//     }
//   }
//
//   // Toggle Notifications
//   Future<void> toggleNotifications(bool enabled) async {
//     try {
//       _areNotificationsEnabled = enabled;
//       await CacheService.setData(
//         key: 'notifications_enabled',
//         value: enabled,
//       );
//       emit(NotificationSettingChanged(enabled));
//       emit(SettingsSuccess());
//     } catch (e) {
//       emit(SettingsFailure(Exception('Failed to update notification settings')));
//     }
//   }
//
//   // Toggle Chatbot
//   Future<void> toggleChatbot(bool enabled) async {
//     try {
//       _isChatbotEnabled = enabled;
//       await CacheService.setData(
//         key: 'chatbot_enabled',
//         value: enabled,
//       );
//       emit(ChatbotSettingChanged(enabled));
//       emit(SettingsSuccess());
//     } catch (e) {
//       emit(SettingsFailure(Exception('Failed to update chatbot settings')));
//     }
//   }
//
//   // Toggle Child Mode
//   Future<void> toggleChildMode(bool enabled) async {
//     try {
//       _isChildModeActive = enable

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import '../../domain/useCases/Settings_useCase_repo.dart';

part 'Settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._settingsUseCaseRepo) : super(SettingsInitial());
  final SettingsUseCaseRepo _settingsUseCaseRepo;

  // Settings Properties
  bool _areNotificationsEnabled = true;
  bool _isChatbotEnabled = true;
  bool _isChildModeActive = false;
  String _selectedLanguage = 'ar';

  // Getters
  bool get areNotificationsEnabled => _areNotificationsEnabled;
  bool get isChatbotEnabled => _isChatbotEnabled;
  bool get isChildModeActive => _isChildModeActive;
  String get selectedLanguage => _selectedLanguage;

  // Initialize settings from cache
  Future<void> initializeSettings() async {
    emit(SettingsLoading());

    try {
      // Load settings from cache
      _areNotificationsEnabled = await CacheService.getData(
        key: 'notifications_enabled',
      ) ?? true;

      _isChatbotEnabled = await CacheService.getData(
        key: 'chatbot_enabled',
      ) ?? true;

      _isChildModeActive = await CacheService.getData(
        key: 'child_mode_active',
      ) ?? false;

      _selectedLanguage = await CacheService.getData(
        key: 'selected_language',
      ) ?? 'ar';

      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to load settings')));
    }
  }

  // Toggle Notifications
  Future<void> toggleNotifications(bool enabled) async {
    try {
      _areNotificationsEnabled = enabled;
      await CacheService.setData(
        key: 'notifications_enabled',
        value: enabled,
      );
      emit(NotificationSettingChanged(enabled));
      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to update notification settings')));
    }
  }

  // Toggle Chatbot
  Future<void> toggleChatbot(bool enabled) async {
    try {
      _isChatbotEnabled = enabled;
      await CacheService.setData(
        key: 'chatbot_enabled',
        value: enabled,
      );
      emit(ChatbotSettingChanged(enabled));
      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to update chatbot settings')));
    }
  }

  // Toggle Child Mode
  Future<void> toggleChildMode(bool enabled) async {
    try {
      _isChildModeActive = enabled;
      await CacheService.setData(
        key: 'child_mode_active',
        value: enabled,
      );
      emit(ChildModeSettingChanged(enabled));
      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to update child mode settings')));
    }
  }

  // Change Language
  Future<void> changeLanguage(String languageCode) async {
    try {
      _selectedLanguage = languageCode;
      await CacheService.setData(
        key: 'selected_language',
        value: languageCode,
      );
      emit(LanguageSettingChanged(languageCode));
      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to update language settings')));
    }
  }

  // Backup Data
  Future<void> createBackup() async {
    emit(SettingsLoading());
    try {
      // Implement backup logic here
      // This could involve uploading user data to cloud storage
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      emit(BackupCreated());
      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to create backup')));
    }
  }

  // Restore Data
  Future<void> restoreBackup() async {
    emit(SettingsLoading());
    try {
      // Implement restore logic here
      // This could involve downloading user data from cloud storage
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      emit(BackupRestored());
      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to restore backup')));
    }
  }

  // Send Feedback
  Future<void> sendFeedback(String feedback) async {
    emit(SettingsLoading());
    try {
      // Implement feedback sending logic here
      // This could involve sending feedback to backend API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      emit(FeedbackSent());
      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to send feedback')));
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    emit(SettingsLoading());
    try {
      // Implement account deletion logic here
      // This should involve API call to delete user account
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Clear all cached data
       CacheService.clearItems();

      emit(AccountDeleted());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to delete account')));
    }
  }

  // Logout
  Future<void> logout() async {
    emit(SettingsLoading());
    try {
      // // Clear user session data but keep app settings
      // await CacheService.removeData(key: CacheKeys.userId);
      // await CacheService.removeData(key: CacheKeys.userName);
      // await CacheService.removeData(key: CacheKeys.userEmail);
      // await CacheService.removeData(key: CacheKeys.userPhoto);
      // await CacheService.removeData(key: CacheKeys.authToken);

      emit(LoggedOut());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to logout')));
    }
  }

  // Reset all settings to default
  Future<void> resetToDefaults() async {
    try {
      _areNotificationsEnabled = true;
      _isChatbotEnabled = true;
      _isChildModeActive = false;
      _selectedLanguage = 'ar';

      await CacheService.setData(key: 'notifications_enabled', value: true);
      await CacheService.setData(key: 'chatbot_enabled', value: true);
      await CacheService.setData(key: 'child_mode_active', value: false);
      await CacheService.setData(key: 'selected_language', value: 'ar');

      emit(SettingsReset());
      emit(SettingsSuccess());
    } catch (e) {
      emit(SettingsFailure(Exception('Failed to reset settings')));
    }
  }

  // Get app version info
  Map<String, String> getAppInfo() {
    return {
      'version': '1.0.0',
      'build': '1',
      'developer': 'Wise Child Team',
    };
  }
}