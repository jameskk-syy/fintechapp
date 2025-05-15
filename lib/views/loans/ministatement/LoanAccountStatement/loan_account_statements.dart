import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/data/responses/loan_mini_statement_response.dart';
import 'package:saccoapp/views/loans/ministatement/LoanAccountStatement/bloc/loan_account_ministatement_bloc.dart';

class LoanAccountStatement extends StatefulWidget {
  final String accountNumber;

  const LoanAccountStatement(this.accountNumber, {super.key});

  @override
  State<LoanAccountStatement> createState() => _LoanAccountStatementState();
}

class _LoanAccountStatementState extends State<LoanAccountStatement> {
  final LoanAccountMinistatementBloc _loanAccountMinistatementBloc =
      LoanAccountMinistatementBloc();

  @override
  void initState() {
    super.initState();
    _loanAccountMinistatementBloc.add(
      LoanAccountMiniststementInitialEvent(widget.accountNumber),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenColor,
        title: Text(
          "Loan Account Statement",
          style: TextStyle(color: whiteColor),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: BlocConsumer<
        LoanAccountMinistatementBloc,
        LoanAccountMinistatementState
      >(
        bloc: _loanAccountMinistatementBloc,
        listenWhen:
            (previous, current) =>
                current is LoanAccountMiniStatementActionState,
        buildWhen:
            (previous, current) =>
                current is! LoanAccountMiniStatementActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoanAccountMinistatementLoading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitThreeInOut(color: greenColor, size: 50.0),
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
            );
          } else if (state is LoanAccountMinstatementLoadedState) {
            return statementList(state.loanMiniStatementResponse.entries);
          } else if (state is LoanAccountMiniStatementErrorState) {
            return Center(child: Text(state.message));
          }
          return SizedBox(); // fallback widget
        },
      ),
    );
  }

  Widget statementList(List<LoanLoanMiniStatementResponse> entries) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        final item = entries[index];
        return ministatementCard(item);
      },
    );
  }

  Widget ministatementCard(LoanLoanMiniStatementResponse item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Amount and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(item.amount, style: TextStyle(fontSize: 13)),
                  ],
                ),
                Text(
                  item.date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 6),
            // Description
            Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            SizedBox(height: 2),
            Text(item.description, style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
