import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saccoapp/core/InternetConnectivity/check_internet.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/homescreen/home_screen.dart';
import 'package:saccoapp/views/login/bloc/logins_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginsBloc loginsBloc = LoginsBloc();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void _loginUser() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Username and password cannot be empty',
        ),
      );
      return;
    }
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
    loginsBloc.add(
      LoginButtonClickEvent(
        username: usernameController.text,
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginsBloc, LoginsState>(
      bloc: loginsBloc,

      // Only rebuild UI for UI-related states
      buildWhen: (previous, current) =>
          current is! LoginsActionState &&
          current is! LoginErrorState &&
          current is! LoginWrongCredentialsState,

      // Listener for one-time actions like navigation or snackbars
      listenWhen: (previous, current) =>
          current is LoginsActionState ||
          current is LoginErrorState ||
          current is LoginWrongCredentialsState,

      listener: (context, state) {
        if (state is LoginSuccessful) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else if (state is LoginTogglePasswordState) {
          setState(() {
            isPasswordVisible = state.isPasswordVisible;
          });
        } else if (state is LoginErrorState || state is LoginWrongCredentialsState) {
          final errorMessage = (state is LoginErrorState)
              ? state.error
              : (state as LoginWrongCredentialsState).error;

         showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message:
             errorMessage,
        ),
      );
          loginsBloc.add(ResetLoginEvent());
        }
      },

      builder: (context, state) {
        return buildLoginForm(isLoading: state is LoginLoadingState);
      },
    );
  }

  Widget buildLoginForm({required bool isLoading}) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xff104E5B),
                Color(0xff104E5A),
                Color(0xff104E5C),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    SizedBox(height: 100),
                    Text(
                      'Login Here',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                        Form(
                          key: globalKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter username',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Enter password',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      loginsBloc.add(
                                        LoginTogglePasswordEvent(),
                                      );
                                    },
                                    child: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Handle forgot password action
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _loginUser,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff104E5C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isLoading
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            
                                            const Text(
                                              'Logging in...',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: SpinKitThreeInOut(color: greenColor, size: 10.0),
                                            ),
                                            
                                          ],
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                ),
                              ),
                              // const SizedBox(height: 20),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     const Text(
                              //       'Don\'t have an account?',
                              //       style: TextStyle(
                              //         color: Colors.black,
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //     TextButton(
                              //       onPressed: () {
                              //         // Navigate to the registration page
                              //       },
                              //       child: const Text(
                              //         'Register',
                              //         style: TextStyle(
                              //           color: Colors.red,
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
