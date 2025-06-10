
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';



class QuestionOptions extends StatelessWidget {
  final Questions question;
  final Function(String) onSingleChoiceSelected;
  final Function(String) onMultipleChoiceToggled;
  final Function(File) onChoiceImageSelected;
  final String? currentSingleChoice;
  final List<String> currentMultipleChoices;
  final File ? currentImageFile;

  const QuestionOptions({
    super.key,
    required this.question,
    required this.onSingleChoiceSelected,
    required this.onMultipleChoiceToggled,
    this.currentSingleChoice,
    this.currentMultipleChoices = const [],
    this.currentImageFile,
    required this.onChoiceImageSelected,

  });

  @override
  Widget build(BuildContext context) {
    if (question.type == QuestionType.singleChoice) {
      return _buildSingleChoiceOptions();
    } else if (question.type == QuestionType.multipleChoice) {
      return _buildMultipleChoiceOptions();
    }
    // else if (question.type == QuestionType.image) {
    //   return _buildImageOptions();
    // }

    return SizedBox.shrink();
  }

  Widget _buildSingleChoiceOptions() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 40),
      child: Wrap(
        children: question.options!
            .map(
              (option) => Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            child: InkWell(
              onTap: () => onSingleChoiceSelected(option),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 1,

                ),
                decoration: BoxDecoration(
                  color: currentSingleChoice == option
                      ?  ColorManager.chatUserBg.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: currentSingleChoice == option
                        ?  ColorManager.chatUserBg
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      currentSingleChoice == option
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: currentSingleChoice == option
                          ?  ColorManager.chatUserBg
                          : Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      option,
                      style: TextStyle(
                        color: currentSingleChoice == option
                            ?  ColorManager.chatUserBg
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildMultipleChoiceOptions() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 40),
      child: Column(
        children: question.options!
            .map(
              (option) => Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            child: InkWell(
              onTap: () => onMultipleChoiceToggled(option),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: currentMultipleChoices.contains(option)
                      ?  ColorManager.chatUserBg.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: currentMultipleChoices.contains(option)
                        ? ColorManager.chatUserBg
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      currentMultipleChoices.contains(option)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: currentMultipleChoices.contains(option)
                          ?  ColorManager.chatUserBg
                          : Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      option,
                      style: TextStyle(
                        color: currentMultipleChoices.contains(option)
                            ?  ColorManager.chatUserBg
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  // Widget _buildImageOptions() {
  //   return  Container(
  //     margin: EdgeInsets.only(top: 10, right: 40),
  //     child: Icon(Icons.arrow_circle_down_outlined, color: ColorManager.chatUserBg, size: 40,),
  //     );
  // }


}