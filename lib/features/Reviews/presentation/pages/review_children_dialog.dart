// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:wise_child/core/resources/style_manager.dart';
//
// class AddReviewDialog extends StatefulWidget {
//   final String childName;
//   final Function(String, int) onSubmit; // إضافة التقييم أيضاً
//
//   const AddReviewDialog({
//     super.key,
//     required this.childName,
//     required this.onSubmit,
//   });
//
//   @override
//   State<AddReviewDialog> createState() => _AddReviewDialogState();
// }
//
// class _AddReviewDialogState extends State<AddReviewDialog>
//     with TickerProviderStateMixin {
//   final TextEditingController _reviewController = TextEditingController();
//   int _rating = 5;
//   bool _isLoading = false;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//
//   // اللون الأساسي
//   static const Color primaryColor = Color(0xFF9B51E0);
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.elasticOut,
//     ));
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _reviewController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         elevation: 10,
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 400),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//               colors: [
//                 Colors.white,
//                 primaryColor.withOpacity(0.02),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildHeader(),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Column(
//                     children: [
//                       // نص التوضيح
//                       _buildDescription(),
//                       const SizedBox(height: 20),
//
//                       // تقييم النجوم
//                       _buildStarRating(),
//                       const SizedBox(height: 20),
//
//                       // حقل النص
//                       _buildTextFieldWithLabel(),
//                       const SizedBox(height: 24),
//
//                       // الأزرار
//                       _buildActionButtons(),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             primaryColor,
//             primaryColor.withOpacity(0.8),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.rate_review_rounded,
//               size: 32,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'مراجعة ${widget.childName}',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'شاركنا تجربتك',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.white.withOpacity(0.9),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDescription() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: primaryColor.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: primaryColor.withOpacity(0.1),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.psychology_outlined,
//             color: primaryColor,
//             size: 24,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               'كيف تأثر ${widget.childName} بالقصص التفاعلية؟',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[700],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStarRating() {
//     return Column(
//       children: [
//         Text(
//           'تقييمك',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.3),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(5, (index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _rating = index + 1;
//                   });
//                   // تأثير اهتزاز صغير
//                   HapticFeedback.selectionClick();
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   child: Icon(
//                     index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
//                     color: index < _rating ? Colors.amber[600] : Colors.grey[400],
//                     size: 30,
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           _getRatingText(_rating),
//           style: getSemiBoldStyle(
//     fontSize: 14,
//     color: _getRatingColor(_rating),
//     )
//
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextFieldWithLabel() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'تفاصيل التجربة',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: primaryColor.withOpacity(0.3),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: primaryColor.withOpacity(0.05),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: TextField(
//             controller: _reviewController,
//             maxLines: 4,
//             maxLength: 500,
//             decoration: InputDecoration(
//               hintText: 'صف لنا كيف تفاعل ${widget.childName} مع القصص...\nما هي التغييرات الإيجابية التي لاحظتها؟',
//               hintStyle: TextStyle(
//                 color: Colors.grey[500],
//                 fontSize: 14,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: const EdgeInsets.all(16),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Icon(
//                   Icons.edit_outlined,
//                   color: primaryColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: _isLoading ? null : () {
//               _animationController.reverse().then((_) {
//                 Navigator.of(context).pop();
//               });
//             },
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: Colors.grey[400]!),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 14),
//             ),
//             child: const Text(
//               'إلغاء',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           flex: 2,
//           child: ElevatedButton(
//             onPressed: _isLoading ? null : _submitReview,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primaryColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               elevation: 4,
//             ),
//             child: _isLoading
//                 ? SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//                 : const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//
//
//                 Text(
//                   'إرسال المراجعة',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Icon(
//                   Icons.send_rounded,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _getRatingText(int rating) {
//     switch (rating) {
//       case 1:
//         return 'غير راضٍ 😞';
//       case 2:
//         return 'يحتاج تحسين 🤔';
//       case 3:
//         return 'مقبول 😐';
//       case 4:
//         return 'جيد جداً 😊';
//       case 5:
//         return 'ممتاز! 🌟';
//       default:
//         return '';
//     }
//   }
//
//   Color _getRatingColor(int rating) {
//     switch (rating) {
//       case 1:
//         return Colors.red[600]!;
//       case 2:
//         return Colors.orange[600]!;
//       case 3:
//         return Colors.amber[600]!;
//       case 4:
//         return Colors.lightGreen[600]!;
//       case 5:
//         return Colors.green[600]!;
//       default:
//         return Colors.grey[600]!;
//     }
//   }
//
//   void _submitReview() async {
//     if (_reviewController.text.trim().isEmpty) {
//       _showValidationError('يرجى كتابة تفاصيل التجربة');
//       return;
//     }
//
//     if (_reviewController.text.trim().length < 10) {
//       _showValidationError('يرجى كتابة تفاصيل أكثر (على الأقل 10 أحرف)');
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     // محاكاة تأخير الشبكة
//     await Future.delayed(const Duration(seconds: 1));
//
//     widget.onSubmit(_reviewController.text.trim(), _rating);
// /// TODO: Add review to the child
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//
//       _animationController.reverse().then((_) {
//         if (mounted) {
//           Navigator.of(context).pop();
//         }
//       });
//     }
//   }
//
//   void _showValidationError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(
//               Icons.warning_amber_rounded,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.orange[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }
//
// // إضافة import مطلوب
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Reviews/data/models/response/get_children_review_dto.dart';
import 'package:wise_child/features/Reviews/presentation/bloc/Reviews_cubit.dart';

class AddReviewDialog extends StatefulWidget {
  final String childName;
  final int childId;
  final ChildrenReviewData? existingReview; // البيانات الموجودة مسبقاً
  final VoidCallback? onSuccess; // callback عند النجاح

  const AddReviewDialog({
    super.key,
    required this.childName,
    required this.childId,
    this.existingReview,
    this.onSuccess,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog>
    with TickerProviderStateMixin {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 5;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isEditMode = false;

  // اللون الأساسي
  static const Color primaryColor = Color(0xFF9B51E0);

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupAnimations();
  }

  void _initializeData() {
    // إذا كانت هناك مراجعة موجودة، قم بتحميل البيانات
    if (widget.existingReview != null) {
      _isEditMode = true;
      _reviewController.text = widget.existingReview!.reviewText ?? '';
      _rating = widget.existingReview!.rating ?? 5;
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is AddReviewsSuccess) {
          _handleSuccess('تم ${_isEditMode ? 'تحديث' : 'إضافة'} المراجعة بنجاح!');
        } else if (state is AddReviewsFailure) {
          _handleError('حدث خطأ أثناء ${_isEditMode ? 'تحديث' : 'إضافة'} المراجعة');
        }
      },
      child: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          _isLoading = state is AddReviewsLoading;

          return ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              clipBehavior: Clip.antiAlias,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24), // ← قلل البادينج هنا
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      primaryColor.withOpacity(0.02),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // عرض معلومات المراجعة السابقة إن وجدت
                            if (_isEditMode) _buildExistingReviewInfo(),

                            // نص التوضيح
                            _buildDescription(),
                            const SizedBox(height: 20),

                            // تقييم النجوم
                            _buildStarRating(),
                            const SizedBox(height: 20),

                            // حقل النص
                            _buildTextFieldWithLabel(),
                            const SizedBox(height: 24),

                            // الأزرار
                            _buildActionButtons(),
                            const SizedBox(height: 20),
                          ],
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
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isEditMode ? Icons.edit_note_rounded : Icons.rate_review_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${_isEditMode ? 'تعديل' : 'إضافة'} مراجعة ${widget.childName}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _isEditMode ? 'قم بتحديث تجربتك' : 'شاركنا تجربتك',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingReviewInfo() {
    if (widget.existingReview?.createdAt == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'تم إنشاء المراجعة في: ${_formatDate(widget.existingReview!.createdAt!)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology_outlined,
            color: primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isEditMode
                  ? 'كيف تغيرت تجربة ${widget.childName} مع القصص التفاعلية؟'
                  : 'كيف تأثر ${widget.childName} بالقصص التفاعلية؟',
              style: getMediumStyle(
                fontSize: 14,
                color: Colors.grey[800],
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Column(
      children: [
        Text(
          'تقييمك',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                  HapticFeedback.selectionClick();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: index < _rating ? Colors.amber[600] : Colors.grey[400],
                    size: 30,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getRatingText(_rating),
          style: getSemiBoldStyle(
            fontSize: 14,
            color: _getRatingColor(_rating),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل التجربة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _reviewController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: _isEditMode
                  ? 'حدث تفاصيل تجربة ${widget.childName} الجديدة...'
                  : 'صف لنا كيف تفاعل ${widget.childName} مع القصص...\nما هي التغييرات الإيجابية التي لاحظتها؟',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.edit_outlined,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () {
              _animationController.reverse().then((_) {
                Navigator.of(context).pop();
              });
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[400]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 4,
            ),
            child: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isEditMode ? 'تحديث المراجعة' : 'إرسال المراجعة',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isEditMode ? Icons.update_rounded : Icons.send_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'غير راضٍ 😞';
      case 2:
        return 'يحتاج تحسين 🤔';
      case 3:
        return 'مقبول 😐';
      case 4:
        return 'جيد جداً 😊';
      case 5:
        return 'ممتاز! 🌟';
      default:
        return '';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red[600]!;
      case 2:
        return Colors.orange[600]!;
      case 3:
        return Colors.amber[600]!;
      case 4:
        return Colors.lightGreen[600]!;
      case 5:
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  void _submitReview() async {
    if (_reviewController.text.trim().isEmpty) {
      _showValidationError('يرجى كتابة تفاصيل التجربة');
      return;
    }

    if (_reviewController.text.trim().length < 10) {
      _showValidationError('يرجى كتابة تفاصيل أكثر (على الأقل 10 أحرف)');
      return;
    }

    // استخدام الـ Cubit لإرسال المراجعة
    context.read<ReviewsCubit>().addOrEditChildReview(
      idChildren: widget.childId,
      rating: _rating,
      review: _reviewController.text.trim(),
    );
  }

  void _handleSuccess(String message) {
    _showSuccessMessage(message);

    // استدعاء callback النجاح
    if (widget.onSuccess != null) {
      widget.onSuccess!();
    }

    // إغلاق الديالوج
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _handleError(String message) {
    _showValidationError(message);
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}