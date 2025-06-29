import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
import 'package:wise_child/core/widgets/custom_text_form.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/addSisters_or_brother_sheet.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/add_best_playmate.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/child_image.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/friends_list_section.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/gender_selector.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/set_date_of_birth.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/siblings_list_section.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/best_playmates.dart';
import '../../../../core/di/di.dart';
import '../bloc/NewChildren_cubit.dart';

class NewChildrenPage extends StatefulWidget {
  const NewChildrenPage({super.key});

  @override
  State<NewChildrenPage> createState() => _NewChildrenPageState();
}

class _NewChildrenPageState extends State<NewChildrenPage> {
  late NewChildrenCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<NewChildrenCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: ProfileFormScreen(viewModel: viewModel),
    );
  }
}

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key, required this.viewModel});

  final NewChildrenCubit viewModel;

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;
  int _currentStep = 0;
  final int _totalSteps = 6; // زيادة العدد لتشمل Best Playmate

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _pageController = PageController();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _addPerson(List<Siblings> list, String type) async {
    final result = await showDialog<Siblings>(
      context: context,
      builder: (_) => AddSistersOrBrotherSheet(personType: type),
    );

    if (result != null) {
      setState(() {
        list.add(result);
      });
    }
  }

  Future<void> _addFriends(List<Friends> list, String type) async {
    final result = await showDialog<Friends>(
      context: context,
      builder: (_) => AddFriendsSheet(personType: type),
    );

    if (result != null) {
      setState(() {
        list.add(result);
      });
    }
  }

  Future<void> _addBestPlaymate(List<BestPlaymate> list, String type) async {
    final result = await showDialog<BestPlaymate>(
      context: context,
      builder: (_) => AddBestPlaymate(personType: type),
    );

    if (result != null) {
      setState(() {
        list.add(result);
      });
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // المعلومات الأساسية
        return widget.viewModel.firstNameController.text.isNotEmpty &&
            widget.viewModel.lastNameController.text.isNotEmpty;
      case 1: // تاريخ الميلاد والجنس
        return widget.viewModel.birthDate != null;
      case 2: // الأشقاء (اختياري)
        return true;
      case 3: // الأصدقاء (اختياري)
        return true;
      case 4: // Best Playmate (مطلوب)
        return widget.viewModel.bestPlaymates.isNotEmpty;
      case 5: // المراجعة النهائية
        return true;
      default:
        return false;
    }
  }

  String _getStepErrorMessage() {
    switch (_currentStep) {
      case 0:
        return 'يرجى إدخال الاسم الأول واسم العائلة';
      case 1:
        return 'يرجى تحديد تاريخ الميلاد';
      case 4:
        return 'يرجى إضافة صديق مفضل واحد على الأقل';
      default:
        return 'يرجى إكمال المعلومات المطلوبة';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        // appBar: _buildAppBar(),
        body: Column(
          children: [
            CustomAppBarApp(
              title: 'اضافة طفل جديد',
              subtitle: 'قم باضافة طقلك الجديد',
              backFunction: () => Navigator.pop(context),
            ),
            _buildProgressIndicator(),
            Expanded(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Form(
                      key: _formKey,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() => _currentStep = index);
                        },
                        children: [
                          _buildBasicInfoStep(),
                          _buildDateAndGenderStep(),
                          _buildSiblingsStep(),
                          _buildFriendsStep(),
                          _buildBestPlaymateStep(),
                          _buildReviewStep(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey.shade700,
            size: 20,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'إضافة طفل جديد',
        style: getBoldStyle(color: Colors.grey.shade800, fontSize: 20),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressIndicator() {
    List<String> stepTitles = [
      'المعلومات الأساسية',
      'التاريخ والجنس',
      'الأشقاء',
      'الأصدقاء',
      'الصديق المفضل', // مطلوب
      'المراجعة',
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress Bar
          Row(
            children: List.generate(_totalSteps, (index) {
              final isActive = index <= _currentStep;
              final isCompleted = index < _currentStep;
              final isRequired = index == 4; // Best Playmate مطلوب

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isActive
                              ? (isRequired
                                    ? Colors.orange.shade400
                                    : ColorManager.primaryColor)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < _totalSteps - 1) const SizedBox(width: 8),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الخطوة ${_currentStep + 1} من $_totalSteps',
                    style: getSemiBoldStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    stepTitles[_currentStep],
                    style: getRegularStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  if (_currentStep == 4) // Best Playmate Step
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Text(
                        'مطلوب *',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                style: getBoldStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStepCard(
            title: 'المعلومات الأساسية',
            subtitle: 'أدخل اسم الطفل وصورته الشخصية',
            icon: Icons.person_outline,
            isRequired: true,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const ChangeChildrenImage(),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextForm(
                        controller: widget.viewModel.firstNameController,
                        hintText: 'الاسم الأول *',
                        prefixIcon: Icon(Icons.person),
                        validator: (value) =>
                            value!.isEmpty ? 'الرجاء إدخال الاسم الأول' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextForm(
                        controller: widget.viewModel.lastNameController,
                        hintText: 'اسم العائلة *',
                        prefixIcon: Icon(Icons.person_outline),
                        validator: (value) =>
                            value!.isEmpty ? 'الرجاء إدخال اسم العائلة' : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndGenderStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStepCard(
            title: 'تاريخ الميلاد والجنس',
            subtitle: 'حدد تاريخ ميلاد الطفل وجنسه',
            icon: Icons.cake_outlined,
            isRequired: true,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const SetDateOfBirth(),
                const SizedBox(height: 24),
                const GenderToggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSiblingsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStepCard(
            title: 'الأشقاء',
            subtitle: 'أضف معلومات الأشقاء (اختياري)',
            icon: Icons.family_restroom,
            isRequired: false,
            child: SiblingsListSection(
              title: 'قائمة الأشقاء',
              buttonLabel: 'إضافة أخ/أخت',
              list: widget.viewModel.siblings,
              onAdd: () => _addPerson(widget.viewModel.siblings, 'أخ/أخت'),
              onRemove: (person) {
                setState(() => widget.viewModel.siblings.remove(person));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStepCard(
            title: 'الأصدقاء',
            subtitle: 'أضف معلومات الأصدقاء (اختياري)',
            icon: Icons.people_outline,
            isRequired: false,
            child: FriendsListSection(
              title: 'قائمة الأصدقاء',
              buttonLabel: 'إضافة صديق',
              list: widget.viewModel.friends,
              onAdd: () => _addFriends(widget.viewModel.friends, 'صديق'),
              onRemove: (friend) {
                setState(() => widget.viewModel.friends.remove(friend));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestPlaymateStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStepCard(
            title: 'الصديق المفضل',
            subtitle: 'أضف الصديق المفضل للطفل (مطلوب)',
            icon: Icons.favorite_outline,
            isRequired: true,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'يمكن إضافة صديق مفضل واحد فقط. هذا الحقل مطلوب لإكمال التسجيل.',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                BestPlaymateSection(
                  title: 'الصديق المفضل',
                  buttonLabel: 'إضافة الصديق المفضل',
                  list: widget.viewModel.bestPlaymates,
                  onAdd: () => widget.viewModel.bestPlaymates.isNotEmpty
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'يمكن إضافة صديق مفضل واحد فقط',
                            ),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.orange.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                      : _addBestPlaymate(
                          widget.viewModel.bestPlaymates,
                          'الصديق المفضل',
                        ),
                  onRemove: (bestPlaymate) {
                    setState(
                      () => widget.viewModel.bestPlaymates.remove(bestPlaymate),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStepCard(
            title: 'مراجعة البيانات',
            subtitle: 'تأكد من صحة جميع المعلومات قبل الحفظ',
            icon: Icons.check_circle_outline,
            isRequired: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildReviewItem(
                  'الاسم',
                  '${widget.viewModel.firstNameController.text} ${widget.viewModel.lastNameController.text}',
                  Icons.person,
                ),
                _buildReviewItem(
                  'تاريخ الميلاد',
                  widget.viewModel.birthDate ?? 'غير محدد',
                  Icons.cake,
                ),
                _buildReviewItem(
                  'الجنس',
                  widget.viewModel.gender == 'Male' ? 'ذكر' : 'أنثى',
                  Icons.wc,
                ),
                _buildReviewItem(
                  'عدد الأشقاء',
                  '${widget.viewModel.siblings.length}',
                  Icons.family_restroom,
                ),
                _buildReviewItem(
                  'عدد الأصدقاء',
                  '${widget.viewModel.friends.length}',
                  Icons.people,
                ),
                _buildReviewItem(
                  'الصديق المفضل',
                  widget.viewModel.bestPlaymates.isNotEmpty
                      ? widget.viewModel.bestPlaymates.first.name ?? 'غير محدد'
                      : 'غير محدد',
                  Icons.favorite,
                  isRequired: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    String title,
    String value,
    IconData icon, {
    bool isRequired = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRequired && value == 'غير محدد'
              ? Colors.red.shade300
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isRequired && value == 'غير محدد'
                        ? Colors.red.shade600
                        : Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isRequired)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'مطلوب',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
    required bool isRequired,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isRequired
                      ? Colors.orange.shade50
                      : ColorManager.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isRequired
                      ? Colors.orange.shade600
                      : ColorManager.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: getBoldStyle(
                            color: Colors.grey.shade800,
                            fontSize: 18,
                          ),
                        ),
                        if (isRequired) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'مطلوب',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: getRegularStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(right: 8),
                  child: OutlinedButton.icon(
                    onPressed: _previousStep,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('السابق'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) SizedBox(width: 8),

            Expanded(
              flex: _currentStep == 0 ? 2 : 1,
              child: BlocListener<NewChildrenCubit, NewChildrenState>(
                listener: (context, state) {
                  if (state is NewChildrenSuccess) {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pop(context, true);
                  }
                  if (state is NewChildrenLoading) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: ColorManager.primaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'جاري حفظ البيانات...',
                                style: getMediumStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(left: _currentStep > 0 ? 8 : 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_currentStep == _totalSteps - 1) {
                        // الصفحة الأخيرة - حفظ البيانات
                        if (_formKey.currentState!.validate() &&
                            widget.viewModel.bestPlaymates.isNotEmpty) {
                          widget.viewModel.saveChild();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'يرجى التأكد من إضافة الصديق المفضل',
                              ),
                              backgroundColor: Colors.red.shade400,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      } else {
                        // الانتقال للصفحة التالية
                        if (_validateCurrentStep()) {
                          _nextStep();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_getStepErrorMessage()),
                              backgroundColor: Colors.red.shade400,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    icon: Icon(
                      _currentStep == _totalSteps - 1
                          ? Icons.save
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      _currentStep == _totalSteps - 1
                          ? 'حفظ البيانات'
                          : 'التالي',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
