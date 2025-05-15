import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/loan_repo.dart';
import 'package:saccoapp/data/responses/apply_loan_response.dart';

part 'apply_loan_event.dart';
part 'apply_loan_state.dart';

class ApplyLoanBloc extends Bloc<ApplyLoanEvent, ApplyLoanState> {
  ApplyLoanBloc() : super(ApplyLoanInitial()) {
    on<ApplyLoanRequestEvent>(applyLoanRequestEvent);
  }

  Future<void> applyLoanRequestEvent(ApplyLoanRequestEvent event, Emitter<ApplyLoanState> emit) async {
    emit(ApplyLoanLoadingState());
    try {
      ApplyLoanResponse applyLoanResponse =  await LoanRepository.applyLoan(event.phoneNumber, event.productName, event.amount);
      if(applyLoanResponse.statusCode == "S0"){
        emit(ApplyLoanLoadedState(message: applyLoanResponse.message));
      }
      else{
        emit(ApplyLoanErrorState(message: applyLoanResponse.message));
      }
    } catch (e) {
       emit(ApplyLoanErrorState(message: "Something wrong happened"));
      print(e); 
    }
  }
}
