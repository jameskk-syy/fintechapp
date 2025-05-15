part of 'loan_repayment_dart_bloc.dart';

@immutable
sealed class LoanRepaymentDartState {}

final class LoanRepaymentDartInitial extends LoanRepaymentDartState {}
final class LoanReymentDartActionState extends LoanRepaymentDartState{}
final class LoanRepaymentLoadingState extends LoanRepaymentDartState{}
final class LoanRepaymentErrorState extends LoanReymentDartActionState{
  final String message;

  LoanRepaymentErrorState({required this.message});
}
final class LoanRepaymentSuccessState extends LoanReymentDartActionState{
   final String message;

  LoanRepaymentSuccessState({required this.message});
}
