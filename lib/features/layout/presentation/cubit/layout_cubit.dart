// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';
//
// part 'layout_state.dart';
//
// class LayoutCubit extends Cubit<LayoutState> {
//   LayoutCubit() : super(LayoutInitial());
//
//   static LayoutCubit get(context) => BlocProvider.of(context);
//   int index = 0;
//
//   void changeIndex(int selectIndex) {
//     index = selectIndex;
//     emit(LayoutChangePage());
//   }
//
//
//
// }
//
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int _currentIndex = 0;
  bool _isFloatingButtonVisible = true;

  /// الحصول على الفهرس الحالي
  int get index => _currentIndex;

  /// الحصول على حالة ظهور الزر العائم
  bool get isFloatingButtonVisible => _isFloatingButtonVisible;

  /// تغيير الصفحة المحددة
  void changeIndex(int selectedIndex) {
    if (selectedIndex >= 0 && selectedIndex < 4 && selectedIndex != _currentIndex) {
      _currentIndex = selectedIndex;
      emit(LayoutChangePage(
        index: selectedIndex,
        isFloatingButtonVisible: _isFloatingButtonVisible,
      ));
    }
  }

  /// إظهار الزر العائم
  void showFloatingButton() {
    if (!_isFloatingButtonVisible) {
      _isFloatingButtonVisible = true;
      emit(LayoutFloatingButtonToggled(
        isVisible: true,
        currentIndex: _currentIndex,
      ));
    }
  }

  /// إخفاء الزر العائم
  void hideFloatingButton() {
    if (_isFloatingButtonVisible) {
      _isFloatingButtonVisible = false;
      emit(LayoutFloatingButtonToggled(
        isVisible: false,
        currentIndex: _currentIndex,
      ));
    }
  }

  /// تبديل حالة ظهور الزر العائم
  void toggleFloatingButton() {
    _isFloatingButtonVisible = !_isFloatingButtonVisible;
    emit(LayoutFloatingButtonToggled(
      isVisible: _isFloatingButtonVisible,
      currentIndex: _currentIndex,
    ));
  }

  /// إخفاء الزر العائم في صفحة معينة
  void hideFloatingButtonForPage(int pageIndex) {
    if (_currentIndex == pageIndex) {
      hideFloatingButton();
    }
  }

  /// إظهار الزر العائم في صفحة معينة
  void showFloatingButtonForPage(int pageIndex) {
    if (_currentIndex == pageIndex) {
      showFloatingButton();
    }
  }

  /// الانتقال إلى الصفحة الرئيسية
  void goToHome() {
    changeIndex(0);
  }

  /// الانتقال إلى صفحة الأطفال
  void goToChildren() {
    changeIndex(1);
  }

  /// الانتقال إلى صفحة القصص
  void goToStories() {
    changeIndex(2);
  }

  /// الانتقال إلى صفحة الإعدادات
  void goToSettings() {
    changeIndex(3);
  }

  /// إعادة تعيين إلى الصفحة الأولى
  void reset() {
    _currentIndex = 0;
    _isFloatingButtonVisible = true;
    emit(LayoutInitial());
  }

  /// التحقق من الصفحة الحالية
  bool isCurrentPage(int pageIndex) {
    return _currentIndex == pageIndex;
  }

  /// الحصول على اسم الصفحة الحالية
  String getCurrentPageName() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Children';
      case 2:
        return 'Stories';
      case 3:
        return 'Settings';
      default:
        return 'Unknown';
    }
  }

  /// تطبيق قواعد إظهار/إخفاء الزر حسب الصفحة
  void applyFloatingButtonRules() {
    switch (_currentIndex) {
      case 3: // إخفاء الزر في صفحة الإعدادات
        hideFloatingButton();
        break;
      default: // إظهار الزر في باقي الصفحات
        showFloatingButton();
        break;
    }
  }
  void setChatbotEnabled(bool isEnabled) {
    if (isEnabled) {
      showFloatingButton();
    } else {
      hideFloatingButton();
    }
  }
}