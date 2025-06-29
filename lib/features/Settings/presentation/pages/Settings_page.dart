import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:wise_child/assets_manager.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/EditProfile/presentation/pages/EditProfile_page.dart';
import 'package:wise_child/features/layout/presentation/cubit/layout_cubit.dart';

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
    viewModel = getIt.get<SettingsCubit>();
    super.initState();
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? userImage = CacheService.getData(key: CacheKeys.userPhoto);
    String? userName =
        '${CacheService.getData(key: CacheKeys.userFirstName)} ${CacheService.getData(key: CacheKeys.userLastName)}' ??
        'مستخدم';
    String? userEmail =
        CacheService.getData(key: CacheKeys.userEmail) ?? 'user@example.com';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced App Bar with Profile
          _buildSliverAppBar(userImage, userName, userEmail!),

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
            setState(() => _isChildModeActive = value);
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
          title: 'إرسال ملاحظات',
          subtitle: 'شاركنا رأيك لتحسين التطبيق',
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
            _showLogoutDialog();
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

  void _showChildModeDialog(bool isEnabled) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isEnabled ? Icons.child_care : Icons.person,
              color: isEnabled ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(isEnabled ? 'تفعيل وضع الأطفال' : 'إيقاف وضع الأطفال'),
          ],
        ),
        content: Text(
          isEnabled
              ? 'سيتم تغيير واجهة التطبيق لتصبح أكثر بساطة ومناسبة للأطفال مع ألوان زاهية وأيقونات كبيرة.'
              : 'سيتم العودة للواجهة العادية للتطبيق.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _isChildModeActive = !isEnabled);
              Navigator.pop(context);
            },
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEnabled ? 'تم تفعيل وضع الأطفال' : 'تم إيقاف وضع الأطفال',
                  ),
                  backgroundColor: isEnabled ? Colors.green : Colors.orange,
                ),
              );
            },
            child: Text('تأكيد'),
          ),
        ],
      ),
    );
  }

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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('إرسال ملاحظات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('شاركنا رأيك لتحسين التطبيق'),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'اكتب ملاحظاتك هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إرسال ملاحظاتك، شكراً لك!')),
              );
            },
            child: Text('إرسال'),
          ),
        ],
      ),
    );
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
            onPressed: () {
              Navigator.pop(context);
              // Implement account deletion
            },
            child: Text('حذف الحساب'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('تسجيل الخروج'),
        content: Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout
            },
            child: Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

///
