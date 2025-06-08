import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/font_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/questions.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';
import 'typing_indicator.dart';
// import 'chat_message.dart';

class ChatWidgets {
  static Widget buildMessageBubble(
      BuildContext context,
      ChatMessage message,
      String? currentSingleChoice,
      List<String> currentMultipleChoices,
      Function(String?) onSingleChoiceChanged,
      Function(String) onMultipleChoiceToggle,
      ) {
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
          // إضافة الاختيارات تحت السؤال
          if (message.isBot && message.question != null && !message.isTyping)
            buildQuestionOptions(
              message.question!,
              currentSingleChoice,
              currentMultipleChoices,
              onSingleChoiceChanged,
              onMultipleChoiceToggle,
            ),
        ],
      ),
    );
  }

  static Widget buildQuestionOptions(
      Questions question,
      String? currentSingleChoice,
      List<String> currentMultipleChoices,
      Function(String?) onSingleChoiceChanged,
      Function(String) onMultipleChoiceToggle,
      ) {
    if (question.type == QuestionType.singleChoice) {
      return Container(
        margin: EdgeInsets.only(top: 10, right: 40),
        child: Wrap(
          children: question.options!
              .map(
                (option) => Container(
              margin: EdgeInsets.symmetric(vertical: 2),
              padding: EdgeInsets.symmetric(horizontal: 2, ),
              child: InkWell(
                onTap: () => onSingleChoiceChanged(option),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: currentSingleChoice == option
                        ? ColorManager.primaryColor.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: currentSingleChoice == option
                          ? ColorManager.primaryColor
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
                            ? ColorManager.primaryColor
                            : Colors.grey,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        option,
                        style: getSemiBoldStyle(color: currentSingleChoice == option
                            ? ColorManager.primaryColor
                            : Colors.black87,)


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
    } else if (question.type == QuestionType.multipleChoice) {
      return Container(
        margin: EdgeInsets.only(top: 10, right: 40),
        child: Wrap(
          children: question.options!
              .map(
                (option) => Container(
              margin: EdgeInsets.symmetric(vertical: 2),
              padding: EdgeInsets.symmetric(horizontal: 2, ),
              child: InkWell(
                onTap: () => onMultipleChoiceToggle(option),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: currentMultipleChoices.contains(option)
                        ? ColorManager.primaryColor.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: currentMultipleChoices.contains(option)
                          ? ColorManager.primaryColor
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
                            ? ColorManager.primaryColor
                            : Colors.grey,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        option,
                        style: TextStyle(
                          color: currentMultipleChoices.contains(option)
                              ?ColorManager.primaryColor
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
    return SizedBox.shrink();
  }

  static Widget buildInputWidget(
      BuildContext context,
      Questions question,
      TextEditingController textController,
      String? currentSingleChoice,
      List<String> currentMultipleChoices,
      bool isInSequentialMode,
      Function(String) onTextChanged,
      VoidCallback onSubmit,
      ) {
    if (question.type == QuestionType.text ||
        (question.type == QuestionType.sequential)) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              keyboardType: question.type == QuestionType.sequential &&
                  !isInSequentialMode
                  ? TextInputType.number
                  : TextInputType.text,
              onChanged: onTextChanged,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: ColorManager.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: ColorManager.inputBorder.withOpacity(0.7),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: ColorManager.chatUserBg.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 12.0,
                ),
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
              ),
              minLines: 1,
              maxLines: 5,
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: ColorManager.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
              onPressed: onSubmit,
            ),
          ),
        ],
      );
    } else if (question.type == QuestionType.singleChoice) {
      return ElevatedButton(
        onPressed: currentSingleChoice != null ? onSubmit : null,
        style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 45),
            backgroundColor: ColorManager.chatUserBg),
        child: Text(
          'إرسال',
          style: getSemiBoldStyle(
              color: ColorManager.white, fontSize: FontSize.s16),
        ),
      );
    } else if (question.type == QuestionType.multipleChoice) {
      return ElevatedButton(
        onPressed: currentMultipleChoices.isNotEmpty ? onSubmit : null,
        style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 45),
            backgroundColor: ColorManager.chatUserBg),
        child: Text(
          'إرسال',
          style: getSemiBoldStyle(
              color: ColorManager.white, fontSize: FontSize.s16),
        ),
      );
    }

    return SizedBox.shrink();
  }
}