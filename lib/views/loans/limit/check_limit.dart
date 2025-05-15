import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/loans/limit/bloc/check_limit_bloc.dart';

class CheckLimitPage extends StatefulWidget {
  final String productName;
  const CheckLimitPage({super.key, required this.productName});

  @override
  State<CheckLimitPage> createState() => _CheckLimitPageState();
}

class _CheckLimitPageState extends State<CheckLimitPage> {
  final CheckLimitBloc _checkLimitBloc = CheckLimitBloc();

  @override
  void initState() {
    super.initState();
    _checkLimitBloc.add(CheckLimitRequestEvent(phoneNumber: "25467097867"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: whiteColor),
        title: Text("Loan Limit", style: TextStyle(color: whiteColor)),
        backgroundColor: greenColor,
      ),
      body: BlocBuilder<CheckLimitBloc, CheckLimitState>(
        bloc: _checkLimitBloc,
        builder: (context, state) {
          Widget content;

          if (state is CheckLimitLoadingState) {
            content = Column(
              children: [
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.001,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 30,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SpinKitThreeInOut(color: greenColor, size: 30.0),
                              SizedBox(height: 16),
                              Text(
                                "Please wait, while loading...",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CheckLimitLoadedState) {
            final data = state.checkLimitResponse;
            content = Column(
              children: [
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.001,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Loan Balance",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(data.loanBalance?.toString() ?? "-"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Loan Limit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(data.limit?.toString() ?? "-"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Product Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(widget.productName ?? "-"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CheckLimitErrorState) {
            content = Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          } else {
            content = SizedBox.shrink();
          }

          return content;
        },
      ),
    );
  }
}
