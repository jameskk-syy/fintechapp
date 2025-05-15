part of 'apply_loan_bloc.dart';

@immutable
sealed class ApplyLoanState {}

final class ApplyLoanInitial extends ApplyLoanState {}
final class ApplyLoanActionState extends ApplyLoanState{}
final  class ApplyLoanLoadingState extends ApplyLoanActionState{}
final  class ApplyLoanLoadedState extends ApplyLoanState{
  final String message;
  ApplyLoanLoadedState({required this.message});
}
final  class ApplyLoanErrorState extends ApplyLoanActionState{
  final String message;
   ApplyLoanErrorState({required this.message});
}

