

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/widgets/avatar_image.dart';

class ChildDetailsAppBar extends StatefulWidget {
  final Children child;
  final Animation<double> heroAnimation;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const ChildDetailsAppBar({
    super.key,
    required this.child,
    required this.heroAnimation,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  State<ChildDetailsAppBar> createState() => _ChildDetailsAppBarState();
}

class _ChildDetailsAppBarState extends State<ChildDetailsAppBar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideController.forward();
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: ColorManager.primaryColor,
      elevation: 0,
      leading: _buildBackButton(context),
      actions: [_buildMenuButton()],
      flexibleSpace: _buildFlexibleSpace(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: _buildCurvedBottom(),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: _buildButtonDecoration(),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.2, -0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      )),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: _buildButtonDecoration(),
          child: Material(
            color: Colors.transparent,
            child: PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.black87,
                size: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 12,
              shadowColor: Colors.black26,
              offset: const Offset(0, 8),
              itemBuilder: (context) => [
                _buildMenuItem(
                  value: 'edit',
                  icon: Icons.edit_rounded,
                  label: 'تعديل البيانات',
                  color: ColorManager.primaryColor,
                ),
                const PopupMenuDivider(height: 16),
                _buildMenuItem(
                  value: 'delete',
                  icon: Icons.delete_rounded,
                  label: 'حذف الطفل',
                  color: ColorManager.red,
                ),
              ],
              onSelected: _handleMenuSelection,
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: value == 'delete' ? color : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlexibleSpace() {
    return FlexibleSpaceBar(
      background: Container(
        decoration: _buildGradientDecoration(),
        child: Stack(
          children: [
            // Floating particles with safe animation
            _buildFloatingParticles(),

            // Main content with safe scaling
            Center(
              child: _buildHeroContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Stack(
      children: List.generate(6, (index) {
        return AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            final animationValue = _fadeAnimation.value;
            final offset = Offset(
              (index * 60.0) + (animationValue * 10),
              (index * 40.0) + (animationValue * 8),
            );
            return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Opacity(
                opacity: 0.08 * animationValue,
                child: Container(
                  width: 4 + (index % 2) * 2,
                  height: 4 + (index % 2) * 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildHeroContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeroAvatar(),
          const SizedBox(height: 20),
          _buildChildName(),
          const SizedBox(height: 8),
          _buildChildSubtitle(),
        ],
      ),
    );
  }

  Widget _buildHeroAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 12),
            blurRadius: 25,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
            ],
          ),
        ),
        child: AvatarWidget(
          firstName: widget.child.firstName ?? '',
          lastName: widget.child.lastName ?? '',
          backgroundColor: Colors.white,
          textColor: ColorManager.primaryColor,
          imageUrl: widget.child.imageUrl,
          radius: 65.0,
        ),
      ),
    );
  }

  Widget _buildChildName() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          '${widget.child.firstName} ${widget.child.lastName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                offset: Offset(0, 3),
                blurRadius: 8,
                color: Colors.black38,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildChildSubtitle() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.child.gender?.toLowerCase() == 'male'
                  ? Icons.male_rounded
                  : Icons.female_rounded,
              color: Colors.white.withOpacity(0.9),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'ملف الطفل',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurvedBottom() {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorManager.primaryColor.withOpacity(0.1),
              Colors.grey.shade50,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildButtonDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.8),
          offset: const Offset(0, -2),
          blurRadius: 8,
        ),
      ],
    );
  }

  BoxDecoration _buildGradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.5, 1.0],
        colors: [
          ColorManager.primaryColor,
          ColorManager.primaryColor.withOpacity(0.9),
          ColorManager.primaryColor.withOpacity(0.8),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: ColorManager.primaryColor.withOpacity(0.3),
          offset: const Offset(0, 8),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );
  }

  void _handleMenuSelection(String value) {
    HapticFeedback.lightImpact();

    switch (value) {
      case 'edit':
        widget.onEditPressed();
        break;
      case 'delete':
        widget.onDeletePressed();
        break;
    }
  }
}