part of 'loan_account_ministatement_bloc.dart';

@immutable
sealed class LoanAccountMinistatementEvent {}
final  class  LoanAccountMiniststementInitialEvent extends LoanAccountMinistatementEvent{
   final String accountNumber;

  LoanAccountMiniststementInitialEvent(this.accountNumber);
}
