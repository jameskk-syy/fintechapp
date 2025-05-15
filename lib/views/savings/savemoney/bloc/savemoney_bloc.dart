import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/transaction_repo.dart';
import 'package:saccoapp/data/responses/save_money_response.dart';

part 'savemoney_event.dart';
part 'savemoney_state.dart';

class SavemoneyBloc extends Bloc<SavemoneyEvent, SavemoneyState> {
  SavemoneyBloc() : super(SavemoneyInitial()) {
    on<SavemoneyActionEvent>(savemoneyActionEvent) ;
  }

  Future<void> savemoneyActionEvent(SavemoneyActionEvent event, Emitter<SavemoneyState> emit) async {
    try {
      emit(SavemoneyLoadingState());
      
       final  SaveMoneyResponse saveMoneyResponse = await TransactionRepository.saveMoney(
        phoneNumber: event.phoneNumber,
        amount: event.amount,
       );

       print("status code ${saveMoneyResponse.statusCode}");
      // Assuming the action is successful
      if(saveMoneyResponse.statusCode != 'S0') {
        emit(SavemoneyErrorState('Failed to save money'));
        return;
      }
      emit(SavemoneySuccessState('Money saved successfully!'));
    } catch (e) {
      emit(SavemoneyErrorState('Failed to save money: ${e.toString()}'));
    }
  }
}
