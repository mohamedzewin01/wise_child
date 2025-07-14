// مدير الشرح التفاعلي مع إعدادات متقدمة
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/core/resources/color_manager.dart';

class ShowcaseManager {
  static const String _homeShowcaseKey = 'home_showcase_seen';
  static const String _showcaseCountKey = 'showcase_count';
  static const String _lastShowcaseDateKey = 'last_showcase_date';
  static const String _showcasePreferencesKey = 'showcase_preferences';

  // فحص إذا كان المستخدم شاهد الشرح
  static bool hasSeenShowcase(String pageKey) {
    return CacheService.getData(key: '${pageKey}_showcase_seen') ?? false;
  }

  // تسجيل أن المستخدم شاهد الشرح
  static void markShowcaseAsSeen(String pageKey) {
    CacheService.setData(key: '${pageKey}_showcase_seen', value: true);
    _incrementShowcaseCount();
    _updateLastShowcaseDate();
  }

  // إعادة تعيين الشرح
  static void resetShowcase(String pageKey) {
    CacheService.setData(key: '${pageKey}_showcase_seen', value: false);
  }

  // إعادة تعيين جميع الشروحات
  static void resetAllShowcases() {
    final pages = ['home', 'stories', 'profile', 'categories'];
    for (String page in pages) {
      resetShowcase(page);
    }
    CacheService.setData(key: _showcaseCountKey, value: 0);
  }

  // الحصول على عدد مرات مشاهدة الشرح
  static int getShowcaseCount() {
    return CacheService.getData(key: _showcaseCountKey) ?? 0;
  }

  // زيادة عدد مرات المشاهدة
  static void _incrementShowcaseCount() {
    final currentCount = getShowcaseCount();
    CacheService.setData(key: _showcaseCountKey, value: currentCount + 1);
  }

  // تحديث تاريخ آخر مشاهدة
  static void _updateLastShowcaseDate() {
    CacheService.setData(
      key: _lastShowcaseDateKey,
      value: DateTime.now().millisecondsSinceEpoch,
    );
  }

  // فحص إذا كان يجب إظهار نصائح متقدمة
  static bool shouldShowAdvancedTips() {
    return getShowcaseCount() >= 3;
  }

  // إعدادات الشرح
  static ShowcasePreferences getShowcasePreferences() {
    final prefs = CacheService.getData(key: _showcasePreferencesKey);
    if (prefs != null) {
      return ShowcasePreferences.fromMap(Map<String, dynamic>.from(prefs));
    }
    return ShowcasePreferences.defaultSettings();
  }

  // حفظ إعدادات الشرح
  static void saveShowcasePreferences(ShowcasePreferences preferences) {
    CacheService.setData(key: _showcasePreferencesKey, value: preferences.toMap());
  }

  // بناء الشرح المخصص
  static Widget buildCustomShowcase({
    required GlobalKey key,
    required String title,
    required String description,
    required Widget child,
    String? emoji,
    List<String>? features,
    String? tip,
    Color? backgroundColor,
    bool showSkipButton = true,
  }) {
    final preferences = getShowcasePreferences();

    return Showcase.withWidget(
      key: key,
      height: _calculateTooltipHeight(description, features, tip),
      width: 320,
      container: CustomShowcaseTooltip(
        title: title,
        description: description,
        emoji: emoji,
        features: features,
        tip: tip,
        backgroundColor: backgroundColor ?? ColorManager.primaryColor,
        showSkipButton: showSkipButton,
        animationEnabled: preferences.animationEnabled,
        soundEnabled: preferences.soundEnabled,
      ),
      child: child,
    );
  }

  // حساب ارتفاع التولتيب
  static double _calculateTooltipHeight(String description, List<String>? features, String? tip) {
    double baseHeight = 150;
    baseHeight += (description.length / 50) * 20; // 20 pixels per ~50 characters
    if (features != null) baseHeight += features.length * 25;
    if (tip != null) baseHeight += 40;
    return baseHeight.clamp(150, 400);
  }

  // بدء الشرح التفاعلي
  static void startShowcase(
      BuildContext context,
      List<GlobalKey> keys,
      String pageKey,
      {VoidCallback? onComplete}
      ) {
    if (!hasSeenShowcase(pageKey)) {
      ShowCaseWidget.of(context).startShowCase(keys);
    }
  }

  // عرض إعدادات الشرح
  static void showShowcaseSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ShowcaseSettingsSheet(),
    );
  }
}

// نموذج إعدادات الشرح
class ShowcasePreferences {
  final bool autoStart;
  final bool animationEnabled;
  final bool soundEnabled;
  final double animationSpeed;
  final String preferredLanguage;
  final bool showTips;
  final bool vibrationEnabled;

  ShowcasePreferences({
    required this.autoStart,
    required this.animationEnabled,
    required this.soundEnabled,
    required this.animationSpeed,
    required this.preferredLanguage,
    required this.showTips,
    required this.vibrationEnabled,
  });

  factory ShowcasePreferences.defaultSettings() {
    return ShowcasePreferences(
      autoStart: true,
      animationEnabled: true,
      soundEnabled: false,
      animationSpeed: 1.0,
      preferredLanguage: 'ar',
      showTips: true,
      vibrationEnabled: true,
    );
  }

  factory ShowcasePreferences.fromMap(Map<String, dynamic> map) {
    return ShowcasePreferences(
      autoStart: map['autoStart'] ?? true,
      animationEnabled: map['animationEnabled'] ?? true,
      soundEnabled: map['soundEnabled'] ?? false,
      animationSpeed: map['animationSpeed']?.toDouble() ?? 1.0,
      preferredLanguage: map['preferredLanguage'] ?? 'ar',
      showTips: map['showTips'] ?? true,
      vibrationEnabled: map['vibrationEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'autoStart': autoStart,
      'animationEnabled': animationEnabled,
      'soundEnabled': soundEnabled,
      'animationSpeed': animationSpeed,
      'preferredLanguage': preferredLanguage,
      'showTips': showTips,
      'vibrationEnabled': vibrationEnabled,
    };
  }

  ShowcasePreferences copyWith({
    bool? autoStart,
    bool? animationEnabled,
    bool? soundEnabled,
    double? animationSpeed,
    String? preferredLanguage,
    bool? showTips,
    bool? vibrationEnabled,
  }) {
    return ShowcasePreferences(
      autoStart: autoStart ?? this.autoStart,
      animationEnabled: animationEnabled ?? this.animationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      showTips: showTips ?? this.showTips,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

// التولتيب المخصص للشرح
class CustomShowcaseTooltip extends StatefulWidget {
  final String title;
  final String description;
  final String? emoji;
  final List<String>? features;
  final String? tip;
  final Color backgroundColor;
  final bool showSkipButton;
  final bool animationEnabled;
  final bool soundEnabled;

  const CustomShowcaseTooltip({
    super.key,
    required this.title,
    required this.description,
    this.emoji,
    this.features,
    this.tip,
    required this.backgroundColor,
    this.showSkipButton = true,
    this.animationEnabled = true,
    this.soundEnabled = false,
  });

  @override
  State<CustomShowcaseTooltip> createState() => _CustomShowcaseTooltipState();
}

class _CustomShowcaseTooltipState extends State<CustomShowcaseTooltip>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    if (widget.animationEnabled) {
      _startAnimations();
    }
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticInOut,
    ));
  }

  void _startAnimations() {
    _slideController.forward();
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: widget.animationEnabled ? _bounceAnimation :
            const AlwaysStoppedAnimation(1.0),
            child: _buildTooltipContent(),
          ),
        );
      },
    );
  }

  Widget _buildTooltipContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 12),

          // Description
          _buildDescription(),

          // Features
          if (widget.features != null) ...[
            const SizedBox(height: 12),
            _buildFeatures(),
          ],

          // Tip
          if (widget.tip != null) ...[
            const SizedBox(height: 12),
            _buildTip(),
          ],

          // Actions
          const SizedBox(height: 16),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (widget.emoji != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.emoji!,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        if (widget.showSkipButton)
          IconButton(
            onPressed: () => ShowCaseWidget.of(context).dismiss(),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
          ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.description,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontFamily: 'Cairo',
        height: 1.4,
      ),
    );
  }

  Widget _buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.features!.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  feature,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTip() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb,
            color: Colors.white.withOpacity(0.9),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.tip!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Progress indicator (if part of a sequence)
        _buildProgressIndicator(),

        // Action buttons
        Row(
          children: [
            if (widget.showSkipButton)
              TextButton(
                onPressed: () => ShowCaseWidget.of(context).dismiss(),
                child: Text(
                  'تخطي الكل',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => ShowCaseWidget.of(context).next(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: widget.backgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'التالي',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    // This would need integration with ShowcaseWidget to show actual progress
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.white.withOpacity(0.8),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '1 من 5',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// شاشة إعدادات الشرح
class ShowcaseSettingsSheet extends StatefulWidget {
  @override
  State<ShowcaseSettingsSheet> createState() => _ShowcaseSettingsSheetState();
}

class _ShowcaseSettingsSheetState extends State<ShowcaseSettingsSheet> {
  late ShowcasePreferences _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = ShowcaseManager.getShowcasePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) =>
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: ColorManager.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'إعدادات الشرح التفاعلي',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Settings
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      _buildSettingItem(
                        icon: Icons.play_circle,
                        title: 'بدء تلقائي',
                        subtitle: 'بدء الشرح تلقائياً عند دخول الصفحة لأول مرة',
                        value: _preferences.autoStart,
                        onChanged: (value) {
                          setState(() {
                            _preferences = _preferences.copyWith(
                                autoStart: value);
                          });
                        },
                      ),

                      _buildSettingItem(
                        icon: Icons.animation,
                        title: 'الحركات المتحركة',
                        subtitle: 'تفعيل الحركات المتحركة في الشرح',
                        value: _preferences.animationEnabled,
                        onChanged: (value) {
                          setState(() {
                            _preferences = _preferences.copyWith(
                                animationEnabled: value);
                          });
                        },
                      ),

                      _buildSettingItem(
                        icon: Icons.volume_up,
                        title: 'الأصوات',
                        subtitle: 'تشغيل الأصوات أثناء الشرح',
                        value: _preferences.soundEnabled,
                        onChanged: (value) {
                          setState(() {
                            _preferences = _preferences.copyWith(
                                soundEnabled: value);
                          });
                        },
                      ),

                      _buildSettingItem(
                        icon: Icons.vibration,
                        title: 'الاهتزاز',
                        subtitle: 'اهتزاز الجهاز عند التنقل بين الخطوات',
                        value: _preferences.vibrationEnabled,
                        onChanged: (value) {
                          setState(() {
                            _preferences = _preferences.copyWith(
                                vibrationEnabled: value);
                          });
                        },
                      ),

                      _buildSettingItem(
                        icon: Icons.tips_and_updates,
                        title: 'النصائح الإضافية',
                        subtitle: 'عرض نصائح مفيدة أثناء الشرح',
                        value: _preferences.showTips,
                        onChanged: (value) {
                          setState(() {
                            _preferences = _preferences.copyWith(
                                showTips: value);
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Speed Setting
                      _buildSpeedSetting(),

                      const SizedBox(height: 20),

                      // Reset Section
                      _buildResetSection(),

                      const SizedBox(height: 20),

                      // Statistics
                      _buildStatistics(),
                    ],
                  ),
                ),

                // Save Button
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'حفظ الإعدادات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: value ? ColorManager.primaryColor.withOpacity(0.1) : Colors
                  .grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: value ? ColorManager.primaryColor : Colors.grey[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ColorManager.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedSetting() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.speed,
                  color: ColorManager.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سرعة الحركة',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'تحكم في سرعة الحركات المتحركة',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('بطيء',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Expanded(
                child: Slider(
                  value: _preferences.animationSpeed,
                  min: 0.5,
                  max: 2.0,
                  divisions: 6,
                  label: '${_preferences.animationSpeed.toStringAsFixed(1)}x',
                  activeColor: ColorManager.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _preferences =
                          _preferences.copyWith(animationSpeed: value);
                    });
                  },
                ),
              ),
              Text('سريع',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResetSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.refresh, color: Colors.red[600], size: 20),
              const SizedBox(width: 12),
              Text(
                'إعادة تعيين',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'إعادة تعيين جميع الشروحات لإظهارها مرة أخرى',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _resetAllShowcases,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red[600],
                side: BorderSide(color: Colors.red[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('إعادة تعيين جميع الشروحات'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    final count = ShowcaseManager.getShowcaseCount();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.blue[600], size: 20),
              const SizedBox(width: 12),
              Text(
                'إحصائيات الشرح',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatItem('عدد المشاهدات', '$count'),
              const SizedBox(width: 20),
              _buildStatItem('المستوى', count >= 3 ? 'متقدم' : 'مبتدئ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
      ],
    );
  }

  void _saveSettings() {
    ShowcaseManager.saveShowcasePreferences(_preferences);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ الإعدادات بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetAllShowcases() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('تأكيد إعادة التعيين'),
            content: const Text(
              'هل أنت متأكد من إعادة تعيين جميع الشروحات؟ سيتم إظهار الشرح مرة أخرى في جميع الصفحات.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  ShowcaseManager.resetAllShowcases();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إعادة تعيين جميع الشروحات'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                child: const Text('تأكيد'),
              ),
            ],
          ),
    );
  }
}