// pages/chatbot_assistant_page.dart
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/resources/style_manager.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/directions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/data/models/response/questions_dto.dart';
import 'package:wise_child/features/ChatBotAssistant/domain/entities/questions_entity.dart';
import 'package:wise_child/features/ChatBotAssistant/presentation/bloc/chat_cubit/chat_cubit.dart';
import 'package:wise_child/features/ChatBotAssistant/presentation/bloc/directions_cubit/directions_cubit.dart';
import '../../../../core/di/di.dart';
import '../bloc/ChatBotAssistant_cubit.dart';
import '../bloc/chat_cubit/chat_state.dart';
import '../widgets/directions_view.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';

class ChatBotAssistantPage extends StatefulWidget {
  const ChatBotAssistantPage({super.key});

  @override
  State<ChatBotAssistantPage> createState() => _ChatBotAssistantPageState();
}

class _ChatBotAssistantPageState extends State<ChatBotAssistantPage> {
  late DirectionsCubit directionsViewModel;
  late ChatBotAssistantCubit questionsViewModel;
  late ChatCubit chatCubit;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isRefreshing = false;

  Future<void> _refreshQuestions() async {
    if (isRefreshing) return;

    setState(() {
      isRefreshing = true;
    });

    // await questionsViewModel.getQuestions();

    setState(() {
      isRefreshing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    directionsViewModel = getIt.get<DirectionsCubit>();
    questionsViewModel = getIt.get<ChatBotAssistantCubit>();

    chatCubit = ChatCubit();
    // questionsViewModel.getQuestions();
    directionsViewModel.getDirections();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: directionsViewModel),
        BlocProvider.value(value: questionsViewModel),
        BlocProvider.value(value: chatCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<DirectionsCubit, DirectionsState>(
            listener: (context, state) {
              if (state is DirectionsSuccess) {

              }
            },
          ),

          BlocListener<ChatBotAssistantCubit, ChatBotAssistantState>(
            listener: (context, state) {
              if (state is ChatBotAssistantSuccess) {
                final questions = state.questionsEntity?.questions ?? [];
                chatCubit.initializeChat(questions);
              }
            },
          ),
          BlocListener<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatLoaded) {
                _scrollToBottom();
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("StoryGuide Assistant"),
                Text(
                  "Finding the perfect stories for your child",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.chatUserBg,
              ),
              child: IconButton(
                onPressed: _refreshQuestions,
                icon: Icon(Icons.refresh, color: Colors.white),
              ),
            ),
            centerTitle: false,
          ),
          body: Column(
            children: [
              Divider(height: 1, color: Colors.grey[300]),
              DirectionsView(),
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ChatLoaded) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          return MessageBubble(
                            onChoiceImageSelected: (file) {
                              chatCubit.setImage(file);
                              print(file.path);
                            },
                            message: state.messages[index],
                            onSingleChoiceSelected: (choice) {
                              chatCubit.updateSingleChoice(choice);
                            },
                            onMultipleChoiceToggled: (choice) {
                              chatCubit.updateMultipleChoice(choice);
                            },

                            currentSingleChoice: state.currentSingleChoice,
                            currentMultipleChoices:
                                state.currentMultipleChoices,
                            currentImage: state.currentImageFile ?? File(''),
                          );
                        },
                      );
                    } else if (state is ChatError) {
                      return Center(
                        child: Text(
                          'حدث خطأ: ${state.message}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoaded && !state.isCompleted) {
                    final currentQuestion =
                        state.currentQuestionIndex < state.questions.length
                        ? state.questions[state.currentQuestionIndex]
                        : null;

                    return Column(
                      children: [
                        ChatInput(
                          currentQuestion: currentQuestion,
                          onImageSelected: () async {
                            final pickedFile = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              final file = File(pickedFile.path);
                              if (context.mounted) {
                                context.read<ChatCubit>().setImage(file);
                              }
                            }
                          },
                          textController: _textController,
                          currentTextAnswer: state.currentTextAnswer,
                          currentSingleChoice: state.currentSingleChoice,
                          currentMultipleChoices: state.currentMultipleChoices,
                          isInSequentialMode:
                              state.sequentialState.isInSequentialMode,
                          currentImageFile: state.currentImageFile,
                          onSubmit: () {
                            chatCubit.submitAnswer();

                            _textController.clear();
                          },
                          onTextChanged: (text) {
                            chatCubit.updateTextAnswer(text);
                          },
                        ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}


