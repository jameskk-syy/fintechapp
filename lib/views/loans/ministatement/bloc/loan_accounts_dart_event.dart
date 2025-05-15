part of 'loan_accounts_dart_bloc.dart';

@immutable
sealed class LoanAccountsDartEvent {}
final class LaonAccountsInitialEvent extends LoanAccountsDartEvent{}
final  class LoanAccountCheckStatementEvent extends LoanAccountsDartEvent{}

