part of 'layout_cubit.dart';

@immutable
sealed class LayoutState {}

/// الحالة الأولية للتطبيق
final class LayoutInitial extends LayoutState {}

/// حالة تغيير الصفحة
final class LayoutChangePage extends LayoutState {
  final int index;
  final bool isFloatingButtonVisible;

   LayoutChangePage({
    required this.index,
    this.isFloatingButtonVisible = true,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LayoutChangePage &&
        other.index == index &&
        other.isFloatingButtonVisible == isFloatingButtonVisible;
  }

  @override
  int get hashCode => Object.hash(index, isFloatingButtonVisible);

  @override
  String toString() => 'LayoutChangePage(index: $index, isFloatingButtonVisible: $isFloatingButtonVisible)';
}

/// حالة إظهار/إخفاء الزر العائم
final class LayoutFloatingButtonToggled extends LayoutState {
  final bool isVisible;
  final int currentIndex;

   LayoutFloatingButtonToggled({
    required this.isVisible,
    required this.currentIndex,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LayoutFloatingButtonToggled &&
        other.isVisible == isVisible &&
        other.currentIndex == currentIndex;
  }

  @override
  int get hashCode => Object.hash(isVisible, currentIndex);

  @override
  String toString() => 'LayoutFloatingButtonToggled(isVisible: $isVisible, currentIndex: $currentIndex)';
}

/// حالة خطأ في التنقل (اختيارية)
final class LayoutError extends LayoutState {
  final String message;

   LayoutError({required this.message});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LayoutError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'LayoutError(message: $message)';
}