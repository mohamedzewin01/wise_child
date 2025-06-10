// widgets/message_bubble.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/routes_manager.dart';
import 'package:wise_child/core/widgets/animated_arrow_button.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/questions.dart';
import 'package:wise_child/features/ChatBotAssistant/presentation/bloc/chat_cubit/chat_cubit.dart';
import 'package:wise_child/features/ChatBotAssistant/presentation/widgets/question_options.dart';

import '../../data/models/response/questions_dto.dart';
import '../bloc/ChatBotAssistant_cubit.dart';
import '../widgets/typing_indicator.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onSingleChoiceSelected;
  final Function(String) onMultipleChoiceToggled;
  final Function(File) onChoiceImageSelected;
  final String? currentSingleChoice;
  final List<String> currentMultipleChoices;
  final File currentImage;

  const MessageBubble({
    super.key,
    required this.message,
    required this.onSingleChoiceSelected,
    required this.onMultipleChoiceToggled,
    this.currentSingleChoice,
    this.currentMultipleChoices = const [],
    required this.currentImage,
    required this.onChoiceImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: message.isBot
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: message.isBot
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (message.isBot)
                CircleAvatar(
                  radius: 16,
                  backgroundImage: CachedNetworkImageProvider(
                    'https://artawiya.com//DigitalArtawiya/image.jpeg',
                  ),
                ),
              SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: message.isBot
                        ? ColorManager.chatUserBg
                        : ColorManager.chatAssistantText,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: message.isBot
                          ? Radius.circular(4)
                          : Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topRight: message.isBot
                          ? Radius.circular(16)
                          : Radius.circular(4),
                    ),
                  ),
                  child: message.isTyping
                      ? TypingIndicator()
                      : Text(
                          message.text,
                          style: TextStyle(
                            color: message.isBot ? Colors.white : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 8),
              if (!message.isBot)
                CircleAvatar(
                  radius: 16,
                  backgroundImage: CachedNetworkImageProvider(
                    'https://www.georgetown.edu/wp-content/uploads/2022/02/Jkramerheadshot-scaled-e1645036825432-1050x1050-c-default.jpg',
                  ),
                ),
            ],
          ),
          // Add options below the question
          if (message.isBot && message.question != null && !message.isTyping)
            QuestionOptions(
              question: message.question!,
              onSingleChoiceSelected: onSingleChoiceSelected,
              onMultipleChoiceToggled: onMultipleChoiceToggled,
              currentSingleChoice: currentSingleChoice,
              currentMultipleChoices: currentMultipleChoices,
              currentImageFile: currentImage,
              onChoiceImageSelected: onChoiceImageSelected,
            ),
          if (message.imageWidget != null)
            Padding(
              padding: EdgeInsetsGeometry.directional(top: 10, end: 30),
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: 200,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.file(currentImage, fit: BoxFit.fill),
              ),
            ),
          if (message.finalWidget != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.chatUserBg,
                    ),
                    child: IconButton(
                      onPressed: () {
                        List<Questions> questions = [];

                        // ChatCubit.get(context).initializeChat(questions);
                        ChatBotAssistantCubit.get(context).getQuestions();
                      },
                      icon: Icon(Icons.refresh, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AnimatedArrowButton(
                      onTap: () {
                        Navigator.pop(context);

                        /// TODO: navigate to next screen
                      },
                      title: 'تأكيد ومتابعة ',
                      color: ColorManager.chatUserBg,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
