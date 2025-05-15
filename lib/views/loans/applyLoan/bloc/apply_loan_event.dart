part of 'apply_loan_bloc.dart';

@immutable
sealed class ApplyLoanEvent {}
final class ApplyLoanRequestEvent extends ApplyLoanEvent{
  final String phoneNumber;
  final String productName;
  final String amount;

  ApplyLoanRequestEvent({required this.phoneNumber, required this.productName, required this.amount});
}

