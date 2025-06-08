import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/questions.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());




}
