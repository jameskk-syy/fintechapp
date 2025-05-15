import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/savings/minstatement/bloc/savings_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FullStatementWidget extends StatefulWidget {
  const FullStatementWidget({super.key});

  @override
  State<FullStatementWidget> createState() => _FullStatementWidgetState();
}

class _FullStatementWidgetState extends State<FullStatementWidget> {
  final SavingsBloc _savingsBloc = SavingsBloc();
  void downloadFullStatement(String phoneNumber) {
    _savingsBloc.add(SavingFullStatementEvent());
  }
  @override
void dispose() {
  _savingsBloc.close(); // ✅ This disposes the BLoC stream
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavingsBloc, SavingsState>(
      bloc: _savingsBloc,
      listenWhen: (previous, current) => current  is SavingActionState,
      buildWhen: (previous, current) =>  current is! SavingActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SavingsLoadingState) {
          return Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitThreeInOut(color: greenColor, size: 50.0),
                  SizedBox(height: 16),
                  Text(
                    "Please wait, while downloading statement...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
          );
        } else if (state is SavingsLoadedsState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message:
                  state.message,
            ),
          );
          });
        }
        return downloadStatement();
      },
    );
  }

  Widget downloadStatement(){
    return Scaffold(
          body: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    downloadFullStatement("25467097867");
                  },
                  icon: Icon(Icons.download),
                  label: Text("Download Full Mini Statement"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // <- Rounded corners here
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
