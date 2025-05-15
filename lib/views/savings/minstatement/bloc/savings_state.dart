part of 'savings_bloc.dart';

@immutable
sealed class SavingsState {}

final class SavingsInitial extends SavingsState {}
final  class SavingsLoadingState extends SavingsState{}
final class SavingActionState extends SavingsState{}
final class SavingsLoadedsState extends SavingsState{
  final String  message;

  SavingsLoadedsState({required this.message});
}
final class SavingsLoadedState extends SavingsState {
  final List<MiniStatementEntry> entries;

  SavingsLoadedState({required this.entries});
}
final  class SavingsErrorState extends SavingsState{
  final String  message ;

  SavingsErrorState({required this.message});

}
