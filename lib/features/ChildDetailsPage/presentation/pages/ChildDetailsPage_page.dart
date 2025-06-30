// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/di/di.dart';
// import '../bloc/ChildDetailsPage_cubit.dart';
//
// class ChildDetailsPagePage extends StatefulWidget {
//   const ChildDetailsPagePage({super.key});
//
//   @override
//   State<ChildDetailsPagePage> createState() => _ChildDetailsPagePageState();
// }
//
// class _ChildDetailsPagePageState extends State<ChildDetailsPagePage> {
//
//   late ChildDetailsPageCubit viewModel;
//
//   @override
//   void initState() {
//     viewModel = getIt.get<ChildDetailsPageCubit>();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: viewModel,
//       child: Scaffold(
//         appBar: AppBar(title: const Text('ChildDetailsPage')),
//         body: const Center(child: Text('Hello ChildDetailsPage')),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/functions/calculate_age.dart';
import 'package:wise_child/core/functions/gender_to_text.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/delete_confirmation_dialog.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/bloc/Children_cubit.dart';
import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/pages/SelectStoriesScreen_page.dart';
import 'package:wise_child/l10n/app_localizations.dart';
import '../../../../localization/locale_cubit.dart';

class ChildDetailsPage extends StatefulWidget {
  final Children child;

  const ChildDetailsPage({
    super.key,
    required this.child,
  });

  @override
  State<ChildDetailsPage> createState() => _ChildDetailsPageState();
}

class _ChildDetailsPageState extends State<ChildDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _heroAnimation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _heroAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutBack,
    );
    _contentAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(_contentAnimation);

    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = LocaleCubit.get(context).state.languageCode;
    final ageString = calculateAgeInYearsAndMonths(
      widget.child.dateOfBirth ?? '',
      languageCode,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Hero Image
          _buildSliverAppBar(),

          // Content
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _contentAnimation,
                child: Column(
                  children: [
                    // Main Info Card
                    _buildMainInfoCard(ageString, languageCode),
                    //
                    // const SizedBox(height: 16),
                    //
                    // // Statistics Cards
                    // _buildStatisticsSection(),
                    //
                    // const SizedBox(height: 16),

                    // // Activities Section
                    // _buildActivitiesSection(),
                    //
                    // const SizedBox(height: 16),

                    // Medical Info Section
                    // _buildMedicalInfoSection(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Floating Action Buttons
      floatingActionButton: _buildFloatingActions(child: widget.child),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: ColorManager.primaryColor,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black87),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_rounded, color: ColorManager.primaryColor),
                    const SizedBox(width: 8),
                    const Text('تعديل البيانات'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_rounded, color: ColorManager.red),
                    const SizedBox(width: 8),
                    const Text('حذف الطفل'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                _handleEditChild();
              } else if (value == 'delete') {
                _handleDeleteChild();
              }
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorManager.primaryColor,
                ColorManager.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: ScaleTransition(
              scale: _heroAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hero Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: AvatarWidget(
                      firstName: widget.child.firstName ?? '',
                      lastName: widget.child.lastName ?? '',
                      backgroundColor: Colors.white,
                      textColor: ColorManager.primaryColor,
                      imageUrl: widget.child.imageUrl,
                      radius: 60.0,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Child Name
                  Text(
                    '${widget.child.firstName} ${widget.child.lastName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainInfoCard(String ageString, String languageCode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.cake_rounded,
            label: 'العمر',
            value: ageString,
            color: Colors.orange,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: widget.child.gender?.toLowerCase() == 'male'
                ? Icons.male_rounded
                : Icons.female_rounded,
            label: 'الجنس',
            value: genderToText(widget.child.gender ?? '', languageCode),
            color: widget.child.gender?.toLowerCase() == 'male'
                ? Colors.blue
                : Colors.pink,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'تاريخ الميلاد',
            value: _formatDate(widget.child.dateOfBirth ?? ''),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإحصائيات',
            style: getBoldStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.psychology_rounded,
                  title: 'الأنشطة',
                  value: '12',
                  subtitle: 'نشاط مكتمل',
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.trending_up_rounded,
                  title: 'التقدم',
                  value: '85%',
                  subtitle: 'معدل الإنجاز',
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الأنشطة الحديثة',
                style: getBoldStyle(
                  color: Colors.black87,
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to activities page
                },
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.gamepad_rounded,
                        color: ColorManager.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'نشاط ${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_information_rounded,
                color: Colors.red.shade400,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'المعلومات الطبية',
                style: getBoldStyle(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMedicalItem('فصيلة الدم', 'O+'),
          _buildMedicalItem('الحساسية', 'لا توجد'),
          _buildMedicalItem('الأدوية', 'لا توجد'),
          _buildMedicalItem('آخر فحص', '2024/01/15'),
        ],
      ),
    );
  }

  Widget _buildMedicalItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions({required Children child}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'edit',
          onPressed: _handleEditChild,
          backgroundColor: ColorManager.primaryColor,
          child: const Icon(Icons.edit_rounded, color: Colors.white),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: 'chat',
          onPressed: () {
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectStoriesScreenPage(child: child),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon( Icons.gamepad_rounded, color: Colors.white),
        ),
      ],
    );
  }

  void _handleEditChild() {
    // Navigate to edit child page
    // context.read<ChildrenCubit>().editChild(widget.child);
  }
  void _handleDeleteChild() {
    DeleteConfirmationDialog.show(
      context,
      childName: '${widget.child.firstName} ${widget.child.lastName}',
      onConfirm: () async {
        try {
          final cubit = context.read<ChildrenCubit>();
          await cubit.deleteChild(widget.child.idChildren!);
        } catch (e) {

        return;
        }

        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate deletion
        }
      },
      onCancel: () {},
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'غير محدد';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}