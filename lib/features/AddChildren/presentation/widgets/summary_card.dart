import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bloc/cubit_bot/chatbot_cubit.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = ChatbotCubit.get(context).state.childProfile;
    String details = "الاسم: ${profile.firstName} ${profile.lastName}\n";
    if (profile.dateOfBirth != null) {
      details += "تاريخ الميلاد: ${DateFormat('yyyy-MM-dd').format(profile.dateOfBirth!)}\n";
    }
    if (profile.siblings.isNotEmpty) {
      details += "الإخوة:\n";
      for (var sibling in profile.siblings) {
        details += "  - ${sibling.name} (${sibling.gender}, ${sibling.age} سنة)\n";
      }
    }
    if (profile.relatives.isNotEmpty) {
      // يمكنك تعديل هذه لعرض تفاصيل أكثر إذا أردت
      details += "الأقارب: ${profile.relatives.map((r) => r.name).join(', ')}\n";
    }
    if (profile.favoriteGames.isNotEmpty) {
      details += "الألعاب المفضلة: ${profile.favoriteGames.join(', ')}";
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("تم إنشاء الملف بنجاح!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profile.profileImage != null)
                  CircleAvatar(radius: 40, backgroundImage: FileImage(profile.profileImage!))
                else
                  const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                const SizedBox(width: 16),
                Expanded(child: Text(details, style: const TextStyle(fontSize: 15, height: 1.5))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}