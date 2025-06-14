import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/presentation/pages/NewChildren_page.dart';

class FriendsCard extends StatelessWidget {
  final Friends friends;
  final VoidCallback onRemove;

  const FriendsCard({super.key, required this.friends, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(


      elevation: 4,
      color:  friends.gender == 'male' ? Colors.blue.shade50 : Colors.pink.shade50,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        titleTextStyle: getBoldStyle(color: Colors.black54,fontSize: 16),
        leading: Icon(
          friends.gender == 'male' ? Icons.male : Icons.female,
          color: friends.gender == 'male' ? Colors.blue : Colors.pink,
          size: 30,
        ),
        title: Text(
          friends.name??'',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        subtitle: Text('العمر: ${friends.age} سنة',style: getBoldStyle(color: Colors.black54,fontSize: 12),),

        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: onRemove,
        ),
      ),
    );
  }
}