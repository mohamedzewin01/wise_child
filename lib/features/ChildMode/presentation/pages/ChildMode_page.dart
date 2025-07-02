

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';
import '../../../../core/di/di.dart';
import '../widgets/ChildBackground.dart';
import '../widgets/ChildHeader.dart';
import '../widgets/ChildModePage.dart';
import '../widgets/FloatingExitButton.dart';


class ChildModePage extends StatefulWidget {
  final int? selectedChildId; // معرف الطفل المحدد مسبقاً
  final String? childName; // اسم الطفل (اختياري)

  const ChildModePage({
    super.key,
    this.selectedChildId,
    this.childName,
  });

  @override
  State<ChildModePage> createState() => _ChildModePageState();
}

class _ChildModePageState extends State<ChildModePage>
    with TickerProviderStateMixin {
  late StoriesCubit storiesCubit;
  late ChildrenStoriesCubit childrenStoriesCubit;
  late AnimationController _backgroundController;
  late AnimationController _entranceController;
  late AnimationController _welcomeController;
  late Animation<double> _backgroundAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _welcomeAnimation;

  bool _isDataLoaded = false;
  bool _showWelcomeOverlay = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeCubits();
    _startAnimations();
    _loadInitialData();
  }

  void _initializeControllers() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _welcomeController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _welcomeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _welcomeController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializeCubits() {
    storiesCubit = getIt.get<StoriesCubit>();
    childrenStoriesCubit = getIt.get<ChildrenStoriesCubit>();

    // إذا كان هناك طفل محدد مسبقاً، قم بتعيينه
    if (widget.selectedChildId != null) {
      childrenStoriesCubit.setInitialChild(widget.selectedChildId!);
    }
  }

  void _startAnimations() {
    _backgroundController.repeat();
    _welcomeController.forward();

    // إخفاء شاشة الترحيب بعد 3 ثوانٍ
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() => _showWelcomeOverlay = false);
        _entranceController.forward();
      }
    });
  }

  Future<void> _loadInitialData() async {
    try {
      // تحميل بيانات الأطفال
      await storiesCubit.getChildrenByUser();

      // إذا لم يكن هناك طفل محدد، اختر الأول
      if (widget.selectedChildId == null) {
        final state = storiesCubit.state;
        if (state is StoriesSuccess &&
            state.getChildrenEntity.children != null &&
            state.getChildrenEntity.children!.isNotEmpty) {
          final firstChild = state.getChildrenEntity.children!.first;
          childrenStoriesCubit.setInitialChild(firstChild.idChildren ?? 0);
        }
      }

      // تحميل قصص الطفل المحدد
      final selectedChildId = childrenStoriesCubit.getSelectedChildId();
      if (selectedChildId > 0) {
        await childrenStoriesCubit.getStoriesChildren();
      }

      setState(() => _isDataLoaded = true);
    } catch (e) {
      print('Error loading initial data: $e');
      setState(() => _isDataLoaded = true);
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _entranceController.dispose();
    _welcomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: storiesCubit),
        BlocProvider.value(value: childrenStoriesCubit),
      ],
      child: Scaffold(

        body: AnimatedBuilder(
          animation: Listenable.merge([
            _backgroundAnimation,
            _entranceController,
            _welcomeController,
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                // خلفية متحركة ملونة للأطفال
                ChildBackground(animation: _backgroundAnimation),

                // المحتوى الرئيسي
                if (!_showWelcomeOverlay)
                  SafeArea(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // رأس الصفحة مع ترحيب بالطفل
                            _buildSimpleHeader(),

                            const SizedBox(height: 20),

                            // قائمة القصص
                            Expanded(
                              child: _buildStoriesSection(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // زر الخروج العائم (للأولياء فقط)
                const FloatingExitButton(),

                // شاشة الترحيب الأولى
                if (_showWelcomeOverlay)
                  _buildWelcomeOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSimpleHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // ترحيب بسيط بالطفل
          _buildWelcomeSection(),

          const SizedBox(height: 5),
          // // شريط البحث الممتع
          // _buildFunSearchBar(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return BlocBuilder<StoriesCubit, StoriesState>(
      builder: (context, state) {
        String childName = widget.childName ?? 'عزيزي';

        if (state is StoriesSuccess &&
            state.getChildrenEntity.children != null &&
            state.getChildrenEntity.children!.isNotEmpty) {
          final selectedChildId = childrenStoriesCubit.getSelectedChildId();
          final selectedChild = state.getChildrenEntity.children!
              .firstWhere(
                (child) => child.idChildren == selectedChildId,
            orElse: () => state.getChildrenEntity.children!.first,
          );
          childName = selectedChild.firstName ?? 'عزيزي';
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.yellow.shade200,
                Colors.orange.shade200,
                Colors.pink.shade200,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              // أيقونة ترحيبية متحركة
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.yellow.shade100,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.child_care,
                  size: 35,
                  color: Colors.orange.shade600,
                ),
              ),

              const SizedBox(width: 15),

              // نص الترحيب
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أهلاً $childName! 🌟',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.orange.withOpacity(0.7),
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'اختر قصتك المفضلة واستمتع! 📚✨',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFunSearchBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade100,
            Colors.purple.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث عن قصة مثيرة! 🔍',
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.search_rounded,
              color: Colors.blue.shade600,
              size: 25,
            ),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.red.shade400,
            ),
            onPressed: () {
              setState(() => _searchQuery = '');
            },
          )
              : Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.mic_rounded,
              color: Colors.pink.shade400,
              size: 25,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade800,
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  Widget _buildStoriesSection() {
    return BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
      builder: (context, state) {
        if (state is ChildrenStoriesLoading || !_isDataLoaded) {
          return _buildLoadingState();
        }

        if (state is ChildrenStoriesSuccess) {
          final allStories = state.getChildrenEntity?.data ?? [];

          // تطبيق البحث
          final filteredStories = _searchQuery.isEmpty
              ? allStories
              : allStories.where((story) {
            final title = story.storyTitle?.toLowerCase() ?? '';
            final category = story.categoryName?.toLowerCase() ?? '';
            final query = _searchQuery.toLowerCase();
            return title.contains(query) || category.contains(query);
          }).toList();

          if (filteredStories.isEmpty) {
            return _searchQuery.isEmpty
                ? _buildEmptyStoriesState()
                : _buildNoSearchResults();
          }

          return ChildStoryGrid(stories: filteredStories);
        }

        if (state is ChildrenStoriesFailure) {
          return _buildErrorState();
        }

        return _buildLoadingState();
      },
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade100,
              Colors.yellow.shade100,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 60,
              color: Colors.orange.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              'لم نجد قصص تحتوي على "$_searchQuery"',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'جرب البحث عن شيء آخر!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade300,
                  Colors.purple.shade300,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'جاري تحميل القصص الرائعة... 📚',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStoriesState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              Colors.purple.shade100,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade200,
                    Colors.pink.shade200,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            Text(
              'لا توجد قصص متاحة! 😔',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'اطلب من والديك إضافة قصص ممتعة لك! 📚✨',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                childrenStoriesCubit.getStoriesChildren();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade300,
                      Colors.blue.shade300,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'حاول مرة أخرى!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade100,
              Colors.orange.shade100,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              'عذراً! حدث خطأ 😅',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'تأكد من الاتصال بالإنترنت وحاول مرة أخرى',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _loadInitialData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade300,
                      Colors.red.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeOverlay() {
    return AnimatedBuilder(
      animation: _welcomeAnimation,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.8 * (1 - _welcomeAnimation.value)),
          child: Center(
            child: Transform.scale(
              scale: 0.5 + (_welcomeAnimation.value * 0.5),
              child: Opacity(
                opacity: 1 - _welcomeAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // رسوم متحركة ترحيبية
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow.shade300,
                            Colors.orange.shade300,
                            Colors.pink.shade300,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.6),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // نص الترحيب
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Colors.yellow.shade300,
                          Colors.orange.shade300,
                          Colors.pink.shade300,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'أهلاً وسهلاً ${widget.childName ?? ''}! 🌟',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'وقت القصص الممتعة!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // مؤشر التحميل اللطيف
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.yellow.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
