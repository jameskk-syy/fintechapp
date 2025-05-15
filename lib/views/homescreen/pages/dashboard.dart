import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/core/httpInterceptor/shared_data.dart';
import 'package:saccoapp/data/responses/productsListResponse.dart';
import 'package:saccoapp/views/homescreen/pages/bloc/dashboard_bloc.dart';
import 'package:saccoapp/views/loans/applyLoan/apply_loan.dart';
import 'package:saccoapp/views/loans/ministatement/loan-ministatement.dart';
import 'package:saccoapp/views/loans/product/laon_products.dart';
import 'package:saccoapp/views/savings/minstatement/ministatement.dart';
import 'package:saccoapp/views/savings/savemoney/save_money.dart';
import 'package:saccoapp/views/sharedviews/account_balance.dart';
import 'package:saccoapp/views/savings/withdrawal/withdraw.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String username = "";
  String greetings = "";
  late final DashboardBloc dashboardBloc;
  final String userName = "Enjelin Morgeana";
  final String balance = "1,000.00";
  final List<Map<String, String>> promoCards = [
    {
      'title': 'Save with us',
      'subtitle': 'as we improve your financial status',
    },
    {
      'title': 'Apply loan with us',
      'subtitle': 'as we offer low interest rate',
    },
  ];

  @override
  void initState() {
    super.initState();
    dashboardBloc = DashboardBloc(); // Initialize properly
    _initializeData();
    dashboardBloc.add(DashboardInitialEvent());
  }

  Future<void> _initializeData() async {
    try {
      final now = DateTime.now();
      String timeGreeting;

      if (now.hour < 12) {
        timeGreeting = "Good morning";
      } else if (now.hour < 17) {
        timeGreeting = "Good afternoon";
      } else {
        timeGreeting = "Good evening";
      }

      final userData = await UserData.getUserData();
      final usernames = userData['name']!;
      print(usernames);
      if (mounted) {
        setState(() {
          username = usernames;
          greetings = timeGreeting;
        });
      }
    } catch (e) {
      debugPrint("Error initializing data: $e");
      // Set default values if there's an error
      if (mounted) {
        setState(() {
          username = "User";
          greetings = "Welcome";
        });
      }
    }
  }

  @override
  void dispose() {
    dashboardBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocProvider<DashboardBloc>.value(
        value: dashboardBloc,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _head(),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Savings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 20,
                    ),
                    child: Icon(Icons.more_horiz, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width * 0.99,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildActionCard(
                            context: context,
                            icon: 'assets/wallet.png',
                            label: 'Save Money',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SaveMoney(),
                                ),
                              );
                            },
                          ),
                          _buildActionCard(
                            context: context,
                            icon: 'assets/atm-machine.png',
                            label: 'Withdraw Money',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WithdrawPage(),
                                ),
                              );
                            },
                          ),
                          _buildActionCard(
                            context: context,
                            icon: 'assets/bank-statement.png',
                            label: 'Account Statement',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const MiniStatementPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildActionCard(
                          context: context,
                          icon: 'assets/bank.png',
                          label: 'Savings Balance',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AccountBalancesPages(
                                      title: 'Savings Balance',
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Our Products',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 20,
                      ),
                      child: Text(
                        "See all",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ProductListing(dashboardBloc: dashboardBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(icon),
                onBackgroundImageError: (exception, stackTrace) {
                  debugPrint('Error loading image: $icon');
                },
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(color: greenColor),
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    right: 10,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(250, 250, 250, 0.1),
                          ),
                          child: const CircleAvatar(
                            backgroundImage: AssetImage('assets/user.png'),
                            radius: 20,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greetings ,',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 140),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(47, 125, 121, 0.3),
                    offset: const Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: 6,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Loans',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Icon(Icons.more_horiz, color: Colors.black),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLoanActionItem(
                        icon: 'assets/borrow.png',
                        label: 'Apply Loan',
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LoanProductsListing(
                                      action: "Apply Loan",
                                    ),
                              ),
                            ),
                      ),
                      _buildLoanActionItem(
                        icon: 'assets/deposit.png',
                        label: 'Pay Loan',
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        LoanMiniStatement(action: "Pay Loan"),
                              ),
                            ),
                      ),
                      _buildLoanActionItem(
                        icon: 'assets/atm-machine.png',
                        label: 'Loan Limit',
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LoanProductsListing(
                                      action: "Check Limit",
                                    ),
                              ),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLoanActionItem(
                        icon: 'assets/bank-statement.png',
                        label: 'Mini Statement',
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LoanMiniStatement(
                                      action: "Mini Statement",
                                    ),
                              ),
                            ),
                      ),
                      _buildLoanActionItem(
                        icon: 'assets/bank.png',
                        label: 'Loan Balance',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AccountBalancesPages(
                                    title: 'Loan Balance',
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanActionItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(icon),
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('Error loading image: $icon');
            },
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListing extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  const ProductListing({super.key, required this.dashboardBloc});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      listenWhen: (previous, current) => current is DashboardActionState,
      buildWhen: (previous, current) => current is! DashboardActionState,
      listener: (context, state) {
        // Handle action states if needed
        if (state is DashboardErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        if (state is DashboardLoadingState) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitThreeInOut(color: greenColor, size: 40.0),
                  const SizedBox(height: 16),
                  const Text(
                    "Please wait, while loading...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is DashboardSuccessState) {
          // Check if there are products to display
          final products = state.productsListResponse.loans;
          if (products == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("No products available at the moment"),
              ),
            );
          }

          return _buildProductsList(context, products);
        } else if (state is DashboardErrorState) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Error: ${state.errorMessage}"),
            ),
          );
        }

        // Default/initial state
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitThreeInOut(color: greenColor, size: 40.0),
              const SizedBox(height: 16),
              const Text(
                "Please wait, while loading...",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsList(BuildContext context, List<LoanProduct> products) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              // Check if product data is available
              final product = products[index];
              return _buildPromoCard(
                context: context,
                title: product.productName ?? "New Product",
                productCode: product.productCode ?? "",
                description:
                    "Check out our new product offering, you can apply upto ${product.maxApplicationAmount}",
                backgroundImage: "assets/bank.png",
                duration:product.maxRepaymentPeriod, // Use default image
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPromoCard({
    required BuildContext context,
    required String title,
    required String productCode,
    required String description,
    required String backgroundImage, 
    required int duration,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.blue, // Fallback color in case image fails
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
          onError: (exception, stackTrace) {
            debugPrint('Error loading background image: $backgroundImage');
          },
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLoanPage(duartion: duration.toString(), productCode: productCode,)));
                    // Handle product application
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: greenColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
