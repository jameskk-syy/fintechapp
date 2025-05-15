part of 'savings_bloc.dart';

@immutable
sealed class SavingsEvent {}
final  class SavingsInitialEvent extends SavingsEvent{}
final  class  SavingFullStatementEvent extends SavingsEvent{}
