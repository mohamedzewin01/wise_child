import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wise_child/core/functions/normalize_gender.dart';
import 'package:wise_child/core/utils/cashed_data_shared_preferences.dart';
import 'package:wise_child/features/AddChildren/data/models/request/add_child_request.dart';
import 'package:wise_child/features/AddChildren/presentation/child_profile_model.dart';
import 'package:wise_child/features/AddChildren/presentation/widgets/date_picker_button.dart';
import 'package:wise_child/features/AddChildren/presentation/widgets/image_picker_buttons.dart';
import 'package:wise_child/features/AddChildren/presentation/widgets/image_preview_message.dart';
import 'package:wise_child/features/AddChildren/presentation/widgets/summary_card.dart';
import 'package:wise_child/features/AddChildren/presentation/widgets/yes_no_buttons.dart';
import '../../person_model.dart';
import '../../widgets/chat_message_widget.dart';

import '../../widgets/confirmation_buttons.dart';
import '../../widgets/gender_buttons.dart';
import 'chatbot_state.dart';

// enum لتحديد الإجراءات النهائية
enum ConfirmationAction { confirm, restart }

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit() : super(ChatbotState.initial());

  static ChatbotCubit get(context) => BlocProvider.of(context);

  //--- متغيرات داخلية للـ Cubit ---
  final _picker = ImagePicker();
  PersonModel? _tempPerson;
  int _personIdCounter = 0;
  String? _imagePath;


  //============================================================================
  // --- الإجراءات الرئيسية التي تستدعيها الواجهة ---
  //============================================================================

  /// تبدأ المحادثة بإرسال رسالة ترحيب ثم تنتقل للمرحلة الأولى من الأسئلة.
  void startConversation() {
    // التأكد من عدم البدء مرة أخرى إذا كانت المحادثة قد بدأت بالفعل
    if (state.stage != ConversationStage.greeting) return;

    var newMessages = List<Widget>.from(state.messages)
      ..add(
        ChatMessageWidget(
          text: "مرحباً! أنا هنا لمساعدتك في إنشاء ملف تعريف لطفل.",
          isFromUser: false,
        ),
      );
    emit(state.copyWith(messages: newMessages));

    Future.delayed(const Duration(milliseconds: 1200), () {
      _transitionToStage(ConversationStage.askingGender);
    });
  }

  /// تعيد تهيئة الحالة بالكامل لبدء محادثة جديدة من الصفر.
  void restartConversation() {
    _personIdCounter = 0;
    _tempPerson = null;
    emit(ChatbotState.initial());
    startConversation();
  }

  /// تعالج جميع ردود المستخدم، سواء كانت نصًا، تاريخًا، أو اختيارًا.
  void handleUserResponse(dynamic response) {
    // معالجة خاصة لأزرار التأكيد النهائية
    if (response is ConfirmationAction) {
      if (response == ConfirmationAction.restart) {
        restartConversation();
      } else if (response == ConfirmationAction.confirm) {
        // --- هنا يتم طباعة الـ JSON ---
        Object? myEncode(Object? object) {
          if (object is DateTime) return object.toIso8601String();
          if (object is File) return object.path;
          return object;
        }

        // استكمال منطق عرض رسالة النجاح
        var newMessages = List<Widget>.from(state.messages);
        newMessages.removeWhere((widget) => widget is Row || widget is Center);
        newMessages.add(
          ChatMessageWidget(
            text: "تم تأكيد وحفظ البيانات بنجاح. شكرًا لك!",
            isFromUser: false,
          ),
        );
        emit(
          state.copyWith(
            messages: newMessages,
            stage: ConversationStage.done,
            isWaitingForTextInput: false,
          ),
        );
      }
      return;
    }

    var newMessages = List<Widget>.from(state.messages);
    newMessages.removeWhere((widget) => widget is Row || widget is Center);

    if (response is String && response.isNotEmpty) {
      newMessages.add(ChatMessageWidget(text: response, isFromUser: true));
    } else if (response is DateTime) {
      newMessages.add(
        ChatMessageWidget(
          text: DateFormat('yyyy-MM-dd').format(response),
          isFromUser: true,
        ),
      );
    } else if (response is bool) {
      newMessages.add(
        ChatMessageWidget(text: response ? "نعم" : "لا", isFromUser: true),
      );
    } else if (response is File) {
      newMessages.add(ImagePreviewMessage(imageFile: response));
    } else if (response == null &&
        state.stage == ConversationStage.askingProfilePicture) {
      newMessages.add(ChatMessageWidget(text: "تخطي", isFromUser: true));
    }

    var currentStage = state.stage;
    var currentProfile = state.childProfile;
    ConversationStage nextStage = currentStage;
    ChildProfileModel updatedProfile = currentProfile;

    switch (currentStage) {
      case ConversationStage.askingGender:
        updatedProfile = currentProfile.copyWith(gender: response);

        nextStage = ConversationStage.askingFirstName;
        break;

      case ConversationStage.askingFirstName:
        updatedProfile = currentProfile.copyWith(firstName: response);
        nextStage = ConversationStage.askingLastName;
        break;
      case ConversationStage.askingLastName:
        updatedProfile = currentProfile.copyWith(lastName: response);
        nextStage = ConversationStage.askingDob;
        break;
      case ConversationStage.askingDob:
        updatedProfile = currentProfile.copyWith(dateOfBirth: response);
        nextStage = ConversationStage.askingProfilePicture;
        break;
      case ConversationStage.askingProfilePicture:
        if (response is File) {
          updatedProfile = currentProfile.copyWith(profileImage: response);
        }
        nextStage = ConversationStage.askingHasSiblings;
        break;
      case ConversationStage.askingHasSiblings:
        if (response) {
          _tempPerson = PersonModel(id: _personIdCounter++);
          nextStage = ConversationStage.askingSiblingGender;
        } else {
          nextStage = ConversationStage.askingHasRelatives;
        }
        break;
      case ConversationStage.askingSiblingGender:
        _tempPerson!.gender = response;
        nextStage = ConversationStage.askingSiblingName;
        break;
      case ConversationStage.askingSiblingName:
        _tempPerson!.name = response;
        nextStage = ConversationStage.askingSiblingAge;
        break;
      case ConversationStage.askingSiblingAge:
        _tempPerson!.age = response;
        final newSiblings = List<PersonModel>.from(currentProfile.siblings)
          ..add(_tempPerson!);
        updatedProfile = currentProfile.copyWith(siblings: newSiblings);
        _tempPerson = null;
        nextStage = ConversationStage.askingAnotherSibling;
        break;
      case ConversationStage.askingAnotherSibling:
        if (response) {
          _tempPerson = PersonModel(id: _personIdCounter++);
          nextStage = ConversationStage.askingSiblingGender;
        } else {
          nextStage = ConversationStage.askingHasRelatives;
        }
        break;
      case ConversationStage.askingHasRelatives:
        if (response) {
          nextStage = ConversationStage.collectingRelativeInfo;
          _tempPerson = PersonModel(id: _personIdCounter++);
        } else {
          nextStage = ConversationStage.askingFavoriteGame;
        }
        break;
      case ConversationStage.collectingRelativeInfo:
        _tempPerson!.name = response;
        final newRelatives = List<PersonModel>.from(currentProfile.relatives)
          ..add(_tempPerson!);
        updatedProfile = currentProfile.copyWith(relatives: newRelatives);
        _tempPerson = null;
        nextStage = ConversationStage.askingAnotherRelative;
        break;
      case ConversationStage.askingAnotherRelative:
        if (response) {
          nextStage = ConversationStage.collectingRelativeInfo;
          _tempPerson = PersonModel(id: _personIdCounter++);
        } else {
          nextStage = ConversationStage.askingFavoriteGame;
        }
        break;
      case ConversationStage.askingFavoriteGame:
        final newGames = List<String>.from(currentProfile.favoriteGames)
          ..add(response);
        updatedProfile = currentProfile.copyWith(favoriteGames: newGames);
        nextStage = ConversationStage.askingAnotherGame;
        break;
      case ConversationStage.askingAnotherGame:
        if (response) {
          nextStage = ConversationStage.askingFavoriteGame;
        } else {
          nextStage = ConversationStage.summary;
        }
        break;
      default:
        break;
    }

    emit(state.copyWith(messages: newMessages, childProfile: updatedProfile));
    Future.delayed(const Duration(milliseconds: 400), () {
      _transitionToStage(nextStage);
    });
  }

  /// تفتح معرض الصور وتتعامل مع الصورة المختارة.
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        handleUserResponse(File(pickedFile.path));
      }
    } catch (e) {
      // Handle error
    }
  }

  //============================================================================
  // --- دوال مساعدة داخلية ---
  //============================================================================

  /// الدالة المحورية: تنتقل إلى مرحلة جديدة، تطرح السؤال، وتعرض الأزرار المناسبة.
  void _transitionToStage(ConversationStage newStage) {
    var newMessages = List<Widget>.from(state.messages);
    final name = state.childProfile.firstName;

    final isWaitingForText = [
      ConversationStage.askingFirstName,
      ConversationStage.askingLastName,
      ConversationStage.askingSiblingName,
      ConversationStage.askingSiblingAge,
      ConversationStage.collectingRelativeInfo,
      ConversationStage.askingFavoriteGame,

    ].contains(newStage);

    switch (newStage) {
      case ConversationStage.askingGender:
        newMessages.add(
          ChatMessageWidget(
            text: "حسناً. هل هو ولد أم بنت؟",
            isFromUser: false,
          ),
        );
        newMessages.add(GenderButtons());
        break;

      case ConversationStage.askingFirstName:
        newMessages.add(
          ChatMessageWidget(
            text: "لنبدأ. ما هو الاسم الأول للطفل؟",
            isFromUser: false,
          ),
        );
        break;
      case ConversationStage.askingLastName:
        newMessages.add(
          ChatMessageWidget(
            text: "عظيم! وما هو اسم العائلة؟",
            isFromUser: false,
          ),
        );
        break;
      case ConversationStage.askingDob:
        newMessages.add(
          ChatMessageWidget(
            text: "شكراً لك. متى كان تاريخ ميلاد الطفل؟",
            isFromUser: false,
          ),
        );
        newMessages.add(DatePickerButton());
        break;
      case ConversationStage.askingProfilePicture:
        newMessages.add(
          ChatMessageWidget(
            text: "رائع! الآن، هل تود إضافة صورة شخصية لـ $name؟",
            isFromUser: false,
          ),
        );
        newMessages.add(ImagePickerButtons());
        break;
      case ConversationStage.askingHasSiblings:
        newMessages.add(
          ChatMessageWidget(
            text: "هل لدى الطفل إخوة أو أخوات؟",
            isFromUser: false,
          ),
        );
        newMessages.add(YesNoButtons());
        break;
      case ConversationStage.askingSiblingGender:
        newMessages.add(
          ChatMessageWidget(
            text: "حسناً. هل هو ولد أم بنت؟",
            isFromUser: false,
          ),
        );
        newMessages.add(GenderButtons());
        break;
      case ConversationStage.askingSiblingName:
        newMessages.add(
          ChatMessageWidget(text: "ما هو اسمه/اسمها؟", isFromUser: false),
        );
        break;
      case ConversationStage.askingSiblingAge:
        newMessages.add(
          ChatMessageWidget(text: "جميل. وكم عمره/عمرها؟", isFromUser: false),
        );
        break;
      case ConversationStage.askingAnotherSibling:
        newMessages.add(
          ChatMessageWidget(text: "هل تريد إضافة أخ آخر؟", isFromUser: false),
        );
        newMessages.add(YesNoButtons());
        break;
      case ConversationStage.askingHasRelatives:
        newMessages.add(
          ChatMessageWidget(
            text: "فهمت. هل لدى الطفل أقارب (مثل أبناء العم)؟",
            isFromUser: false,
          ),
        );
        newMessages.add(YesNoButtons());
        break;
      case ConversationStage.collectingRelativeInfo:
        newMessages.add(
          ChatMessageWidget(
            text: "حسناً، ما هو اسم القريب؟",
            isFromUser: false,
          ),
        );
        break;
      case ConversationStage.askingAnotherRelative:
        newMessages.add(
          ChatMessageWidget(text: "هل تريد إضافة قريب آخر؟", isFromUser: false),
        );
        newMessages.add(YesNoButtons());
        break;
      case ConversationStage.askingFavoriteGame:
        newMessages.add(
          ChatMessageWidget(
            text: "رائع! الآن، أخبرني عن إحدى ألعابه المفضلة.",
            isFromUser: false,
          ),
        );
        break;
      case ConversationStage.askingAnotherGame:
        newMessages.add(
          ChatMessageWidget(
            text: "هل لديه لعبة مفضلة أخرى؟",
            isFromUser: false,
          ),
        );
        newMessages.add(YesNoButtons());
        break;
      case ConversationStage.summary:
        newMessages.add(SummaryCard());
        newMessages.add(
          ConfirmationButtons(
            addChildRequest: AddChildRequest(
              userId: CacheService.getData(key: CacheConstants.userId),
              firstName: state.childProfile.firstName,
              lastName: state.childProfile.lastName,
              dateOfBirth: state.childProfile.dateOfBirth?.split("yyyy-MM-dd").toString(),
              imageUrl: state.childProfile.profileImage?.path,
              gender:normalizeGender(state.childProfile.gender) ,

            ),
          ),
        );
        break;
      default:
        break;
    }

    emit(
      state.copyWith(
        stage: newStage,
        messages: newMessages,
        isWaitingForTextInput: isWaitingForText,
      ),
    );
  }

}

extension on DateTime? {
  split(String s) {
    if (this == null) return null;
    return DateFormat(s).format(this!);
  }
}
