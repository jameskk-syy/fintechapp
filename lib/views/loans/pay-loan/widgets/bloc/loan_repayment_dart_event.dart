part of 'loan_repayment_dart_bloc.dart';

@immutable
sealed class LoanRepaymentDartEvent {}
final  class LoanRepaymentDartSavingsEvent extends LoanRepaymentDartEvent{
  final String phoneNumber;
  final  String amount;
  final  String accountNumber;

  LoanRepaymentDartSavingsEvent({required this.phoneNumber, required this.amount, required this.accountNumber});

}
final  class LoanRepyamentDartMobileEvent extends LoanRepaymentDartEvent{
  final String phoneNumber;
  final  String amount;
  final  String accountNumber;

  LoanRepyamentDartMobileEvent({required this.phoneNumber, required this.amount, required this.accountNumber});
}
