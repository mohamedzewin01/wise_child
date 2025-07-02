import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/ChildMode/presentation/pages/ChildMode_page.dart';
import 'package:wise_child/features/EditProfile/presentation/pages/EditProfile_page.dart';
import 'package:wise_child/features/Settings/presentation/bloc/user_cubit/user_details_cubit.dart';
import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:wise_child/features/Settings/presentation/widgets/child_mode_setup_widget.dart';
import 'package:wise_child/localization/locale_cubit.dart';
import '../../../../core/di/di.dart';
import '../bloc/Settings_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<SettingsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: EnhancedSettingsScreen(),
    );
  }
}

class EnhancedSettingsScreen extends StatefulWidget {
  const EnhancedSettingsScreen({super.key});

  @override
  State<EnhancedSettingsScreen> createState() => _EnhancedSettingsScreenState();
}

class _EnhancedSettingsScreenState extends State<EnhancedSettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Settings State
  bool _areNotificationsOn = true;
  bool _isChatbotEnabled = true;
  bool _isChildModeActive = false;
  String _selectedLanguage = 'العربية';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // تحميل إعدادات وضع الأطفال
    _loadChildModeSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // تحميل حالة وضع الأطفال من SharedPreferences
  Future<void> _loadChildModeSettings() async {
    try {
      final isChildModeActive =
          await CacheService.getData(key: 'child_mode_active') ?? false;

      if (mounted) {
        setState(() {
          _isChildModeActive = isChildModeActive;
        });
      }
    } catch (e) {
      // في حالة الخطأ، اجعل الوضع غير نشط
      if (mounted) {
        setState(() {
          _isChildModeActive = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userImage = CacheService.getData(key: CacheKeys.userPhoto);
    String userName =
        '${CacheService.getData(key: CacheKeys.userFirstName) ?? ''} ${CacheService.getData(key: CacheKeys.userLastName) ?? ''}'
            .trim();
    if (userName.isEmpty) userName = 'مستخدم';
    String userEmail =
        CacheService.getData(key: CacheKeys.userEmail) ?? 'user@example.com';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced App Bar with Profile
          _buildSliverAppBar(userImage, userName, userEmail),

          // Settings Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // App Settings Section
                    _buildAppSettingsSection(),

                    const SizedBox(height: 24),

                    // Account Settings Section
                    _buildAccountSettingsSection(),

                    const SizedBox(height: 24),

                    // Support & Info Section
                    _buildSupportSection(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(
    String? userImage,
    String userName,
    String userEmail,
  ) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => LayoutCubit.get(context).changeIndex(0),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorManager.primaryColor,
                ColorManager.primaryColor.withOpacity(0.8),
                Colors.purple.shade400,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    Assets.appbarbackgroundJpg,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Profile Content
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Profile Image
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: userImage != null
                            ? CachedNetworkImageProvider(userImage)
                            : null,
                        child: userImage == null
                            ? Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey.shade400,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // User Info
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      userEmail,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return _buildSettingsCard(
      title: 'إعدادات التطبيق',
      icon: Icons.settings_outlined,
      iconColor: Colors.blue,
      children: [
        _buildModernSettingsRow(
          icon: Icons.notifications_outlined,
          title: 'الإشعارات',
          subtitle: 'تلقي توصيات القصص والتحديثات',
          trailing: _buildAnimatedSwitch(_areNotificationsOn, (value) {
            setState(() => _areNotificationsOn = value);
          }),
        ),

        const Divider(height: 1, indent: 72),

        _buildModernSettingsRow(
          icon: Icons.smart_toy_outlined,
          title: 'مساعد الذكي (شات بوت)',
          subtitle: 'تفعيل/إيقاف المساعد الذكي',
          trailing: _buildAnimatedSwitch(_isChatbotEnabled, (value) {
            setState(() => _isChatbotEnabled = value);
            LayoutCubit.get(context).setChatbotEnabled(value);
          }),
        ),

        const Divider(height: 1, indent: 72),

        _buildModernSettingsRow(
          icon: Icons.child_care_outlined,
          title: 'وضع الأطفال',
          subtitle: _isChildModeActive
              ? 'نشط - واجهة مبسطة للأطفال'
              : 'غير نشط - واجهة عادية',
          trailing: _buildAnimatedSwitch(_isChildModeActive, (value) {
            _showChildModeDialog(value);
          }),
        ),

        const Divider(height: 1, indent: 72),

        _buildModernSettingsRow(
          icon: Icons.language_outlined,
          title: 'اللغة',
          subtitle: 'اختر لغة التطبيق',
          trailing: _buildLanguageSelector(),
        ),
      ],
    );
  }

  Widget _buildAccountSettingsSection() {
    return _buildSettingsCard(
      title: 'الحساب',
      icon: Icons.account_circle_outlined,
      iconColor: Colors.green,
      children: [
        _buildModernSettingsRow(
          icon: Icons.edit_outlined,
          title: 'تعديل الملف الشخصي',
          subtitle: 'تحديث بياناتك الشخصية',
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfilePage()),
            );
          },
        ),

        const Divider(height: 1, indent: 72),

        _buildModernSettingsRow(
          icon: Icons.security_outlined,
          title: 'الخصوصية والأمان',
          subtitle: 'إعدادات الحماية والخصوصية',
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            // Navigate to privacy settings
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSettingsCard(
      title: 'الدعم والمعلومات',
      icon: Icons.help_outline,
      iconColor: Colors.orange,
      children: [
        _buildModernSettingsRow(
          icon: Icons.help_center_outlined,
          title: 'مركز المساعدة',
          subtitle: 'الأسئلة الشائعة والدعم',
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            // Navigate to help center
          },
        ),

        const Divider(height: 1, indent: 72),

        _buildModernSettingsRow(
          icon: Icons.feedback_outlined,
          title: 'إرسال ملاحظة، شكوى أو اقتراح',
          subtitle: 'نرحب بكل ملاحظاتك واقتراحاتك ',
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            _showFeedbackDialog();
          },
        ),

        const Divider(height: 1, indent: 72),

        _buildModernSettingsRow(
          icon: Icons.info_outline,
          title: 'حول التطبيق',
          subtitle: 'الإصدار 1.0.0',
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            _showAboutDialog();
          },
        ),

        const Divider(height: 1, indent: 72),

        _buildDangerousSettingsRow(
          icon: Icons.person_remove_outlined,
          title: 'حذف الحساب',
          subtitle: 'حذف نهائي لجميع البيانات',
          onTap: () {
            _showDeleteAccountDialog();
          },
        ),

        const Divider(height: 1, indent: 72),

        _buildDangerousSettingsRow(
          icon: Icons.logout_outlined,
          title: 'تسجيل الخروج',
          subtitle: 'الخروج من الحساب الحالي',
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: getBoldStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Settings Items
          ...children,
        ],
      ),
    );
  }

  Widget _buildModernSettingsRow({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.grey.shade600, size: 20),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        color: Colors.grey.shade800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: getRegularStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerousSettingsRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.red.shade400, size: 20),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        color: Colors.red.shade600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: getRegularStyle(
                        color: Colors.red.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.red.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSwitch(bool value, ValueChanged<bool> onChanged) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: ColorManager.primaryColor,
        inactiveTrackColor: Colors.grey.shade300,
        inactiveThumbColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          isDense: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
          items: ['العربية', 'English'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: getRegularStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedLanguage = value!);
            if (value == 'English') {
              context.read<LocaleCubit>().changeLanguage('en');
            } else {
              context.read<LocaleCubit>().changeLanguage('ar');
            }
          },
        ),
      ),
    );
  }

  // ===== دوال وضع الأطفال =====

  void _showChildModeDialog(bool isEnabled) {
    if (isEnabled) {
      // إذا كان المستخدم يريد تفعيل وضع الأطفال
      _showChildModeSetupDialog();
    } else {
      // إذا كان المستخدم يريد إيقاف وضع الأطفال
      _showDisableChildModeDialog();
    }
  }

  void _showChildModeSetupDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorManager.primaryColor.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: ChildModeSetupWidget(
            onCancel: () {
              setState(() => _isChildModeActive = false);
              Navigator.pop(context);
            },
            onComplete: (selectedChildId, pin) {
              Navigator.pop(context);
              _completeChildModeSetup(selectedChildId, pin);
            },
          ),
        ),
      ),
    );
  }

  void _showDisableChildModeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.person, color: Colors.orange),
            const SizedBox(width: 8),
            Text('إيقاف وضع الأطفال'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('سيتم العودة للواجهة العادية للتطبيق.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'سيتم الاحتفاظ بالرقم السري المحفوظ',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _isChildModeActive = true);
              Navigator.pop(context);
            },
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              Navigator.pop(context);
              await _disableChildMode();
            },
            child: Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  Future<void> _completeChildModeSetup(int childId, String pin) async {
    try {
      // حفظ بيانات وضع الطفل في SharedPreferences
      await CacheService.setData(key: CacheKeys.childModePin, value: pin);
      await CacheService.setData(
        key: CacheKeys.childModeSelectedChild,
        value: childId,
      );
      await CacheService.setData(key: CacheKeys.childModeActive, value: true);
      setState(() => _isChildModeActive = true);

      if (mounted) {
        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('تم تفعيل وضع الأطفال بنجاح')),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 2),
          ),
        );

        // الانتظار قليلاً ثم الانتقال إلى صفحة وضع الأطفال
        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          // الحصول على اسم الطفل من UserDetailsCubit
          await _navigateToChildMode(childId);
        }
      }
    } catch (e) {
      setState(() => _isChildModeActive = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('حدث خطأ في حفظ الإعدادات')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  // أضف هذه الدالة الجديدة لجلب اسم الطفل والانتقال
  Future<void> _navigateToChildMode(int childId) async {
    String? childName;

    try {
      // جلب بيانات المستخدم للحصول على اسم الطفل
      final userDetailsCubit = getIt.get<UserDetailsCubit>();
      await userDetailsCubit.getUserDetails();

      final state = userDetailsCubit.state;
      if (state is UserDetailsSuccess) {
        final children = state.getUserDetailsEntity?.user?.children ?? [];
        final selectedChild = children.firstWhere(
          (child) => child.idChildren == childId,
        );
        childName = selectedChild.firstName;
      }
    } catch (e) {
      print('Error getting child name: $e');
    }

    if (mounted) {
      // الانتقال إلى صفحة وضع الأطفال مع تأثير انتقال ممتع
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ChildModePage(selectedChildId: childId, childName: childName),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // تأثير انتقال ممتع للأطفال
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.elasticOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 1200),
        ),
      );
    }
  }

  Future<void> _disableChildMode() async {
    try {
      // إيقاف وضع الأطفال
      await CacheService.setData(key: 'child_mode_active', value: false);

      setState(() => _isChildModeActive = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('تم إيقاف وضع الأطفال'),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isChildModeActive = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في إيقاف وضع الأطفال'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ===== باقي الدوال =====

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.backup, color: Colors.blue),
            const SizedBox(width: 8),
            Text('النسخ الاحتياطي'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.cloud_upload),
              title: Text('إنشاء نسخة احتياطية'),
              subtitle: Text('حفظ البيانات في السحابة'),
              onTap: () {
                Navigator.pop(context);
                // Implement backup
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud_download),
              title: Text('استعادة النسخة الاحتياطية'),
              subtitle: Text('استرداد البيانات من السحابة'),
              onTap: () {
                Navigator.pop(context);
                // Implement restore
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();
    String selectedFeedbackType = 'اقتراح'; // القيمة الافتراضية

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6B46C1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.feedback_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'إرسال ملاحظات',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'شاركنا رأيك لتحسين التطبيق',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20),

                // قسم اختيار نوع الملاحظة
                Text(
                  'نوع الملاحظة:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                SizedBox(height: 12),

                // التبويبات الأفقية
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabOption(
                          'شكوى',
                          Icons.report_problem_outlined,
                          Color(0xFFEF4444),
                          selectedFeedbackType == 'شكوى',
                              () => setState(() => selectedFeedbackType = 'شكوى'),
                        ),
                      ),
                      Expanded(
                        child: _buildTabOption(
                          'طلب قصة',
                          Icons.auto_stories_outlined,
                          Color(0xFF10B981),
                          selectedFeedbackType == 'طلب قصة',
                              () => setState(() => selectedFeedbackType = 'طلب قصة'),
                        ),
                      ),
                      Expanded(
                        child: _buildTabOption(
                          'اقتراح',
                          Icons.lightbulb_outline,
                          Color(0xFFF59E0B),
                          selectedFeedbackType == 'اقتراح',
                              () => setState(() => selectedFeedbackType = 'اقتراح'),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // حقل النص
                Text(
                  'تفاصيل الملاحظة:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFD1D5DB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF374151),
                    ),
                    decoration: InputDecoration(
                      hintText: _getHintText(selectedFeedbackType),
                      hintStyle: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // زر الإلغاء
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // زر الإرسال
            ElevatedButton(
              onPressed: () {
                if (feedbackController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('يرجى كتابة ملاحظاتك قبل الإرسال'),
                      backgroundColor: Color(0xFFEF4444),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('تم إرسال ${selectedFeedbackType.toLowerCase()} بنجاح، شكراً لك!'),
                      ],
                    ),
                    backgroundColor: Color(0xFF10B981),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B46C1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.send, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'إرسال',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// دالة مساعدة لبناء تبويبات نوع الملاحظة
  Widget _buildTabOption(
      String title,
      IconData icon,
      Color color,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xFF6B7280),
              size: 18,
            ),
            SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

// دالة للحصول على النص التوضيحي حسب نوع الملاحظة
  String _getHintText(String feedbackType) {
    switch (feedbackType) {
      case 'شكوى':
        return 'اكتب تفاصيل الشكوى أو المشكلة التي واجهتك...';
      case 'طلب قصة':
        return 'اكتب تفاصيل القصة التي تريد إضافتها للتطبيق...';
      case 'اقتراح':
        return 'اكتب اقتراحك لتحسين التطبيق...';
      default:
        return 'اكتب ملاحظاتك هنا...';
    }
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Wise Child',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.child_care,
        size: 48,
        color: ColorManager.primaryColor,
      ),
      children: [
        Text(
          'تطبيق تعليمي تفاعلي للأطفال يساعد في تنمية مهاراتهم وقدراتهم التعليمية.',
        ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text('حذف الحساب'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف حسابك؟ سيتم حذف جميع البيانات نهائياً ولا يمكن استرجاعها.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              CacheService.clearItems();
              await CacheService.setData(
                key: CacheKeys.userActive,
                value: false,
              );

              if (context.mounted) {
                Navigator.of(context).pop(); // إغلاق الـ dialog
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesManager.welcomeScreen,
                      (route) => false, // إزالة جميع الصفحات السابقة من الستاك
                );
              }
            },
            child: Text('حذف الحساب'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق النافذة فقط
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {

               CacheService.clearItems();
              await CacheService.setData(
                key: CacheKeys.userActive,
                value: false,
              );

              if (context.mounted) {
                Navigator.of(context).pop(); // إغلاق الـ dialog
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesManager.welcomeScreen,
                      (route) => false, // إزالة جميع الصفحات السابقة من الستاك
                );
              }
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

}
