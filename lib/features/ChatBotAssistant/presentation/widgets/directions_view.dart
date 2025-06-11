import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/directions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/presentation/bloc/ChatBotAssistant_cubit.dart';
import 'package:wise_child/features/ChatBotAssistant/presentation/bloc/directions_cubit/directions_cubit.dart';

class DirectionsView extends StatefulWidget {
  const DirectionsView({super.key});

  @override
  State<DirectionsView> createState() => _DirectionsViewState();
}

class _DirectionsViewState extends State<DirectionsView> {
  int? selectedIndex;


  @override
  Widget build(BuildContext context) {
    bool isStory = false;
    return BlocBuilder<DirectionsCubit, DirectionsState>(
      builder: (context, state) {
        if (state is DirectionsLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is DirectionsSuccess) {
          var directions = state.directionsEntity.directions ?? [];
          if (directions[1].title == 'اضافة قصص للابناء') {
            setState(() {
              isStory = true;
            });


          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: CachedNetworkImageProvider(
                  'https://artawiya.com//DigitalArtawiya/image.jpeg',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  children: directions.asMap().entries.map((entry) {
                    var index = entry.key;
                    Directions direction = entry.value;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            padding: EdgeInsets.all(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: ColorManager.chatUserBg,
                            elevation: 5,
                            selectedColor: ColorManager.chatUserBg,
                            selectedShadowColor: Colors.grey,
                            labelStyle: getBoldStyle(color: Colors.white),
                            label: Text(direction.title ?? ''),
                            selected: selectedIndex == index,
                            onSelected: (selected) {
                              setState(() {
                                selectedIndex = selected ? index : null;
                              });

                              direction.id!= 10001

                                  ? null
                                  : ChatBotAssistantCubit.get(context).getQuestions(
                                      directionsId: direction.id.toString(),
                                    );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            padding: EdgeInsets.all(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: ColorManager.chatUserBg,
                            elevation: 5,
                            selectedColor: ColorManager.chatUserBg,
                            selectedShadowColor: Colors.grey,
                            labelStyle: getBoldStyle(color: Colors.white),
                            label: Text(direction.title ?? ''),
                            selected: selectedIndex == index,
                            onSelected: (selected) {
                              setState(() {
                                selectedIndex = selected ? index : null;
                              });
/// TODO : add story
                              direction.id== 10001

                                  ? null
                                  : ChatBotAssistantCubit.get(context).getQuestions(
                                directionsId: direction.id.toString(),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
