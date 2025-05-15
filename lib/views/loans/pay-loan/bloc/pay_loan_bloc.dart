import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pay_loan_event.dart';
part 'pay_loan_state.dart';

class PayLoanBloc extends Bloc<PayLoanEvent, PayLoanState> {
  PayLoanBloc() : super(PayLoanInitial()) {
    on<PayLoanEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
