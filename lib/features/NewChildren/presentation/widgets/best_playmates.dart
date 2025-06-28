import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/NewChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/NewChildren/presentation/widgets/section_header.dart';
import 'package:wise_child/l10n/app_localizations.dart';


class BestPlaymateSection extends StatelessWidget {
  const BestPlaymateSection({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.list,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final String buttonLabel;
  final List<BestPlaymate> list;
  final VoidCallback onAdd;
  final ValueChanged<BestPlaymate> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, vertical: 5),

        if (list.isEmpty)
          Text(
            AppLocalizations.of(context)!.noFriendsAdded,
            style: getBoldStyle(color: Colors.grey),
          ),
        ...list.map(
              (person) =>
                  BestPlaymateCard(bestPlaymate: person, onRemove: () => onRemove(person)),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: Text(buttonLabel, style: getBoldStyle(color: Colors.grey)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.green,
            side: BorderSide(color: Colors.grey.shade300),
            // minimumSize: const Size(double.infinity, 45),
            backgroundColor: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }
}

class BestPlaymateCard extends StatelessWidget {
  final BestPlaymate bestPlaymate;
  final VoidCallback onRemove;

  const BestPlaymateCard({super.key, required this.bestPlaymate, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: bestPlaymate.gender == 'male' ? ColorManager.primaryColor.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        titleTextStyle: getBoldStyle(color: Colors.black54,fontSize: 16),
        leading: Icon(
          bestPlaymate.gender == 'male' ? Icons.male : Icons.female,
          color: bestPlaymate.gender == 'male' ? Colors.blue : Colors.pink,
          size: 30,
        ),
        title: Text(
          bestPlaymate.name??'',
          style:getBoldStyle(color: Colors.blueAccent,fontSize: 16),
        ),

        subtitle: Text('العمر: ${bestPlaymate.age} سنة',style: getBoldStyle(color: ColorManager.primaryColor,fontSize: 12),),
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