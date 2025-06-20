import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());

  static LayoutCubit get(context) => BlocProvider.of(context);
  int index = 0;
  int initialTabIndex=0;
  void changeIndex(int selectIndex,{int? tabIndex}) {
    index = selectIndex;
    initialTabIndex=tabIndex??0;
    emit(LayoutChangePage());
  }
}
