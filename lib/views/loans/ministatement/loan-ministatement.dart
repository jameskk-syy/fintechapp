import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/data/responses/loan_laccount_isting_response.dart';
import 'package:saccoapp/views/homescreen/home_screen.dart';
import 'package:saccoapp/views/loans/ministatement/LoanAccountStatement/loan_account_statements.dart';
import 'package:saccoapp/views/loans/ministatement/bloc/loan_accounts_dart_bloc.dart';
import 'package:saccoapp/views/loans/pay-loan/pay_loan.dart';

class LoanMiniStatement extends StatefulWidget {
  final String? action;

  const LoanMiniStatement({super.key, this.action});

  @override
  State<LoanMiniStatement> createState() => _LoanMiniStatementState();
}

class _LoanMiniStatementState extends State<LoanMiniStatement> {
  final LoanAccountsDartBloc _loanAccountsDartBloc = LoanAccountsDartBloc();

  @override
  void initState() {
    super.initState();
    _loanAccountsDartBloc.add(LaonAccountsInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoanAccountsDartBloc, LoanAccountsDartState>(
      bloc: _loanAccountsDartBloc,
      listenWhen: (previous, current) => current is LoanAccountsActionState,
      buildWhen: (previous, current) => current is! LoanAccountsActionState,
      listener: (context, state) {
        if (state is LoanAccountsActionState) {
          // handle actions
        }
      },
      builder: (context, state) {
        Widget bodyContent;

        if (state is LoanAccountsLoadingState) {
          bodyContent = Center(
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
        } else if (state is LoanAccountsLoadedState) {
          bodyContent = statementList(state.loanAccounts, widget.action);
        } else {
          bodyContent = const Center(child: Text('No data found'));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: greenColor,
            title: const Text(
              "Loan Accounts",
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: bodyContent,
        );
      },
    );
  }

  Widget statementList(LoanAccountListResponse loanAccounts, String? action) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: loanAccounts.loanAccounts.length,
      itemBuilder: (BuildContext context, int index) {
        final item = loanAccounts.loanAccounts[index];
        return ministatementCard(item, action);
      },
    );
  }

  Widget ministatementCard(LoanAccounts item, String? action) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Number and Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Account Number",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.accountNumber,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Account Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.accountName,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Account Balance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.accountBalance.toString(),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    String accountNumber = item.accountNumber;
                    if (action == "Mini Statement") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => LoanAccountStatement(accountNumber),
                        ),
                      );
                    } else if (action == "Pay Loan") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PayLoan(accountBalance: item.accountBalance, accountNumber: item.accountNumber, accountName: item.accountName,),
                        ),
                      );
                       
                    }
                  },
                  icon: const Icon(Icons.visibility),
                  label: Text(action ?? 'View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
