import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/loan_repo.dart';
import 'package:saccoapp/data/responses/check_limit_response.dart';

part 'check_limit_event.dart';
part 'check_limit_state.dart';

class CheckLimitBloc extends Bloc<CheckLimitEvent, CheckLimitState> {
  CheckLimitBloc() : super(CheckLimitInitial()) {
    on<CheckLimitRequestEvent>(checkLimitRequestEvent);
  }

  Future<void> checkLimitRequestEvent(CheckLimitRequestEvent event, Emitter<CheckLimitState> emit) async {
    emit(CheckLimitLoadingState());
    try {
       CheckLimitResponse checkLimitResponse =  await LoanRepository.checkLoanLimit(event.phoneNumber);
       if(checkLimitResponse.statusCode == "S0"){
        print(checkLimitResponse.limit);
        emit(CheckLimitLoadedState(checkLimitResponse: checkLimitResponse));
       }
       else{
        emit(CheckLimitErrorState(message: checkLimitResponse.message));
       }
    } catch (e) {
      print(e);
      emit(CheckLimitErrorState(message: "Something wrong happend"));
    }
  }
}
