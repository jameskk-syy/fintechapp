import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/sharedviews/bloc/home_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AccountBalancesPages extends StatefulWidget {
  final String title;

  const AccountBalancesPages({super.key, required this.title});

  @override
  State<AccountBalancesPages> createState() => _AccountBalancesPagesState();
}

class _AccountBalancesPagesState extends State<AccountBalancesPages> {
  late HomeBloc homeBloc;
  bool showAmount = false;

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc();
    homeBloc.add(HomeInitialEvent(phoneNumber: '25467097867'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeErrorState) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.error),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is HomeLoadingState;
        String amount = '0';
        String imageUrl = '';

        if (state is HomeLoadedState) {
          if (widget.title == 'Savings Balance') {
            amount = state.transactionResponse?.balance ?? '0';
            imageUrl = 'assets/salary.png';
          } else if (widget.title == 'Loan Balance') {
            amount = state.transactionResponse?.loanBalance ?? '0';
            imageUrl = 'assets/borrow.png';
          }
        }

        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: greenColor,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BalanceCard(
              title: widget.title,
              amount: amount,
              imageUrl: imageUrl,
              showAmount: showAmount,
              isLoading: isLoading,
              onToggle: () {
                setState(() => showAmount = !showAmount);
              },
            ),
          ),
        );
      },
    );
  }
}

class BalanceCard extends StatelessWidget {
  final String title;
  final String amount;
  final String imageUrl;
  final bool showAmount;
  final bool isLoading;
  final VoidCallback onToggle;

  const BalanceCard({
    super.key,
    required this.title,
    required this.amount,
    required this.imageUrl,
    required this.showAmount,
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),
          // Overlay for text readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                isLoading
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SpinKitThreeInOut(color: whiteColor, size: 50.0),
                              SizedBox(height: 16),
                              Text(
                                "Please wait, while loading...",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    : SizedBox(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(imageUrl),
                                backgroundColor: Colors.grey[200],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  showAmount ? 'Amount: KES $amount' : '*****',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    showAmount
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white70,
                                  ),
                                  onPressed: onToggle,
                                ),
                              ],
                            ),
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
