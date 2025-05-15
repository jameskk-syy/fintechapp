import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/transaction_repo.dart';
import 'package:saccoapp/data/responses/fullstatement.dart';
import 'package:saccoapp/data/responses/saving_min_response.dart';

part 'savings_event.dart';
part 'savings_state.dart';

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  SavingsBloc() : super(SavingsInitial()) {
    on<SavingsInitialEvent>(savingsInitialEvent);
    on<SavingFullStatementEvent>(savingFullStatementEvent);
  }

  Future<void> savingsInitialEvent(
    SavingsInitialEvent event,
    Emitter<SavingsState> emit,
  ) async {
    emit(SavingsLoadingState());
    try {
      final MiniStatementResponse miniStatementEntry = await TransactionRepository.getSavingsMiniStatement(phoneNumber: "25467097867");
      if(miniStatementEntry.statusCode == "S0"){
      emit(SavingsLoadedState(entries: miniStatementEntry.entries));
      }
      else{
        emit(SavingsErrorState(message: "no  data found"));
      }
    } catch (e) {
       emit(SavingsErrorState(message: "An error  ocurred"));
    }
  }

  Future<void> savingFullStatementEvent(SavingFullStatementEvent event, Emitter<SavingsState> emit) async {
     emit(SavingsLoadingState());
    try {
      final FullSavingStatementResponse miniStatementEntry = await TransactionRepository.getFullStatement(phoneNumber: "25467097867");
      if(miniStatementEntry.statusCode == "S0"){
      emit(SavingsLoadedsState(message: "Full statement sent,  please check  your email"));
      }
      else{
        emit(SavingsErrorState(message: "no  data found"));
      }
    } catch (e) {
       emit(SavingsErrorState(message: "An error  ocurred"));
    }
  }
}
