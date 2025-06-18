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


      elevation: 0,
      color:  friends.gender == 'male' ? Colors.white70.withOpacity(0.4) : Colors.white60.withOpacity(0.4),
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
          style:  getBoldStyle(color: Colors.white,fontSize: 16),
        ),

        subtitle: Text('العمر: ${friends.age} سنة',style: getBoldStyle(color: Colors.white70,fontSize: 12),),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: InkWell(
              onTap: onRemove,
              child: const Icon(Icons.delete_outline, color: Colors.redAccent)),
        ),

      ),
    );
  }
}