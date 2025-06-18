import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/Friends_card.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
import 'package:wise_child/l10n/app_localizations.dart';


class FriendsListSection extends StatelessWidget {
  const FriendsListSection({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.list,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final String buttonLabel;
  final List<Friends> list;
  final VoidCallback onAdd;
  final ValueChanged<Friends> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title,vertical: 5,),

        if (list.isEmpty)
           Text(
           AppLocalizations.of(context)!.noFriendsAdded,
            style: getBoldStyle(color: Colors.grey),
          ),
        ...list.map(
              (person) =>
              FriendsCard(friends: person, onRemove: () => onRemove(person)),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(

          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: Text(buttonLabel,style: getBoldStyle(color: Colors.grey),),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.green,
            side: BorderSide(
              color: Colors.grey.shade300,
            ),
            // minimumSize: const Size(double.infinity, 45),
         backgroundColor: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }
}
