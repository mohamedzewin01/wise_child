import 'package:flutter/material.dart';
import 'package:wise_child/core/api/api_constants.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/AllStoriesByUser/data/models/response/user_stories_dto.dart';
import 'package:wise_child/features/AllStoriesByUser/presentation/widgets/cached_network_image_widget.dart';
import 'package:wise_child/features/SelectStoriesScreen/presentation/widgets/story_details_dialog.dart';
import 'package:wise_child/features/StoryDetails/presentation/pages/StoryDetails_page.dart';

class StoryCardHome extends StatelessWidget {
  final StoriesHome story;
  final int storyIndex;
  final bool isRTL;

  const StoryCardHome({
    super.key,
    required this.story,
    required this.storyIndex, required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        _onStoryTap(context);
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImageWidget(
                  imageUrl: '${ApiConstants.urlImage}${story.imageCover}',
                  width: double.infinity,
                  height: 120,
                  borderRadius: 12,
                ),

                // حالة النشاط
                Positioned(top: 8, right: 8, child: _buildStatusBadge()),

                // التصنيف
                if (story.categoryName != null) ...[
                  Positioned(bottom: 8, left: 8, child: _buildCategoryBadge()),
                ],
              ],
            ),

            // محتوى القصة
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان القصة
                    Text(
                      story.storyTitle ?? 'عنوان غير محدد',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // وصف القصة
                    Expanded(
                      child: Text(
                        story.storyDescription ?? 'لا يوجد وصف متاح',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryDetailsPage(
                                storyId: story.storyId??0,
                                childId: story.childId??0,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.menu_book, color: Colors.white),
                        label: Text(
                          'تفاصيل القصة',
                          style: getSemiBoldStyle(
                            fontSize: 14,
                            color: ColorManager.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
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

  Widget _buildStatusBadge() {
    final isActive = story.isActive ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'متاح' : 'غير متاح',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        story.categoryName!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _onStoryTap(BuildContext context) {
    // يمكنك إضافة التنقل إلى صفحة تفاصيل القصة هنا
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStoryBottomSheet(context),
    );
  }

  Widget _buildStoryBottomSheet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // مقبض السحب
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // محتوى القصة
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة القصة
                  CachedNetworkImageWidget(
                    imageUrl: '${ApiConstants.urlImage}${story.imageCover}',
                    width: double.infinity,
                    height: 200,
                    borderRadius: 12,
                  ),

                  const SizedBox(height: 16),

                  // عنوان القصة
                  Text(
                    story.storyTitle ?? 'عنوان غير محدد',
                    style: getSemiBoldStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // وصف القصة
                  Expanded(
                    child: Text(
                      story.storyDescription ?? 'لا يوجد وصف متاح',
                      style: getSemiBoldStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),

                  // زر البدء
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showStoryDetails(context, story.toStoriesCategory(), isRTL, story.childId??0);
                        //
                        // إضافة منطق بدء القصة
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:  Text(

                        'اضف القصة لقصص ${story.childName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showStoryDetails(BuildContext context, story, bool isRTL,int childId) {
    StoryDetailsDialog.show(
      context: context,
      story: story,
      isRTL: isRTL,
      childId: childId,


    );
  }
}
