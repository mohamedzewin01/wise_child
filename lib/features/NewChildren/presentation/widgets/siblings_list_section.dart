import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/siblings_card.dart';

class SiblingsListSection extends StatelessWidget {
  const SiblingsListSection({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.list,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final String buttonLabel;
  final List<Siblings> list;
  final VoidCallback onAdd;
  final ValueChanged<Siblings> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title,),

        if (list.isEmpty)
           Text(
            'لا يوجد اخوه مضافون.',
            style: getBoldStyle(color: Colors.grey),
          ),
        ...list.map(
              (person) =>
              SiblingsCard(person: person, onRemove: () => onRemove(person)),
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