part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class HomeActionState extends HomeState {}
final class HomeLoadingState extends HomeState {}
final  class HomeLoadedState extends HomeState {
  final AccountBalanceResponse transactionResponse;
  HomeLoadedState({required this.transactionResponse});
}
final class HomeErrorState extends HomeActionState {
  final String error;
  HomeErrorState({required this.error});
}
