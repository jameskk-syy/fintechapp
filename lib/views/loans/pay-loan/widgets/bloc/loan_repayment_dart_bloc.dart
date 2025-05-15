import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/loan_repo.dart';
import 'package:saccoapp/data/responses/loan_repayment_response.dart';
import 'package:saccoapp/data/responses/loan_saving_repayment.dart';

part 'loan_repayment_dart_event.dart';
part 'loan_repayment_dart_state.dart';

class LoanRepaymentDartBloc extends Bloc<LoanRepaymentDartEvent, LoanRepaymentDartState> {
  LoanRepaymentDartBloc() : super(LoanRepaymentDartInitial()) {
    on<LoanRepaymentDartSavingsEvent>(loanRepaymentDartSavingsEvent);
    on<LoanRepyamentDartMobileEvent>(loanRepyamentDartMobileEvent);
  }

  Future<void> loanRepaymentDartSavingsEvent(LoanRepaymentDartSavingsEvent event, Emitter<LoanRepaymentDartState> emit) async {
    emit(LoanRepaymentLoadingState());
    try {
     SavingRepaymentResponse loanRepaymentResponse =  await LoanRepository.payLoanBack(event.phoneNumber, event.accountNumber);
     if(loanRepaymentResponse.statusCode == "S0"){
        emit(LoanRepaymentSuccessState(message: loanRepaymentResponse.message));
     }
     else if(loanRepaymentResponse.statusCode == "S1"){
      emit(LoanRepaymentErrorState(message: loanRepaymentResponse.message));
     }
    } catch (e) {
      emit(LoanRepaymentErrorState(message: "Something wrong happened"));
      print(e);
    }
  }

  Future<void> loanRepyamentDartMobileEvent(LoanRepyamentDartMobileEvent event, Emitter<LoanRepaymentDartState> emit) async {
      emit(LoanRepaymentLoadingState());
    try {
     LoanRepaymentResponse loanRepaymentResponse =  await LoanRepository.payMobileLoanBack(event.phoneNumber, event.accountNumber,event.amount);
     if(loanRepaymentResponse.statusCode == "S0"){
        emit(LoanRepaymentSuccessState(message: loanRepaymentResponse.message));
     }
     else{
      emit(LoanRepaymentErrorState(message: loanRepaymentResponse.message));
     }
    } catch (e) {
      emit(LoanRepaymentErrorState(message: "Something wrong happened"));
      print(e);
    }
  }
}
