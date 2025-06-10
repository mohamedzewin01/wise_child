// widgets/chat_input.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';

class ChatInput extends StatelessWidget {
  final Questions? currentQuestion;
  final TextEditingController textController;
  final String currentTextAnswer;
  final String? currentSingleChoice;
  final List<String> currentMultipleChoices;
  final File? currentImageFile;
  final bool isInSequentialMode;
  final VoidCallback onSubmit;
  final Function(String) onTextChanged;
  final VoidCallback onImageSelected;

  const ChatInput({
    super.key,
    this.currentQuestion,
    required this.textController,
    required this.currentTextAnswer,
    this.currentSingleChoice,
    this.currentMultipleChoices = const [],
    this.isInSequentialMode = false,
    required this.onSubmit,
    required this.onTextChanged,
    this.currentImageFile,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (currentQuestion == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 4,
            color: Colors.black12,
          ),
        ],
      ),
      child: _buildInputWidget(),
    );
  }

  Widget _buildInputWidget() {
    if (currentQuestion!.type == QuestionType.text ||
        currentQuestion!.type == QuestionType.sequential) {
      return _buildTextInput();
    } else if (currentQuestion!.type == QuestionType.singleChoice) {
      return _buildSubmitButton(isEnabled: currentSingleChoice != null);
    } else if (currentQuestion!.type == QuestionType.multipleChoice) {
      return _buildSubmitButton(isEnabled: currentMultipleChoices.isNotEmpty);
    } else if (currentQuestion!.type == QuestionType.image) {
      return ImageInput(
        onImageSelected: onImageSelected,
        currentImageFile: currentImageFile,
        onSubmit: onSubmit,
      );
      // _buildImageInput(isEnabled: currentImageFile != null);
    }

    return SizedBox.shrink();
  }

  Widget _buildTextInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            keyboardType:
                currentQuestion!.type == QuestionType.sequential &&
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
            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
            onPressed: onSubmit,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton({required bool isEnabled}) {
    return ElevatedButton(
      onPressed: isEnabled ? onSubmit : null,
      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45)),
      child: Text('إرسال'),
    );
  }


}

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    this.currentImageFile,
    this.onImageSelected,
    this.onSubmit,
  });

  final File? currentImageFile;
  final void Function()? onSubmit;
  final void Function()? onImageSelected;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.currentImageFile != null
            ? Stack(
          clipBehavior: Clip.none,
              children: [
                Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.file(
                      widget.currentImageFile!,
                      height: 200,
                      width: 150,
                    ),
                  ),
                Positioned(
                  top: -20,
                  left:-20,
                  child: Container(
                    decoration:  BoxDecoration(
                      color: ColorManager.primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 28,
                      ),
                      onPressed: widget.onImageSelected,
                    ),
                  ),
                ),
              ],
            )
            : SizedBox.shrink(),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.onImageSelected,
                icon: Icon(Icons.image),
                label: Text("اختر صورة"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                ),
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
                onPressed: widget.onSubmit,
              ),
            ),
          ],
        ),
      ],
    );
    ;
  }
}
