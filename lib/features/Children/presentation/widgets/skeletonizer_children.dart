
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/widgets/child_card.dart';

class SkeChildren extends StatelessWidget {
  const SkeChildren({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ChildCard(
            children: Children(
              userId: '1994',
              firstName: ' عمار',
              lastName: ' زوين',
              gender: 'Male',
              dateOfBirth: '1984-09-27',
              imageUrl: 'https://i.pravatar.cc/300',
              emailChildren: null,
              idChildren: 154,
              friendsCount: 2,
              siblingsCount: 2,
            ),
          );
        },
      ),
    );
  }
}
