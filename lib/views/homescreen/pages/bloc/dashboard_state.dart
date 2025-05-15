part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}
final class DashboardActionState extends DashboardState{}
final  class DashboardLoadingState extends DashboardState{}
final  class DashboardErrorState extends DashboardState{
  final String errorMessage;
  DashboardErrorState(this.errorMessage);
}
final class DashboardSuccessState extends DashboardState{
  final ProductsListResponse productsListResponse;
  DashboardSuccessState(this.productsListResponse);
}
