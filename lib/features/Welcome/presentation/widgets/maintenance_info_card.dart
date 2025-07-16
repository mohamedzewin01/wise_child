// lib/features/Welcome/presentation/widgets/maintenance_info_card.dart
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/Welcome/domain/entities/app_status_entity.dart';
import 'package:wise_child/features/Welcome/presentation/widgets/maintenance_countdown_widget.dart';

class MaintenanceInfoCard extends StatefulWidget {
  final AppStatusEntity appStatus;

  const MaintenanceInfoCard({
    super.key,
    required this.appStatus,
  });

  @override
  State<MaintenanceInfoCard> createState() => _MaintenanceInfoCardState();
}

class _MaintenanceInfoCardState extends State<MaintenanceInfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Stack(
            children: [
              _buildMainCard(),
              _buildShimmerEffect(),
            ],
          ),
          // عرض العد التنازلي خارج الكارت الرئيسي
          if (widget.appStatus.data?.maintenanceUntil != null &&
              widget.appStatus.data!.maintenanceUntil!.isNotEmpty)
            MaintenanceCountdownWidget(
              maintenanceUntil: widget.appStatus.data!.maintenanceUntil!,
            ),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildMessage(),
          // if (widget.appStatus.data?.maintenanceUntil != null &&
          //     widget.appStatus.data!.maintenanceUntil!.isNotEmpty) ...[
          //   const SizedBox(height: 20),
          //   _buildMaintenanceTimeInfo(),
          // ],
          // const SizedBox(height: 20),
          // _buildStatusIndicator(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.orange.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.construction,
            color: Colors.orange,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "حالة التطبيق",
                style: getBoldStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.appStatus.status ?? "غير محدد",
                style: getRegularStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.appStatus.data?.message ?? "التطبيق تحت الصيانة حالياً",
              style: getRegularStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ).copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTimeInfo() {
    // معلومات أساسية عن وقت الصيانة بدون العد التنازلي
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.schedule,
              color: Colors.blue,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "وقت انتهاء الصيانة المتوقع",
                  style: getMediumStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatMaintenanceTime(widget.appStatus.data!.maintenanceUntil!),
                  style: getRegularStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatMaintenanceTime(String maintenanceUntil) {
    try {
      DateTime dateTime = DateTime.parse(maintenanceUntil.trim());
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year.toString();
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return "$day/$month/$year في $hour:$minute";
    } catch (e) {
      return maintenanceUntil;
    }
  }

  Widget _buildStatusIndicator() {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "في حالة صيانة",
          style: getMediumStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
          ),
        ),
        const Spacer(),
        _buildRefreshButton(),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: () {
          // يمكن إضافة منطق إعادة فحص حالة التطبيق هنا
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "جاري إعادة فحص حالة التطبيق...",
                style: getRegularStyle(color: Colors.white, fontSize: 14),
              ),
              backgroundColor: Colors.blue.withOpacity(0.8),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.refresh,
          color: Colors.white,
          size: 20,
        ),
        tooltip: "إعادة فحص الحالة",
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.1),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _shimmerAnimation.value, -1.0),
              end: Alignment(1.0 + _shimmerAnimation.value, 1.0),
            ),
          ),
        );
      },
    );
  }
}