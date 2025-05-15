import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/InternetConnectivity/check_internet.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/homescreen/home_screen.dart';
import 'package:saccoapp/views/loans/pay-loan/widgets/bloc/loan_repayment_dart_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FormWidget extends StatefulWidget {
  final String title;
  final String accountNumber;

  const FormWidget({
    super.key,
    required this.title,
    required this.accountNumber,
  });

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final LoanRepaymentDartBloc _payLoanBloc = LoanRepaymentDartBloc();

  @override
  void initState() {
    super.initState();
    setPhoneNumber();
  }
  void setPhoneNumber(){
    setState(() {
       _phoneController.text = "25467097867";
    });
  }
  Future<void> _saveData() async {
    final phone = _phoneController.text;
    final amount = _amountController.text;

    if (phone.isEmpty || amount.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: "Phone and amount are required"),
      );
      return;
    }
    bool isConnected = await CheckInternetCon.checkConnection();

    if (!isConnected) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message:
              'No internet connection. Please check your connection and try again.',
        ),
      );
      return;
    }
    if (widget.title == "Pay Through Savings") {
      _payLoanBloc.add(
        LoanRepaymentDartSavingsEvent(
          phoneNumber: phone,
          amount: amount,
          accountNumber: widget.accountNumber,
        ),
      );
    } else if (widget.title == "Pay Through Mobile Money") {
      _payLoanBloc.add(
        LoanRepyamentDartMobileEvent(
          phoneNumber: phone,
          amount: amount,
          accountNumber: widget.accountNumber,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoanRepaymentDartBloc, LoanRepaymentDartState>(
      bloc: _payLoanBloc,
      listenWhen: (previous, current) => current is LoanReymentDartActionState,
      buildWhen: (previous, current) => current is! LoanReymentDartActionState,
      listener: (context, state) {
        if (state is LoanRepaymentSuccessState) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(message: state.message),
          );
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home())); // Close bottom sheet
          });
        } else if (state is LoanRepaymentErrorState) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.message),
          );
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop(); // Close bottom sheet
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          readOnly: true,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Amount",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: _saveData,
                            child: Text(
                              "Save",
                              style: TextStyle(color: whiteColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                if (state is LoanRepaymentLoadingState)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(child:  Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitThreeInOut(color: greenColor, size: 50.0),
                  const SizedBox(height: 16),
                  const Text(
                    "Please wait for a while...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
