import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';

class NotificationsPage extends StatefulWidget {
  const   NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin
{
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String selectedFilter = 'الكل';
  bool showOnlyUnread = false;
  List<NotificationModel> notifications = [];
  List<NotificationModel> filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _initializeNotifications();
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _initializeNotifications() {
    notifications = [
      NotificationModel(
        id: '1',
        type: NotificationType.newStory,
        title: 'قصة جديدة متاحة!',
        message: 'تم إضافة قصة "مغامرات سندباد" إلى مكتبتك',
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        icon: Icons.auto_stories,
        color: Colors.blue,
        priority: NotificationPriority.high,
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.childInteraction,
        title: 'إعجاب بقصة طفلك',
        message: 'أحمد أحب قصة "الأسد الملك" وأعطاها 5 نجوم',
        time: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
        icon: Icons.favorite,
        color: Colors.red,
        priority: NotificationPriority.medium,
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.storyRequest,
        title: 'طلب قصة جديد',
        message: 'تم الموافقة على طلب قصة "عالم الديناصورات"',
        time: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        icon: Icons.approval,
        color: Colors.green,
        priority: NotificationPriority.medium,
      ),
      NotificationModel(
        id: '4',
        type: NotificationType.systemUpdate,
        title: 'تحديث التطبيق',
        message: 'إصدار جديد متاح مع ميزات رائعة!',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
        icon: Icons.system_update,
        color: Colors.purple,
        priority: NotificationPriority.low,
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.reminder,
        title: 'وقت القراءة!',
        message: 'حان وقت قراءة القصة اليومية مع سارة',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
        icon: Icons.schedule,
        color: Colors.orange,
        priority: NotificationPriority.high,
      ),
      NotificationModel(
        id: '6',
        type: NotificationType.achievement,
        title: 'إنجاز جديد!',
        message: 'مبروك! أكمل طفلك 10 قصص هذا الأسبوع',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        icon: Icons.emoji_events,
        color: Colors.amber,
        priority: NotificationPriority.medium,
      ),
    ];

    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      filteredNotifications = notifications.where((notification) {
        // تطبيق فلتر القراءة
        if (showOnlyUnread && notification.isRead) {
          return false;
        }

        // تطبيق فلتر النوع
        if (selectedFilter == 'الكل') {
          return true;
        } else if (selectedFilter == 'القصص' &&
            (notification.type == NotificationType.newStory ||
                notification.type == NotificationType.storyRequest)) {
          return true;
        } else if (selectedFilter == 'الأطفال' &&
            (notification.type == NotificationType.childInteraction ||
                notification.type == NotificationType.achievement)) {
          return true;
        } else if (selectedFilter == 'النظام' &&
            (notification.type == NotificationType.systemUpdate ||
                notification.type == NotificationType.reminder)) {
          return true;
        }

        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [

            CustomAppBarApp(
              title: 'الإشعارات',
              subtitle: _buildSubtitle(),
              backFunction: () => Navigator.pop(context),
               icon:Icon(
                 showOnlyUnread ? Icons.visibility_off : Icons.visibility,
                 color: Colors.grey[600],),
              iconFunction: () {
                setState(() {
                  showOnlyUnread = !showOnlyUnread;
                });
                _applyFilters();
              },



            ),


            _buildFiltersSection(),

            // قائمة الإشعارات
            Expanded(
              child: filteredNotifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationsList(),
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final unreadCount = notifications.where((n) => !n.isRead).length;
    if (unreadCount == 0) {
      return 'جميع الإشعارات مقروءة';
    }
    return '$unreadCount إشعار جديد';
  }

  Widget _buildFiltersSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عدادات الإشعارات
          _buildNotificationCounts(),
          const SizedBox(height: 16),

          // التبويبات
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: ColorManager.primaryColor,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: ColorManager.primaryColor,
            labelStyle: getSemiBoldStyle(fontSize: 14),
            unselectedLabelStyle: getRegularStyle(fontSize: 14),
            onTap: (index) {
              setState(() {
                switch (index) {
                  case 0:
                    selectedFilter = 'الكل';
                    break;
                  case 1:
                    selectedFilter = 'القصص';
                    break;
                  case 2:
                    selectedFilter = 'الأطفال';
                    break;
                  case 3:
                    selectedFilter = 'النظام';
                    break;
                }
              });
              _applyFilters();
            },
            tabs: const [
              Tab(text: 'الكل'),
              Tab(text: 'القصص'),
              Tab(text: 'الأطفال'),
              Tab(text: 'النظام'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCounts() {
    final total = notifications.length;
    final unread = notifications.where((n) => !n.isRead).length;
    final stories = notifications.where((n) =>
    n.type == NotificationType.newStory ||
        n.type == NotificationType.storyRequest).length;

    return Row(
      children: [
        _buildCountChip('المجموع', total, Colors.blue),
        const SizedBox(width: 8),
        _buildCountChip('جديد', unread, Colors.red),
        const SizedBox(width: 8),
        _buildCountChip('القصص', stories, Colors.green),
      ],
    );
  }

  Widget _buildCountChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: getRegularStyle(fontSize: 12, color: color),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: getBoldStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationCard(notification, index);
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _deleteNotification(notification.id);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 24,
          ),
        ),
        child: GestureDetector(
          onTap: () => _markAsRead(notification.id),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notification.isRead ? Colors.white : Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: notification.isRead
                    ? Colors.grey.withOpacity(0.2)
                    : ColorManager.primaryColor.withOpacity(0.3),
                width: notification.isRead ? 1 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الإشعار
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: notification.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // محتوى الإشعار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: getSemiBoldStyle(
                                fontSize: 16,
                                color: notification.isRead
                                    ? Colors.grey[700]
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          _buildPriorityIndicator(notification.priority),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: getRegularStyle(
                          fontSize: 14,
                          color: Colors.grey[600]!,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(notification.time),
                            style: getRegularStyle(
                              fontSize: 12,
                              color: Colors.grey[500]!,
                            ),
                          ),
                          const Spacer(),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: ColorManager.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // زر الإجراءات
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onSelected: (value) => _handleNotificationAction(value, notification),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: notification.isRead ? 'mark_unread' : 'mark_read',
                      child: Row(
                        children: [
                          Icon(
                            notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(notification.isRead ? 'تحديد كغير مقروء' : 'تحديد كمقروء'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('حذف', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(NotificationPriority priority) {
    Color color;
    String text;

    switch (priority) {
      case NotificationPriority.high:
        color = Colors.red;
        text = 'عالية';
        break;
      case NotificationPriority.medium:
        color = Colors.orange;
        text = 'متوسطة';
        break;
      case NotificationPriority.low:
        color = Colors.grey;
        text = 'منخفضة';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: getRegularStyle(fontSize: 10, color: color),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: getSemiBoldStyle(
              fontSize: 18,
              color: Colors.grey[600]!,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر الإشعارات الجديدة هنا',
            style: getRegularStyle(
              fontSize: 14,
              color: Colors.grey[500]!,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  void _markAsRead(String id) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
      }
    });
    _applyFilters();
  }

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
    });
    _applyFilters();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف الإشعار'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'mark_all_read':
        setState(() {
          for (int i = 0; i < notifications.length; i++) {
            notifications[i] = notifications[i].copyWith(isRead: true);
          }
        });
        _applyFilters();
        break;

      case 'delete_all_read':
        setState(() {
          notifications.removeWhere((n) => n.isRead);
        });
        _applyFilters();
        break;

      case 'settings':
        _showNotificationSettings();
        break;
    }
  }

  void _handleNotificationAction(String action, NotificationModel notification) {
    switch (action) {
      case 'mark_read':
        _markAsRead(notification.id);
        break;
      case 'mark_unread':
        setState(() {
          final index = notifications.indexWhere((n) => n.id == notification.id);
          if (index != -1) {
            notifications[index] = notifications[index].copyWith(isRead: false);
          }
        });
        _applyFilters();
        break;
      case 'delete':
        _deleteNotification(notification.id);
        break;
    }
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header
              Row(
                children: [
                  Icon(Icons.settings, color: ColorManager.primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    'إعدادات الإشعارات',
                    style: getSemiBoldStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Settings List
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildSettingItem(
                      'إشعارات القصص الجديدة',
                      'تلقي إشعار عند إضافة قصص جديدة',
                      Icons.auto_stories,
                      true,
                    ),
                    _buildSettingItem(
                      'تفاعلات الأطفال',
                      'إشعارات عند تفاعل الأطفال مع القصص',
                      Icons.child_friendly,
                      true,
                    ),
                    _buildSettingItem(
                      'تذكير القراءة',
                      'تذكير يومي لوقت قراءة القصص',
                      Icons.schedule,
                      false,
                    ),
                    _buildSettingItem(
                      'الإنجازات',
                      'إشعارات عند تحقيق إنجازات جديدة',
                      Icons.emoji_events,
                      true,
                    ),
                    _buildSettingItem(
                      'تحديثات التطبيق',
                      'إشعارات عند توفر تحديثات جديدة',
                      Icons.system_update,
                      true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, IconData icon, bool value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorManager.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: ColorManager.primaryColor),
      ),
      title: Text(title, style: getSemiBoldStyle(fontSize: 16)),
      subtitle: Text(subtitle, style: getRegularStyle(fontSize: 14)),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          // Handle switch change
        },
        activeColor: ColorManager.primaryColor,
      ),
    );
  }
}

// نماذج البيانات
class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final IconData icon;
  final Color color;
  final NotificationPriority priority;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.color,
    required this.priority,
  });

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? time,
    bool? isRead,
    IconData? icon,
    Color? color,
    NotificationPriority? priority,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      priority: priority ?? this.priority,
    );
  }
}

enum NotificationType {
  newStory,
  childInteraction,
  storyRequest,
  systemUpdate,
  reminder,
  achievement,
}

enum NotificationPriority {
  high,
  medium,
  low,
}