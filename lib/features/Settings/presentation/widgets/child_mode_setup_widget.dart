// إنشاء ملف جديد: lib/features/Settings/presentation/widgets/child_mode_setup_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/di/di.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';
import 'package:wise_child/features/Settings/presentation/bloc/user_cubit/user_details_cubit.dart';
import 'package:wise_child/features/Settings/data/models/response/get_user_details_dto.dart';

class ChildModeSetupWidget extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(int childId, String pin) onComplete;

  const ChildModeSetupWidget({
    super.key,
    required this.onCancel,
    required this.onComplete,
  });

  @override
  State<ChildModeSetupWidget> createState() => _ChildModeSetupWidgetState();
}

class _ChildModeSetupWidgetState extends State<ChildModeSetupWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  int _currentStep = 0; // 0: اختيار الطفل, 1: إدخال الرقم السري
  int? _selectedChildId;
  bool _isPinVisible = false;
  bool _isConfirmPinVisible = false;

  late UserDetailsCubit _userDetailsCubit;

  @override
  void initState() {
    super.initState();
    _userDetailsCubit = getIt.get<UserDetailsCubit>();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();

    // جلب بيانات المستخدم
    _userDetailsCubit.getUserDetails();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userDetailsCubit,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header
                  _buildHeader(),

                  // Content
                  Expanded(
                    child: _currentStep == 0
                        ? _buildChildSelectionStep()
                        : _buildPinSetupStep(),
                  ),

                  // Footer Buttons
                  _buildFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor.withOpacity(0.1),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.child_care,
                  color: ColorManager.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إعداد وضع الأطفال',
                      style: getBoldStyle(
                        color: ColorManager.primaryColor,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      _currentStep == 0
                          ? 'اختر الطفل الذي ستفعل له الوضع'
                          : 'أدخل رقم سري للحماية',
                      style: getRegularStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onCancel,
                icon: Icon(Icons.close, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Indicator
          Row(
            children: [
              _buildStepIndicator(0, 'اختر الطفل'),
              Expanded(
                child: Container(
                  height: 2,
                  color: _currentStep > 0
                      ? ColorManager.primaryColor
                      : Colors.grey[300],
                ),
              ),
              _buildStepIndicator(1, 'الرقم السري'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String title) {
    final bool isActive = step <= _currentStep;
    final bool isCurrent = step == _currentStep;

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? ColorManager.primaryColor : Colors.grey[300],
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(color: ColorManager.primaryColor, width: 2)
                : null,
          ),
          child: Center(
            child: isActive
                ? Icon(
              step < _currentStep ? Icons.check : Icons.circle,
              color: Colors.white,
              size: 12,
            )
                : Text(
              '${step + 1}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: getRegularStyle(
            color: isActive ? ColorManager.primaryColor : Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildChildSelectionStep() {
    return BlocBuilder<UserDetailsCubit, UserDetailsState>(
      builder: (context, state) {
        if (state is UserDetailsLoading) {
          return _buildLoadingWidget();
        }

        if (state is UserDetailsSuccess) {
          final children = state.getUserDetailsEntity?.user?.children ?? [];

          if (children.isEmpty) {
            return _buildNoChildrenWidget();
          }

          return _buildChildrenList(children);
        }

        if (state is UserDetailsFailure) {
          return _buildErrorWidget();
        }

        return _buildLoadingWidget();
      },
    );
  }

  Widget _buildChildrenList(List<UserChildren> children) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر الطفل:',
            style: getBoldStyle(
              color: Colors.grey[800],
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];
                final isSelected = _selectedChildId == child.idChildren;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          _selectedChildId = child.idChildren;
                        });
                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorManager.primaryColor.withOpacity(0.1)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? ColorManager.primaryColor
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            AvatarWidget(
                              firstName: child.firstName ?? '',
                              lastName: child.lastName ?? '',
                              backgroundColor: ColorManager.primaryColor,
                              textColor: Colors.white,
                              imageUrl: child.imageUrl,
                              radius: 24,
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${child.firstName ?? ''} ${child.lastName ?? ''}',
                                    style: getBoldStyle(
                                      color: Colors.grey[800],
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (child.dateOfBirth != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'تاريخ الميلاد: ${child.dateOfBirth}',
                                      style: getRegularStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                  if (child.gender != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'الجنس: ${child.gender}',
                                      style: getRegularStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: ColorManager.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinSetupStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أدخل رقم سري:',
              style: getBoldStyle(
                color: Colors.grey[800],
                fontSize: 16,
              ),
            ),
        
            const SizedBox(height: 8),
        
            Text(
              'سيتم استخدام هذا الرقم للخروج من وضع الأطفال',
              style: getRegularStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
        
            const SizedBox(height: 24),

            _buildPinField(
              controller: _pinController,
              label: 'الرقم السري',
              hint: 'أدخل 4 أرقام',
              isVisible: _isPinVisible,
              onVisibilityToggle: () {
                setState(() => _isPinVisible = !_isPinVisible);
              },
            ),
        
            const SizedBox(height: 20),

            _buildPinField(
              controller: _confirmPinController,
              label: 'تأكيد الرقم السري',
              hint: 'أعد إدخال الرقم السري',
              isVisible: _isConfirmPinVisible,
              onVisibilityToggle: () {

                setState(() => _isConfirmPinVisible = !_isConfirmPinVisible);
              },
            ),
        
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'اختر رقم سري يسهل عليك تذكره ولكن صعب على الطفل تخمينه',
                      style: getRegularStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                      ),
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

  Widget _buildPinField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBoldStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !isVisible,
          keyboardType: TextInputType.number,
          maxLength: 4,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: onVisibilityToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ColorManager.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(ColorManager.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تحميل بيانات الأطفال...',
            style: getRegularStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoChildrenWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.child_care_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد أطفال مسجلين',
            style: getBoldStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يجب إضافة طفل أولاً لتفعيل وضع الأطفال',
            style: getRegularStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في تحميل البيانات',
            style: getBoldStyle(
              color: Colors.red[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _userDetailsCubit.getUserDetails();
            },
            child: Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: widget.onCancel,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Text(
                'إلغاء',
                style: getBoldStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _handleNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentStep == 0 ? 'التالي' : 'تفعيل',
                style: getBoldStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    if (_currentStep == 0) {
      return _selectedChildId != null;

    } else {
      return _pinController.text.length == 4 &&
          _confirmPinController.text.length == 4 &&
          _pinController.text == _confirmPinController.text;
    }
  }

  void _handleNext() {
    if (_currentStep == 0) {
      setState(() {
        _currentStep = 1;
      });
    } else {
      // تحقق من صحة الرقم السري
      if (_pinController.text != _confirmPinController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('الرقم السري غير متطابق'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_pinController.text.length != 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يجب أن يكون الرقم السري 4 أرقام'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }


      widget.onComplete(_selectedChildId!, _pinController.text);
    }
  }
}