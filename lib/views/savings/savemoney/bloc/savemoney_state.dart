part of 'savemoney_bloc.dart';

@immutable
sealed class SavemoneyState {}

final class SavemoneyInitial extends SavemoneyState {}
final class SavemoneyActionState extends SavemoneyState {}
final class SavemoneyLoadingState extends SavemoneyState {}
final class SavemoneyErrorState extends SavemoneyState {
  final String errorMessage;
  SavemoneyErrorState(this.errorMessage);
}
final class SavemoneySuccessState extends SavemoneyState {
  final String successMessage;
  SavemoneySuccessState(this.successMessage);
}
