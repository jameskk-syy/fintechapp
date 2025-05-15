import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/data/responses/saving_min_response.dart';
import 'package:saccoapp/views/homescreen/home_screen.dart';
import 'package:saccoapp/views/savings/minstatement/bloc/savings_bloc.dart';
import 'package:saccoapp/views/savings/minstatement/full_statement.dart';

class MiniStatementPage extends StatefulWidget {
  const MiniStatementPage({super.key});

  @override
  State<MiniStatementPage> createState() => _MiniStatementPageState();
}

class _MiniStatementPageState extends State<MiniStatementPage> {
  final SavingsBloc _savingsBloc = SavingsBloc();
  @override
  void initState() {
    super.initState();
    _savingsBloc.add(SavingsInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: greenColor,
          title: Text(
            "Savings Statements",
            style: TextStyle(color: whiteColor),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
            icon: Icon(Icons.arrow_back),
          ),
          bottom: TabBar(
            tabs: [Tab(text: 'Mini Statement'), Tab(text: 'Full Statement')],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: BlocBuilder<SavingsBloc, SavingsState>(
          bloc: _savingsBloc,
          buildWhen: (previous, current) => current is! SavingActionState,
          builder: (context, state) {
            return TabBarView(
              children: [
                // Mini Statement Tab
                if (state is SavingsLoadingState)
                  Center(child:  Column(
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
              ),)
                else if (state is SavingsLoadedState)
                  Column(
                    children: [Expanded(child: statementList(state.entries))],
                  )
                else
                  Center(child: Text("No savings statement")),

                // Full Statement Tab (always shown)
                FullStatementWidget(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget statementList(List<MiniStatementEntry> statements) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: statements.length,
      itemBuilder: (BuildContext context, int index) {
        final item = statements[index];
        return ministatementCard(item);
      },
    );
  }

  Widget ministatementCard(MiniStatementEntry item) {
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
