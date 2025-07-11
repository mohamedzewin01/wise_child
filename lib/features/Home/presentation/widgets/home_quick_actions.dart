import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإجراءات السريعة',
            style: getSemiBoldStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickActionCard(
                  context: context,
                  icon: Icons.add,
                  title: 'اضف طفل',
                  subtitle: 'ملف الطفل',
                  color: ColorManager.primaryColor,
                  onTap: () => _navigateToAddChildren(context),
                ),
                _buildQuickActionCard(
                  context: context,
                  icon: Icons.auto_stories_rounded,
                  title: 'عرض القصص',
                  subtitle: 'تصفح المكتبة',
                  color: Colors.blue,
                  onTap: () => _navigateToStories(context),
                ),
                _buildQuickActionCard(
                  context: context,
                  icon: Icons.upload_file_rounded,
                  title: 'طلب قصة',
                  subtitle: 'يمكنك طلب',
                  color: Colors.green,
                  onTap: () => _navigateToAddStory(context),
                ),
                _buildQuickActionCard(
                  context: context,
                  icon: Icons.analytics_outlined,
                  title: 'التقارير',
                  subtitle: 'إحصائيات مفصلة',
                  color: Colors.orange,
                  onTap: () => _navigateToReports(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 6),
        width: 105,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: getBoldStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: getRegularStyle(fontSize: 11, color: Colors.grey[600]!),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddChildren(BuildContext context) {
    Navigator.pushNamed(context, RoutesManager.newChildrenPage);
  }
  void _navigateToStories(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('الانتقال إلى صفحة القصص')),
    );
  }

  void _navigateToAddStory(BuildContext context) {
    // Navigate to add story page
    // Navigator.pushNamed(context, '/add-story');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('الانتقال إلى إضافة قصة')),
    );
  }

  void _navigateToReports(BuildContext context) {
    // Navigate to reports page
    // Navigator.pushNamed(context, '/reports');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('الانتقال إلى صفحة التقارير')),
    );
  }
}
