import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/loan_repo.dart';
import 'package:saccoapp/data/responses/loan_laccount_isting_response.dart';
import 'package:saccoapp/views/loans/ministatement/bloc/loan_accounts_dart_bloc.dart';

part 'loan_accounts_dart_event.dart';
part 'loan_accounts_dart_state.dart';

class LoanAccountsDartBloc extends Bloc<LoanAccountsDartEvent, LoanAccountsDartState> {
  LoanAccountsDartBloc() : super(LoanAccountsDartInitial()) {
    on<LaonAccountsInitialEvent>(laonAccountsInitialEvent);
    on<LoanAccountCheckStatementEvent>(loanAccountCheckStatementEvent);
  }

  Future<void> laonAccountsInitialEvent(LaonAccountsInitialEvent event, Emitter<LoanAccountsDartState> emit) async {
    emit(LoanAccountsLoadingState());
    try {
      final LoanAccountListResponse loanAccountListResponse =  await LoanRepository.getLoanAccounts("25467097867");
      if(loanAccountListResponse.statusCode == "S0"){
        emit(LoanAccountsLoadedState(loanAccounts: loanAccountListResponse));
      }
      else{
        emit(LoanAccountsErrorState("no loan accounts found"));
      }
    } catch (e) {
      emit(LoanAccountsErrorState("Something wrong happend"));
    }
  }

  FutureOr<void> loanAccountCheckStatementEvent(LoanAccountCheckStatementEvent event, Emitter<LoanAccountsDartState> emit) {
  }
}
