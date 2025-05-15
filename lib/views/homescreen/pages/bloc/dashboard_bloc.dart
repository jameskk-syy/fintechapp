import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/transaction_repo.dart';
import 'package:saccoapp/data/responses/productsListResponse.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>(dashboardInitialEvent);
  }

  Future<void> dashboardInitialEvent(DashboardEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(DashboardLoadingState());
      final ProductsListResponse productsListResponse =  await TransactionRepository.getProductsList('25467097867');
      print(productsListResponse.loans[0].productName);
      print(productsListResponse.loans[0].productCode);
      print(productsListResponse.loans[0].maxRepaymentPeriod);
      print(productsListResponse.loans[0].minApplicationAmount);
      print(productsListResponse.loans[0].maxApplicationAmount);
      print(productsListResponse.loans[0].minGuarantors);
      print(productsListResponse.loans[0].maxGuarantors);
      print(productsListResponse.statusCode);
      if (productsListResponse.statusCode != 'S0') {
        emit(DashboardErrorState('Failed to fetch products list'));
        return;
      }
      emit(DashboardSuccessState(productsListResponse));
    } catch (e) {
      emit(DashboardErrorState("Something wrong happened"));
    }
  }
}
