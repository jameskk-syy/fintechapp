part of 'loan_account_ministatement_bloc.dart';

@immutable
sealed class LoanAccountMinistatementState {}

final class LoanAccountMinistatementInitial extends LoanAccountMinistatementState {}
final  class LoanAccountMinistatementLoading extends LoanAccountMinistatementState{}
final  class LoanAccountMinstatementLoadedState extends LoanAccountMinistatementState{
  final LoanMiniStatementResponse loanMiniStatementResponse;

  LoanAccountMinstatementLoadedState(this.loanMiniStatementResponse);
}
final  class  LoanAccountMiniStatementErrorState extends LoanAccountMinistatementState{
  final  String message;

  LoanAccountMiniStatementErrorState({required this.message});
}
final  class LoanAccountMiniStatementActionState extends LoanAccountMinistatementState{}

