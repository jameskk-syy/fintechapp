import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/InternetConnectivity/check_internet.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/savings/savemoney/bloc/savemoney_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SaveMoney extends StatefulWidget {
  const SaveMoney({super.key});

  @override
  State<SaveMoney> createState() => _SaveMoneyState();
}

class _SaveMoneyState extends State<SaveMoney> {
  final SavemoneyBloc _savemoneyBloc = SavemoneyBloc();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setPhoneNumber();
  }
 void setPhoneNumber(){
    setState(() {
       phoneNumberController.text = "25467097867";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Save Money", style: TextStyle(color: Colors.white)),
        backgroundColor: greenColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<SavemoneyBloc, SavemoneyState>(
        bloc: _savemoneyBloc,
        buildWhen: (previous, current) => current is! SavemoneyActionState,
        listenWhen: (previous, current) => current is SavemoneyActionState,
        listener: (context, state) {
        },
        builder: (context, state) {
          if (state is SavemoneyLoadingState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitThreeInOut(color: greenColor, size: 50.0),
                  const SizedBox(height: 16),
                  const Text(
                    "Please wait, while saving...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          }
           else if (state is SavemoneyErrorState) {
            return Center(child: Text(state.errorMessage));
          } 
          if (state is SavemoneySuccessState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.success(message: state.successMessage),
              );
              phoneNumberController.clear();
              amountController.clear();
            });
          }
            return buildSaveForm();
        },
      ),
    );
  }

  Future<void> _saveMoney() async {
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

      _savemoneyBloc.add(
        SavemoneyActionEvent(phoneNumber: phoneNumber, amount: amount),
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

  Widget buildSaveForm() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 0),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 30,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            bottom: 50,
                            right: 16,
                            top: 16,
                          ),
                          child: Form(
                            key: globalKey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/salary.png',
                                      ),
                                      radius: 50,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                TextFormField(
                                  readOnly: true,
                                  controller: phoneNumberController,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter phone number',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: amountController,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter amount',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _saveMoney,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff104E5C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'save money',
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
            ),
          ],
        ),
      ),
    );
  }
}
