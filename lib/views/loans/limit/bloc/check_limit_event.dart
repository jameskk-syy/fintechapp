part of 'check_limit_bloc.dart';

@immutable
sealed class CheckLimitEvent {}
final  class CheckLimitRequestEvent extends CheckLimitEvent{
  final String phoneNumber;

  CheckLimitRequestEvent({required this.phoneNumber});
}
