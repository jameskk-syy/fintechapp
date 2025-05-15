part of 'withdraws_bloc.dart';

@immutable
sealed class WithdrawsEvent {}
final  class  WithdrawButtonClicked  extends WithdrawsEvent {
  final String phoneNumber;
  final String amount;
  WithdrawButtonClicked({required this.phoneNumber, required this.amount});
}
