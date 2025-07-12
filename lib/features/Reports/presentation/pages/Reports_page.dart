import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/di/di.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Reports/data/models/response/reports_dto.dart';
import 'package:wise_child/features/Reviews/presentation/pages/review_children_dialog.dart';
import 'package:wise_child/features/Reviews/presentation/bloc/Reviews_cubit.dart'; // إضافة import للـ Reviews Cubit
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
  late ReviewsCubit reviewsCubit; // إضافة ReviewsCubit
  late TabController _tabController;
  List<ReportData> children = [];

  @override
  void initState() {
    viewModel = getIt.get<ReportsCubit>();
    reviewsCubit = getIt.get<ReviewsCubit>(); // تهيئة ReviewsCubit
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: viewModel),
        BlocProvider.value(value: reviewsCubit), // إضافة ReviewsCubit للـ providers
      ],
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

    final childId = child.childId ?? child.childId ?? 0;
    final childName = '${child.firstName} ${child.lastName}';
    reviewsCubit.getChildReview(idChildren: childId);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: reviewsCubit,
        child: BlocConsumer<ReviewsCubit, ReviewsState>(
          listener: (context, state) {

            if (state is GetReviewsSuccess) {
              Navigator.of(context).pop();
              _showReviewDialog(
                childName: childName,
                childId: childId,
                existingReview: state.getReviewsEntity?.review,
              );
            }

            else if (state is GetReviewsFailure) {
              Navigator.of(context).pop();
              _showReviewDialog(
                childName: childName,
                childId: childId,
                existingReview: null,
              );
            }
          },
          builder: (context, state) {
            if (state is GetReviewsLoading) {
              // عرض loading dialog أثناء تحميل البيانات
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('جاري تحميل بيانات المراجعة...'),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showReviewDialog({
    required String childName,
    required int childId,
    required dynamic existingReview,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: reviewsCubit,
        child: AddReviewDialog(
          childName: childName,
          childId: childId,
          existingReview: existingReview,
          onSuccess: () {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(milliseconds: 150),
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(existingReview != null
                        ? 'تم تحديث المراجعة بنجاح'
                        : 'تم إضافة المراجعة بنجاح'),
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
            // _loadReports();
          },
        ),
      ),
    );
  }
}