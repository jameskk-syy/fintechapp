import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saccoapp/data/repositories/auth_repo.dart';
import 'package:saccoapp/data/responses/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'logins_event.dart';
part 'logins_state.dart';

class LoginsBloc extends Bloc<LoginsEvent, LoginsState> {
   bool isPasswordVisible = false; 
  LoginsBloc() : super(LoginsInitial()) {
    on<LoginButtonClickEvent>(loginButtonClickEvent);
    on<LoginNavigateToResetPasswordEvent>(loginNavigateToResetPasswordEvent);
    on<LoginTogglePasswordEvent>(loginTogglePasswordEvent);
    on<ResetLoginEvent>((event, emit) {
     emit(LoginsInitial());
});
  }
  
Future<void> loginButtonClickEvent(
    LoginButtonClickEvent event, Emitter<LoginsState> emit) async {
  emit(LoginLoadingState());
  try {
    final username = event.username;
    final password = event.password;

    final loginResponse = await LoginRepository.login(username, password);
    final entity = loginResponse.entity;

    print("Login response entity: $entity");

    final roles = entity['roles'] as List;
    final isSuperUser = roles.any((role) => role['name'] == 'ROLE_SUPERUSER');

    if (isSuperUser) {
      // Safely extract fields
      final String token = entity['token'] ?? '';
      final String username = entity['username'] ?? '';
      final String email = entity['email'] ?? '';
      final String firstName = entity['firstName'] ?? '';
      final String lastName = entity['lastName'] ?? '';
      final String name = '$firstName $lastName';
      final String nationalId = entity['nationalId'] ?? 'N/A'; // fallback if missing
      final String entityId = entity['entityId'] ?? '';
     final String phoneNumber = entity.containsKey('phoneNumber') && entity['phoneNumber'] != null
    ? entity['phoneNumber']
    : '';
      // Print for debugging
      print("Your name is $name, email is $email, national ID is $nationalId and phoneNumber  is $phoneNumber");

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('username', username);
      await prefs.setString('email', email);
      await prefs.setString('name', name);
      await prefs.setString('nationalId', nationalId);
      await prefs.setString('entityId', entityId);
      await prefs.setString('phoneNumber', phoneNumber);

      emit(LoginSuccessful(loginResponse: loginResponse));
    } else {
      emit(LoginErrorState(error: "Access restricted, please contact admin"));
    }
  } catch (e) {
    print("Login error: $e");
    emit(LoginErrorState(error: "An error occurred during login."));
  }
}

  FutureOr<void> loginNavigateToResetPasswordEvent(LoginNavigateToResetPasswordEvent event, Emitter<LoginsState> emit) {
  }

  FutureOr<void> loginTogglePasswordEvent(LoginTogglePasswordEvent event, Emitter<LoginsState> emit) {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginTogglePasswordState(isPasswordVisible));
  }

}
