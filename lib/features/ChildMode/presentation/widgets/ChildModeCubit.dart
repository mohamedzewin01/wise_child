// lib/features/ChildMode/presentation/bloc/ChildMode_cubit.dart

import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import '../../domain/useCases/ChildMode_useCase_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/ChildMode/presentation/bloc/ChildMode_cubit.dart';
import 'package:wise_child/features/ChildMode/presentation/pages/ChildMode_page.dart';
import 'package:wise_child/features/Settings/presentation/widgets/modern_settings_card.dart';


@injectable
class ChildModeCubit extends Cubit<ChildModeState> {
  ChildModeCubit(this._childmodeUseCaseRepo) : super(ChildModeInitial());
  final ChildModeUseCaseRepo _childmodeUseCaseRepo;

  // Child Mode Properties
  bool _isChildModeActive = false;
  String _childModePin = '1234';
  int _selectedChildId = -1;
  List<String> _allowedStoryCategories = [];
  int _dailyTimeLimit = 60; // بالدقائق
  int _usedTimeToday = 0;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Getters
  bool get isChildModeActive => _isChildModeActive;
  String get childModePin => _childModePin;
  int get selectedChildId => _selectedChildId;
  List<String> get allowedStoryCategories => _allowedStoryCategories;
  int get dailyTimeLimit => _dailyTimeLimit;
  int get usedTimeToday => _usedTimeToday;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  // Initialize Child Mode settings
  Future<void> initializeChildMode() async {
    emit(ChildModeLoading());

    try {
      // Load settings from cache
      _isChildModeActive = await CacheService.getData(
        key: 'child_mode_active',
      ) ?? false;

      _childModePin = await CacheService.getData(
        key: 'child_mode_pin',
      ) ?? '1234';

      _selectedChildId = await CacheService.getData(
        key: 'child_mode_selected_child',
      ) ?? -1;

      _allowedStoryCategories = List<String>.from(
        await CacheService.getData(key: 'child_mode_allowed_categories') ?? [],
      );

      _dailyTimeLimit = await CacheService.getData(
        key: 'child_mode_time_limit',
      ) ?? 60;

      _usedTimeToday = await CacheService.getData(
        key: 'child_mode_used_time_${_getTodayKey()}',
      ) ?? 0;

      _soundEnabled = await CacheService.getData(
        key: 'child_mode_sound',
      ) ?? true;

      _vibrationEnabled = await CacheService.getData(
        key: 'child_mode_vibration',
      ) ?? true;

      emit(ChildModeSuccess());
    } catch (e) {
      emit(ChildModeFailure(Exception('Failed to load child mode settings')));
    }
  }

  // Activate Child Mode
  Future<void> activateChildMode({
    required int childId,
    List<String>? allowedCategories,
    int? timeLimit,
  }) async {
    try {
      _isChildModeActive = true;
      _selectedChildId = childId;

      if (allowedCategories != null) {
        _allowedStoryCategories = allowedCategories;
      }

      if (timeLimit != null) {
        _dailyTimeLimit = timeLimit;
      }

      await _saveSettings();
      emit(ChildModeActivated(childId));
    } catch (e) {
      emit(ChildModeFailure(Exception('Failed to activate child mode')));
    }
  }

  // Deactivate Child Mode
  Future<void> deactivateChildMode() async {
    try {
      _isChildModeActive = false;
      _selectedChildId = -1;

      await _saveSettings();
      emit(ChildModeDeactivated());
    } catch (e) {
      emit(ChildModeFailure(Exception('Failed to deactivate child mode')));
    }
  }

  // Update PIN
  Future<void> updatePin(String newPin) async {
    try {
      _childModePin = newPin;
      await CacheService.setData(key: 'child_mode_pin', value: newPin);
      emit(ChildModePinUpdated());
    } catch (e) {
      emit(ChildModeFailure(Exception('Failed to update PIN')));
    }
  }

  // Verify PIN
  bool verifyPin(String enteredPin) {
    return enteredPin == _childModePin;
  }

  // Update time usage
  Future<void> updateTimeUsage(int minutes) async {
    try {
      _usedTimeToday += minutes;
      await CacheService.setData(
        key: 'child_mode_used_time_${_getTodayKey()}',
        value: _usedTimeToday,
      );

      if (_usedTimeToday >= _dailyTimeLimit) {
        emit(ChildModeTimeLimitReached());
      } else {
        emit(ChildModeTimeUpdated(_usedTimeToday, _dailyTimeLimit));
      }
    } catch (e) {
      emit(ChildModeFailure(Exception('Failed to update time usage')));
    }
  }

  // Check if time limit reached
  bool isTimeLimitReached() {
    return _usedTimeToday >= _dailyTimeLimit;
  }

  // Get remaining time
  int getRemainingTime() {
    return math.max(0, _dailyTimeLimit - _usedTimeToday);
  }

  // Update settings
  Future<void> updateSettings({
    List<String>? allowedCategories,
    int? timeLimit,
    bool? sound,
    bool? vibration,
  }) async {
    try {
      if (allowedCategories != null) {
        _allowedStoryCategories = allowedCategories;
      }

      if (timeLimit != null) {
        _dailyTimeLimit = timeLimit;
      }

      if (sound != null) {
        _soundEnabled = sound;
      }

      if (vibration != null) {
        _vibrationEnabled = vibration;
      }

      await _saveSettings();
      emit(ChildModeSettingsUpdated());
    } catch (e) {
      emit(ChildModeFailure(Exception('Failed to update settings')));
    }
  }

  // Reset daily usage (call this at midnight)
  Future<void> resetDailyUsage() async {
    try {
      _usedTimeToday = 0;
      await CacheService.setData(
        key: 'child_mode_used_time_${_getTodayKey()}',
        value: 0,
      );
      emit(ChildModeDailyUsageReset());
    } catch (e) {
      emit(ChildModeFailure(Exception('Failed to reset daily usage')));
    }
  }

  // Private helper methods
  Future<void> _saveSettings() async {
    await Future.wait([
      CacheService.setData(key: 'child_mode_active', value: _isChildModeActive),
      CacheService.setData(key: 'child_mode_selected_child', value: _selectedChildId),
      CacheService.setData(key: 'child_mode_allowed_categories', value: _allowedStoryCategories),
      CacheService.setData(key: 'child_mode_time_limit', value: _dailyTimeLimit),
      CacheService.setData(key: 'child_mode_sound', value: _soundEnabled),
      CacheService.setData(key: 'child_mode_vibration', value: _vibrationEnabled),
    ]);
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}

// lib/features/ChildMode/presentation/bloc/ChildMode_state.dart


@immutable
sealed class ChildModeState {}

final class ChildModeInitial extends ChildModeState {}

final class ChildModeLoading extends ChildModeState {}

final class ChildModeSuccess extends ChildModeState {}

final class ChildModeFailure extends ChildModeState {
  final Exception exception;
  ChildModeFailure(this.exception);
}

// Specific states
final class ChildModeActivated extends ChildModeState {
  final int childId;
  ChildModeActivated(this.childId);
}

final class ChildModeDeactivated extends ChildModeState {}

final class ChildModePinUpdated extends ChildModeState {}

final class ChildModeTimeUpdated extends ChildModeState {
  final int usedTime;
  final int totalTime;
  ChildModeTimeUpdated(this.usedTime, this.totalTime);
}

final class ChildModeTimeLimitReached extends ChildModeState {}

final class ChildModeSettingsUpdated extends ChildModeState {}

final class ChildModeDailyUsageReset extends ChildModeState {}

// ===========================================
// Settings Integration
// ===========================================

// lib/features/Settings/presentation/widgets/child_mode_settings_section.dart


class ChildModeSettingsSection extends StatelessWidget {
  const ChildModeSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildModeCubit, ChildModeState>(
      builder: (context, state) {
        final cubit = context.read<ChildModeCubit>();

        return ModernSettingsCard(
          title: 'وضع الأطفال',
          icon: Icons.child_care_rounded,
          iconColor: Colors.green,
          children: [
            // تفعيل/إيقاف وضع الأطفال
            ModernSettingsRow(
              icon: Icons.child_friendly_rounded,
              title: 'تفعيل وضع الأطفال',
              subtitle: cubit.isChildModeActive
                  ? 'نشط - واجهة آمنة للأطفال'
                  : 'غير نشط - الوضع العادي',
              trailing: AnimatedSettingsSwitch(
                value: cubit.isChildModeActive,
                onChanged: (value) {
                  if (value) {
                    _showActivationDialog(context);
                  } else {
                    _showDeactivationDialog(context);
                  }
                },
                activeColor: Colors.green,
              ),
            ),

            if (cubit.isChildModeActive) ...[
              const Divider(height: 1, indent: 72),

              // الدخول لوضع الأطفال
              ModernSettingsRow(
                icon: Icons.play_circle_filled_rounded,
                title: 'الدخول لوضع الأطفال',
                subtitle: 'انتقال فوري للواجهة الآمنة',
                iconBackgroundColor: Colors.green.shade50,
                iconColor: Colors.green.shade600,
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () => _enterChildMode(context),
              ),

              const Divider(height: 1, indent: 72),

              // إعدادات وضع الأطفال
              ModernSettingsRow(
                icon: Icons.settings_rounded,
                title: 'إعدادات وضع الأطفال',
                subtitle: 'الوقت المحدد، الفئات المسموحة، الرقم السري',
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () => _showChildModeSettings(context),
              ),

              const Divider(height: 1, indent: 72),

              // الإحصائيات
              ModernSettingsRow(
                icon: Icons.timeline_rounded,
                title: 'إحصائيات الاستخدام',
                subtitle: 'الوقت المستخدم اليوم: ${cubit.usedTimeToday} من ${cubit.dailyTimeLimit} دقيقة',
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () => _showUsageStats(context),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showActivationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.child_care, color: Colors.green),
            const SizedBox(width: 8),
            Text('تفعيل وضع الأطفال'),
          ],
        ),
        content: Text(
          'سيتم تفعيل واجهة آمنة ومبسطة للأطفال مع حماية برقم سري.\n\nالرقم السري الافتراضي: 1234',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChildModeCubit>().activateChildMode(childId: 1);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تفعيل وضع الأطفال بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('تفعيل'),
          ),
        ],
      ),
    );
  }

  void _showDeactivationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Text('إيقاف وضع الأطفال'),
          ],
        ),
        content: Text('هل أنت متأكد من إيقاف وضع الأطفال؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChildModeCubit>().deactivateChildMode();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إيقاف وضع الأطفال'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('إيقاف'),
          ),
        ],
      ),
    );
  }

  void _enterChildMode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChildModePage(),
        fullscreenDialog: true,
      ),
    );
  }

  void _showChildModeSettings(BuildContext context) {
    // TODO: Navigate to child mode settings page
  }

  void _showUsageStats(BuildContext context) {
    // TODO: Navigate to usage statistics page
  }
}