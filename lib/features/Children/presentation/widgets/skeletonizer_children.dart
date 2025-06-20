
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wise_child/features/Children/data/models/response/get_children_dto.dart';
import 'package:wise_child/features/Children/presentation/widgets/child_card.dart';

class SkeChildren extends StatelessWidget {
  const SkeChildren({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        itemCount: 3,
        itemBuilder: (context, index) {
          return ChildCard(
            children: Children(
              userId: '1994',
              firstName: ' عمار',
              lastName: ' زوين',
              gender: 'Male',
              dateOfBirth: '1984-09-27',
              imageUrl: 'default.jpg',
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
//'https://i.pravatar.cc/300',