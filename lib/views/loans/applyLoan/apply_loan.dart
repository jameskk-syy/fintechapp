import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/loans/applyLoan/bloc/apply_loan_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ApplyLoanPage extends StatefulWidget {
  final String productCode;
  final String duartion;
  final String phoneNumber = "25467097867";
  const ApplyLoanPage({
    super.key,
    required this.productCode,
    required this.duartion,
  });

  @override
  State<ApplyLoanPage> createState() => _ApplyLoanPageState();
}

class _ApplyLoanPageState extends State<ApplyLoanPage> {
  final _formKey = GlobalKey<FormState>();
  final ApplyLoanBloc _applyLoanBloc = ApplyLoanBloc();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  bool isLoading = false; // Track loading state locally

  @override
  void initState() {
    super.initState();
    phoneNumber.text = widget.phoneNumber;
    durationController.text = widget.duartion;
  }

  @override
  void dispose() {
    amountController.dispose();
    durationController.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  void submitLoanApplication() {
    if (amountController.text.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: 'Loan amount cannot be empty'),
      );
      return;
    }

    _applyLoanBloc.add(
      ApplyLoanRequestEvent(
        phoneNumber: phoneNumber.text,
        productName: widget.productCode,
        amount: amountController.text,
      ),
    );
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: greenColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplyLoanBloc, ApplyLoanState>(
      bloc: _applyLoanBloc,
      listenWhen: (previous, current) => current is ApplyLoanActionState,
      buildWhen: (previous, current) => current is! ApplyLoanActionState,
      listener: (context, state) {
        if (state is ApplyLoanLoadingState) {
          setState(() => isLoading = true);
        }

        if (state is ApplyLoanLoadedState) {
          setState(() => isLoading = false);
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(message: state.message),
          );
          amountController.clear(); // clear only the amount
          Navigator.pop(context); // go back after success
        }

        if (state is ApplyLoanErrorState) {
          setState(() => isLoading = false);
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: greenColor,
            title: Text("Apply Loan here", style: TextStyle(color: whiteColor)),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: whiteColor),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 30),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: buildInputDecoration("Loan Amount"),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            readOnly: true,
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            decoration: buildInputDecoration(
                              "Repayment Duration (months)",
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            readOnly: true,
                            controller: phoneNumber,
                            keyboardType: TextInputType.number,
                            decoration: buildInputDecoration("Phone Number"),
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  isLoading ? null : submitLoanApplication,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child:
                                  isLoading
                                      ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: whiteColor,
                                        ),
                                      )
                                      : Text(
                                        "Submit",
                                        style: TextStyle(color: whiteColor),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
