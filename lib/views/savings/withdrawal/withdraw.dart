import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/InternetConnectivity/check_internet.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/savings/withdrawal/bloc/withdraws_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final WithdrawsBloc withdrawsBloc = WithdrawsBloc();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setPhoneNumber();
  }

  void setPhoneNumber() {
    setState(() {
      phoneNumberController.text = "25467097867";
    });
  }

  Future<void> _withdrawMoney() async {
    if (phoneNumberController.text.isNotEmpty &&
        amountController.text.isNotEmpty) {
      String phoneNumber = phoneNumberController.text;
      String amount = amountController.text;
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

      setState(() {
        isLoading = true;
      });

      withdrawsBloc.add(
        WithdrawButtonClicked(phoneNumber: phoneNumber, amount: amount),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Phone number or Amount cannot be empty',
        ),
      );
    }
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WithdrawsBloc, WithdrawsState>(
      bloc: withdrawsBloc,
      listenWhen: (previous, current) => current is WithdrawActionState,
      buildWhen: (previous, current) => current is! WithdrawActionState,
      listener: (context, state) {
        if (state is WithdrawsSuccessState) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(message: state.message),
          );
          setState(() {
            isLoading = false;
          });
          phoneNumberController.clear();
          amountController.clear();
        } else if (state is WithdrawsErrorState) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.error),
          );
          setState(() {
            isLoading = false;
          });
        }
      },
      builder: (context, state) {
        return buildWithDrawForm();
      },
    );
  }

  Widget buildWithDrawForm() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Withdraw Money",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: greenColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/atm-machine.png'),
                          radius: 50,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          readOnly: true,
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Enter phone number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Enter amount',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _withdrawMoney,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff104E5C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:
                                isLoading
                                    ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: SpinKitThreeInOut(
                                        color: greenColor,
                                        size: 15.0,
                                      ),
                                    )
                                    : const Text(
                                      'Withdraw Money',
                                      style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
