import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/transaction_repo.dart';
import 'package:saccoapp/data/responses/withdraw_money_response.dart';

part 'withdraws_event.dart';
part 'withdraws_state.dart';

class WithdrawsBloc extends Bloc<WithdrawsEvent, WithdrawsState> {
  WithdrawsBloc() : super(WithdrawsInitial()) {
    on<WithdrawButtonClicked>(withdrawButtonClicked);
  }

  Future<void> withdrawButtonClicked(WithdrawButtonClicked event, Emitter<WithdrawsState> emit) async {
    print("clicked  me");
    emit(WithdrawsLoadingState());
    try {
      final WithdrawMoneyResponse withdrawMoneyResponse =  await TransactionRepository.withdrawMoney
      (phoneNumber: event.phoneNumber, amount: event.amount);
      
      if (withdrawMoneyResponse.statusCode == 'S0') {
        emit(WithdrawsSuccessState(message: withdrawMoneyResponse.message));
      } else {
        emit(WithdrawsErrorState(error: withdrawMoneyResponse.message));
      }
    } catch (e) {
      emit(WithdrawsErrorState(error: "Something wrong happened"));
    }
  }

}
