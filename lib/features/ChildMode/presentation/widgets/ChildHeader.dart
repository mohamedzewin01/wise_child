

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/avatar_image.dart';
import 'package:wise_child/features/Stories/presentation/bloc/ChildrenStoriesCubit/children_stories_cubit.dart';
import 'package:wise_child/features/Stories/presentation/bloc/Stories_cubit.dart';
import 'dart:math' as math;

class ChildHeader extends StatefulWidget {
  const ChildHeader({super.key});

  @override
  State<ChildHeader> createState() => _ChildHeaderState();
}

class _ChildHeaderState extends State<ChildHeader>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _bounceController;
  late Animation<double> _waveAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticInOut,
    ));

    _waveController.repeat();
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // رأس الصفحة مع الترحيب
          _buildWelcomeSection(),

          const SizedBox(height: 20),

          // اختيار الطفل بشكل مرح
          _buildChildSelector(),

          const SizedBox(height: 20),

          // شريط البحث الممتع
          _buildFunSearchBar(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_bounceAnimation.value * math.pi) * 5),
          child: Container(
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
                AnimatedBuilder(
                  animation: _waveAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: math.sin(_waveAnimation.value) * 0.3,
                      child: Container(
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
                          Icons.waving_hand,
                          size: 35,
                          color: Colors.orange.shade600,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 15),

                // نص الترحيب
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحباً بك! 🌟',
                        style: getBoldStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ).copyWith(
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
                        style: getMediumStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChildSelector() {
    return BlocBuilder<StoriesCubit, StoriesState>(
      builder: (context, state) {
        if (state is StoriesSuccess) {
          var children = state.getChildrenEntity.children ?? [];

          if (children.isEmpty) {
            return _buildNoChildrenMessage();
          }

          // تعيين الطفل الأول كافتراضي
          if (children.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ChildrenStoriesCubit>().setInitialChild(
                children.first.idChildren ?? 0,
              );
            });
          }

          return Container(
            height: 120,
            child: BlocBuilder<ChildrenStoriesCubit, ChildrenStoriesState>(
              builder: (context, childrenState) {
                final selectedChildId = context
                    .read<ChildrenStoriesCubit>()
                    .getSelectedChildId();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    final child = children[index];
                    final isSelected = selectedChildId == child.idChildren;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildChildCard(child, isSelected, index),
                    );
                  },
                );
              },
            ),
          );
        }

        return _buildChildrenLoading();
      },
    );
  }

  Widget _buildChildCard(dynamic child, bool isSelected, int index) {
    return GestureDetector(
      onTap: () async {
        await context
            .read<ChildrenStoriesCubit>()
            .changeIdChildren(child.idChildren ?? 0);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        width: 100,
        child: Column(
          children: [
            // الصورة الرمزية مع تأثيرات مرحة
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: EdgeInsets.all(isSelected ? 6 : 3),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [
                    ColorsConst.rainbow[index % ColorsConst.rainbow.length],
                    ColorsConst.rainbow[(index + 1) % ColorsConst.rainbow.length],
                  ],
                )
                    : LinearGradient(
                  colors: [
                    Colors.grey.shade200,
                    Colors.grey.shade100,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: ColorsConst.rainbow[index % ColorsConst.rainbow.length]
                        .withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                ]
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(3),
                child: Hero(
                  tag: 'child_mode_${child.idChildren}',
                  child: AvatarWidget(
                    firstName: child.firstName ?? '',
                    lastName: child.lastName ?? '',
                    backgroundColor: isSelected
                        ? ColorsConst.rainbow[index % ColorsConst.rainbow.length]
                        : ColorManager.primaryColor.withOpacity(0.7),
                    textColor: Colors.white,
                    imageUrl: child.imageUrl,
                    radius: isSelected ? 35 : 30,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // اسم الطفل
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 12 : 8,
                vertical: isSelected ? 6 : 4,
              ),
              decoration: isSelected
                  ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsConst.rainbow[index % ColorsConst.rainbow.length]
                        .withOpacity(0.2),
                    ColorsConst.rainbow[(index + 1) % ColorsConst.rainbow.length]
                        .withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: ColorsConst.rainbow[index % ColorsConst.rainbow.length],
                  width: 2,
                ),
              )
                  : null,
              child: Text(
                child.firstName ?? '',
                style: getBoldStyle(
                  fontSize: isSelected ? 16 : 14,
                  color: isSelected
                      ? ColorsConst.rainbow[index % ColorsConst.rainbow.length]
                      : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
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
          suffixIcon: Container(
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
      ),
    );
  }

  Widget _buildNoChildrenMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade100,
            Colors.red.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.child_care_rounded,
            size: 40,
            color: Colors.orange.shade600,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              'لا يوجد أطفال مسجلين! اطلب من والديك إضافة حسابك 😊',
              style: getMediumStyle(
                fontSize: 16,
                color: Colors.orange.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenLoading() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 60,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// إضافة ألوان قوس قزح للأطفال
extension ColorsConst on ColorManager {
  static List<Color> get rainbow => [
    const Color(0xFFFF6B6B), // أحمر
    const Color(0xFFFFE66D), // أصفر
    const Color(0xFF4ECDC4), // تركوازي
    const Color(0xFF45B7D1), // أزرق
    const Color(0xFF96CEB4), // أخضر
    const Color(0xFFFECA57), // برتقالي
    const Color(0xFFFF9FF3), // وردي
    const Color(0xFFA8E6CF), // أخضر فاتح
  ];
}