import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wise_child/core/common/api_result.dart';
import 'package:wise_child/features/Stories/domain/entities/children_story_entity.dart';
import 'package:wise_child/features/Stories/domain/useCases/Stories_useCase_repo.dart';

part 'children_stories_state.dart';

@injectable
class ChildrenStoriesCubit extends Cubit<ChildrenStoriesState> {
  ChildrenStoriesCubit(this._storiesUseCaseRepo)
      : super(ChildrenStoriesInitial());

  final StoriesUseCaseRepo _storiesUseCaseRepo;

  static ChildrenStoriesCubit get(context) => BlocProvider.of(context);
  int idChildren = 0;
  int selectedChildId = -1;

  Future<void> changeIdChildren(int newIdChildren) async {
    // تحديث الطفل المحدد أولاً
    selectedChildId = newIdChildren;
    idChildren = newIdChildren;

    // إرسال حالة تحديث فورية لتحديث واجهة المستخدم
    emit(ChildrenStoriesChildChanged(selectedChildId));

    // ثم جلب القصص
    await getStoriesChildren();
  }

  int getSelectedChildId() {
    return selectedChildId;
  }

  // دالة لتعيين الطفل الأول كمحدد افتراضياً
  void setInitialChild(int childId) {
    if (selectedChildId == -1) {
      selectedChildId = childId;
      idChildren = childId;
      // إرسال حالة تحديث
      emit(ChildrenStoriesChildChanged(selectedChildId));
    }
  }

  Future<void> getStoriesChildren() async {
    emit(ChildrenStoriesLoading());
    var result = await _storiesUseCaseRepo.getStoriesChildren(idChildren);
    switch (result) {
      case Success<ChildrenStoriesEntity?>():
        {
          if (!isClosed) {
            emit(ChildrenStoriesSuccess(result.data!));
          }
        }
        break;
      case Fail():
        {
          if (!isClosed) {
            emit(ChildrenStoriesFailure(result.exception));
          }
        }
        break;
    }
  }
}