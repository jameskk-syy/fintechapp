import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/transaction_repo.dart';
import 'package:saccoapp/data/responses/account_balance_response.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeIntialEvent);
  }

  FutureOr<void> homeIntialEvent(HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
  try {
    final phoneNumber = event.phoneNumber;

    final accountBalanceResponse = await TransactionRepository.getAccountBalance(phoneNumber);
    print(accountBalanceResponse.balance);
    emit(HomeLoadedState(transactionResponse: accountBalanceResponse));
  } catch (e) {
    emit(HomeErrorState(error: "An error occurred"));
  }
  }
}
