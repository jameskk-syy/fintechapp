import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/loans/pay-loan/widgets/pay_loan_component.dart';

class PayLoan extends StatefulWidget {
  final double accountBalance;
  final String accountName;
  final String accountNumber;

  const PayLoan({super.key ,  required this.accountBalance, required this.accountName,required this.accountNumber});

  @override
  State<PayLoan> createState() => _PayLoanState();
}

class _PayLoanState extends State<PayLoan> {
  void _showBottomSheet(BuildContext context, String title) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => FormWidget(title: title,accountNumber:widget.accountNumber),  // Pass the title
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: greenColor,
        title: Text(
          "Pay Loan here",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with Account Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Number",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(widget.accountNumber, style: TextStyle(fontSize: 13)),
                        ],
                      ),
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          "Account Balance",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          ),
                          SizedBox(height: 2),
                          Text(widget.accountBalance.toString(), style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Second row with buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Pay through Savings
                            _showBottomSheet(context,"Pay Through Savings");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4), // small radius
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text("Savings", style: TextStyle(fontSize: 13, color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Pay by Mobile Money
                            _showBottomSheet(context,"Pay Through Mobile Money");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4), // small radius
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text("Mobile Money", style: TextStyle(fontSize: 13,color:Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
