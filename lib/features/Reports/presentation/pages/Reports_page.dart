import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/di/di.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Reports/data/models/response/reports_dto.dart';
import 'package:wise_child/features/Reviews/presentation/pages/review_children_dialog.dart';
import 'package:wise_child/features/Reports/presentation/widgets/child_tab_widget.dart';
import 'package:wise_child/features/Reports/presentation/widgets/loading_widget.dart';
import 'package:wise_child/features/Reports/presentation/widgets/error_widget.dart';
import 'package:wise_child/features/Reports/presentation/widgets/empty_state_widget.dart';
import '../bloc/Reports_cubit.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> with TickerProviderStateMixin {
  late ReportsCubit viewModel;
  late TabController _tabController;
  List<ReportData> children = [];

  @override
  void initState() {
    viewModel = getIt.get<ReportsCubit>();
    _tabController = TabController(length: 0, vsync: this);
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    viewModel.childrenReports();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'إحصائيات الأطفال',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: ColorManager.primaryColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadReports,
            ),
          ],
        ),
        body: BlocConsumer<ReportsCubit, ReportsState>(
          listener: (context, state) {
            if (state is ReportsSuccess) {
              setState(() {
                children = state.reportsEntity?.data ?? [];
                _tabController.dispose();
                _tabController = TabController(
                  length: children.length,
                  vsync: this,
                );
              });
            }
          },
          builder: (context, state) {
            if (state is ReportsLoading) {
              return const ReportsLoadingWidget();
            }

            if (state is ReportsFailure) {
              return ReportsErrorWidget(
                error: state.exception.toString(),
                onRetry: _loadReports,
              );
            }

            if (state is ReportsSuccess) {
              if (children.isEmpty) {
                return const EmptyStateWidget();
              }

              return Column(
                children: [
                  Container(
                    color: ColorManager.primaryColor,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      tabs: children.map((child) {
                        return Tab(
                          text: '${child.firstName} ${child.lastName}',
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: children.map((child) {
                        return ChildTabWidget(
                          childData: child,
                          onAddReview: () => _showAddReviewDialog(child),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showAddReviewDialog(ReportData child) {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        childName: '${child.firstName} ${child.lastName}',
        onSubmit: (review, rating) {
          /// TODO: Add review to the child
          // يمكن إضافة منطق حفظ المراجعة هنا
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إضافة المراجعة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

// class AddReviewDialog extends StatefulWidget {
//   final String childName;
//   final Function(String) onSubmit;
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
// class _AddReviewDialogState extends State<AddReviewDialog> {
//   final TextEditingController _reviewController = TextEditingController();
//   int _rating = 5;
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'إضافة مراجعة لـ ${widget.childName}',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'كيف تأثر طفلك بالقصص؟',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (index) {
//                 return IconButton(
//                   icon: Icon(
//                     index < _rating ? Icons.star : Icons.star_border,
//                     color: Colors.amber,
//                     size: 30,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _rating = index + 1;
//                     });
//                   },
//                 );
//               }),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _reviewController,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: 'شاركنا رأيك حول تأثير القصص على طفلك...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 contentPadding: const EdgeInsets.all(16),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     child: const Text('إلغاء'),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_reviewController.text.isNotEmpty) {
//                         widget.onSubmit(_reviewController.text);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorManager.primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'إضافة',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }