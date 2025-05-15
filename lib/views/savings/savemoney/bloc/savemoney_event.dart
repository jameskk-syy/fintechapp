part of 'savemoney_bloc.dart';

@immutable
sealed class SavemoneyEvent {}
final class SavemoneyInitialEvent extends SavemoneyEvent {}
final class SavemoneyActionEvent extends SavemoneyEvent {
  final String phoneNumber;
  final String amount;
  SavemoneyActionEvent({required this.phoneNumber, required this.amount});
}
