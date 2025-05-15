part of 'spash_screen_bloc.dart';

@immutable
sealed class SpashScreenState {}

final class SpashScreenInitial extends SpashScreenState {
}
sealed class SplashScreenActionState extends SpashScreenState {}

final  class SplashScreenLoading extends SpashScreenState {}

final class SplashScreenLoaded extends SplashScreenActionState {}

final  class SplashScreenError extends SplashScreenActionState {
  final String error;
  SplashScreenError(this.error);
}
