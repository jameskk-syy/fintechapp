import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/loan_repo.dart';
import 'package:saccoapp/data/responses/loan_mini_statement_response.dart';
import 'package:saccoapp/views/loans/ministatement/bloc/loan_accounts_dart_bloc.dart';

part 'loan_account_ministatement_event.dart';
part 'loan_account_ministatement_state.dart';

class LoanAccountMinistatementBloc extends Bloc<LoanAccountMinistatementEvent, LoanAccountMinistatementState> {
  LoanAccountMinistatementBloc() : super(LoanAccountMinistatementInitial()) {
    on<LoanAccountMiniststementInitialEvent>(loanAccountMiniststementInitialEvent);
  }

  Future<void> loanAccountMiniststementInitialEvent(LoanAccountMiniststementInitialEvent event, Emitter<LoanAccountMinistatementState> emit) async {
    emit(LoanAccountMinistatementLoading());
    print(event.accountNumber);
    try {
      LoanMiniStatementResponse loanMiniStatementResponse =  await LoanRepository.
      getLoanAccountMiniStatement("25467097867", event.accountNumber); 

      if(loanMiniStatementResponse.statusCode == "S0"){
       emit(LoanAccountMinstatementLoadedState(loanMiniStatementResponse));
      }
      else{
       emit(LoanAccountMiniStatementErrorState(message: "no loan mini statement  found"));
      }
    } catch (e) {
      emit(LoanAccountMiniStatementErrorState(message: "something wrong happened"));
    }
  }
}
