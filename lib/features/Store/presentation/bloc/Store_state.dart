part of 'Store_cubit.dart';

@immutable
sealed class StoreState {}

final class StoreInitial extends StoreState {}
final class StoreLoading extends StoreState {}
final class StoreSuccess extends StoreState {}
final class StoreFailure extends StoreState {
  final Exception exception;

  StoreFailure(this.exception);
}
