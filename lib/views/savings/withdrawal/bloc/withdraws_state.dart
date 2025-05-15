part of 'withdraws_bloc.dart';

@immutable
sealed class WithdrawsState {}

final class WithdrawsInitial extends WithdrawsState {}
final class WithdrawActionState extends WithdrawsState{}
final class WithdrawsLoadingState extends WithdrawsState {}
final class WithdrawsSuccessState extends WithdrawActionState {
  final String message;
  WithdrawsSuccessState({required this.message});
}
final class WithdrawsErrorState extends WithdrawActionState {
  final String error;
  WithdrawsErrorState({required this.error});
}
