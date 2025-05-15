part of 'check_limit_bloc.dart';

@immutable
sealed class CheckLimitState {}

final class CheckLimitInitial extends CheckLimitState {}
final class CheckLimitActionState extends CheckLimitState{}
final class CheckLimitLoadingState extends CheckLimitActionState{}
final class CheckLimitLoadedState extends CheckLimitState{
  final CheckLimitResponse checkLimitResponse;

  CheckLimitLoadedState({required this.checkLimitResponse});
}
final class CheckLimitErrorState extends CheckLimitActionState{
  final String message;

  CheckLimitErrorState({required this.message});
}
