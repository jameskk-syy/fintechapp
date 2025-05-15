part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}
final class HomeInitialEvent extends HomeEvent {
  final String phoneNumber;

  HomeInitialEvent({required this.phoneNumber});
  
}
