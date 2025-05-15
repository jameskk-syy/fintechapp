import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/data/responses/productsListResponse.dart';
import 'package:saccoapp/views/homescreen/home_screen.dart';
import 'package:saccoapp/views/homescreen/pages/bloc/dashboard_bloc.dart';
import 'package:saccoapp/views/loans/applyLoan/apply_loan.dart';
import 'package:saccoapp/views/loans/limit/check_limit.dart';

class LoanProductsListing extends StatefulWidget {
  final String? action;

  const LoanProductsListing({super.key, this.action});

  @override
  State<LoanProductsListing> createState() => _LoanProductsListingState();
}

class _LoanProductsListingState extends State<LoanProductsListing> {
  final DashboardBloc _dashboardBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _dashboardBloc.add(DashboardInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          "Loan Listing",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: greenColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
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
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: _dashboardBloc,
        listenWhen: (previous, current) => current is DashboardActionState,
        buildWhen: (previous, current) => current is! DashboardActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DashboardLoadingState) {
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
          } else if (state is DashboardSuccessState) {
            return Column(
              children: [
                Expanded(
                  child: statementList(state.productsListResponse.loans),
                ),
              ],
            );
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }

  Widget statementList(List<LoanProduct> loans) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: loans.length,
      itemBuilder: (BuildContext context, int index) {
        final item = loans[index];
        return LoanCard(item);
      },
    );
  }

  Widget LoanCard(LoanProduct item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Product Name & Max Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      item.productName,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Apply Up to",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "${item.maxApplicationAmount}",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Repayment + Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Repayment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "${item.maxRepaymentPeriod}",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (widget.action == "Apply Loan") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ApplyLoanPage(
                                productCode: item.productName,
                                duartion: item.maxRepaymentPeriod.toString(),
                              ),
                        ),
                      );
                    } else if (widget.action == "Check Limit") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CheckLimitPage(productName:item.productName),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: Text(widget.action ?? ''),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
