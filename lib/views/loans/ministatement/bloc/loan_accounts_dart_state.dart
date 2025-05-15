part of 'loan_accounts_dart_bloc.dart';

@immutable
sealed class LoanAccountsDartState {}

final class LoanAccountsDartInitial extends LoanAccountsDartState {}
final class LoanAccountsActionState extends LoanAccountsDartState{}
final  class  LoanAccountsLoadingState extends LoanAccountsDartState{}
final  class LoanAccountsLoadedState extends LoanAccountsDartState{
  final LoanAccountListResponse loanAccounts;
  LoanAccountsLoadedState({required this.loanAccounts});
}
final  class LoanAccountsErrorState  extends LoanAccountsDartState{
  final String message;

  LoanAccountsErrorState(this.message);
}


