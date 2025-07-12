import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
import '../../../../core/di/di.dart';
import '../../data/models/response/get_children_dto.dart';
import '../bloc/StoryRequest_cubit.dart';

class StoryRequestPage extends StatefulWidget {
  const StoryRequestPage({super.key});

  @override
  State<StoryRequestPage> createState() => _StoryRequestPageState();
}

class _StoryRequestPageState extends State<StoryRequestPage> {
  late StoryRequestCubit viewModel;
  final _formKey = GlobalKey<FormState>();
  final _problemTitleController = TextEditingController();
  final _problemTextController = TextEditingController();
  final _notesController = TextEditingController();

  UserChildren? selectedChild;
  bool isSubmitting = false;

  @override
  void initState() {
    viewModel = getIt.get<StoryRequestCubit>();
    viewModel.getChildrenUser();
    super.initState();
  }

  @override
  void dispose() {
    _problemTitleController.dispose();
    _problemTextController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),

        body: BlocConsumer<StoryRequestCubit, StoryRequestState>(
          listener: _handleStateChanges,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBarApp(
                    title: 'طلب قصة',
                    subtitle: 'يمكنك طلب قصة لطفلك من هنا',
                    backFunction: () => Navigator.of(context).pop(),
                    colorContainerStack: const Color(0xFFF8F9FA),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildChildrenSection(state),
                          const SizedBox(height: 24),
                          _buildStoryRequestForm(),
                          const SizedBox(height: 32),
                          _buildSubmitButton(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.primaryColor, Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_stories,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اطلب قصة مخصصة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'اختر طفلك واكتب طلب القصة التي تريدها',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenSection(StoryRequestState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('اختر الطفل', Icons.child_care),
        const SizedBox(height: 12),
        if (state is GetChildrenUserLoading)
          _buildLoadingCard()
        else if (state is GetChildrenUserSuccess)
          _buildChildrenList(state.getUserChildrenEntity.children ?? [])
        else if (state is GetChildrenUserFailure)
          _buildErrorCard('فشل في تحميل بيانات الأطفال')
        else
          _buildErrorCard('لا توجد بيانات للأطفال'),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: ColorManager.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: getSemiBoldStyle(fontSize: 16, color: const Color(0xFF2D3748)),
        ),
      ],
    );
  }

  Widget _buildChildrenList(List<UserChildren> children) {
    if (children.isEmpty) {
      return _buildErrorCard('لا يوجد أطفال مسجلين');
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          final isSelected = selectedChild?.idChildren == child.idChildren;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedChild = child;
              });
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? ColorManager.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? ColorManager.primaryColor
                      : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: isSelected
                        ? Colors.white
                        : ColorManager.primaryColor,
                    backgroundImage: child.imageUrl != null
                        ? NetworkImage(
                            '${ApiConstants.urlImage}${child.imageUrl}',
                          )
                        : null,
                    child: child.imageUrl == null
                        ? Icon(
                            child.gender == 'Male' ? Icons.boy : Icons.girl,
                            color: isSelected
                                ? ColorManager.primaryColor
                                : Colors.white,
                            size: 28,
                          )
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${child.firstName ?? ''} ${child.lastName ?? ''}',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF2D3748),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoryRequestForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('تفاصيل طلب القصة', Icons.edit_note),
        const SizedBox(height: 16),

        _buildTextField(
          controller: _problemTitleController,
          label: 'عنوان المشكلة أو الموضوع',
          hint: 'مثال: تعليم الصدق، التعامل مع الخوف',
          icon: Icons.title,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال عنوان المشكلة';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        _buildTextField(
          controller: _problemTextController,
          label: 'وصف المشكلة أو الموضوع',
          hint: 'اكتب تفاصيل المشكلة التي تريد معالجتها في القصة...',
          icon: Icons.description,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال وصف المشكلة';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        _buildTextField(
          controller: _notesController,
          label: 'ملاحظات إضافية (اختياري)',
          hint: 'أي ملاحظات أو تفاصيل إضافية تريد تضمينها...',
          icon: Icons.note_add,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A5568),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
            prefixIcon: Icon(icon, color: ColorManager.primaryColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: ColorManager.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53E3E)),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isSubmitting || selectedChild == null
            ? null
            : _submitRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primaryColor,
          disabledBackgroundColor: const Color(0xFFE2E8F0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isSubmitting
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'جاري الإرسال...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'إرسال طلب القصة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 120,
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
      child: const Center(
        child: CircularProgressIndicator(color: ColorManager.primaryColor),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFED7D7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFEB2B2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE53E3E)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFE53E3E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStateChanges(BuildContext context, StoryRequestState state) {
    if (state is StoryRequestSuccess) {
      setState(() {
        isSubmitting = false;
      });
      _showSuccessDialog();
    } else if (state is StoryRequestFailure) {
      setState(() {
        isSubmitting = false;
      });
      _showErrorSnackBar('فشل في إرسال طلب القصة. يرجى المحاولة مرة أخرى.');
    }
  }

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedChild == null) {
      _showErrorSnackBar('يرجى اختيار الطفل أولاً');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    viewModel.addStoryRequest(
      userId: '',
      // Will be handled by cubit from cache
      idChildren: selectedChild!.idChildren!,
      problemTitle: _problemTitleController.text.trim(),
      problemText: _problemTextController.text.trim(),
      notes: _notesController.text.trim(),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF48BB78),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'تم إرسال طلب القصة بنجاح!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'سيتم العمل على قصتك وإرسالها لك قريباً',
              style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'موافق',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
