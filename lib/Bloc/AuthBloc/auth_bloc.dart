import 'dart:convert';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {

    // LOGIN
    on<AuthLoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        developer.log('body: ${event.email} and ${event.password}');
        final url = ApiConstants.baseUrl + ApiConstants.login;
        developer.log('url: $url');

        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': event.email,
            'password': event.password,
          }),
        );
        developer.log('data: ${response.body}');

        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          emit(LoginSuccess(response: data));
        } else {
          emit(LoginError(message: data['message'] ?? 'Login failed'));
        }
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    });

    // REGISTER
    on<AuthRegisterRequested>((event, emit) async {
      emit(RegisterLoading());

      try {
        // Create a map with all fields (including optional)
        final Map<String, dynamic> body = {
          'businessName': event.businessName,
          'personalName': event.name,
          'email': event.email,
          'phone': event.phone,
          'gstNumber': event.gst,
          'businessAddr': event.address,
        };
        developer.log('body: $body');

        // Remove all null or empty values
        final filteredBody = body..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

        developer.log('filteredBody: $filteredBody');
        final url = ApiConstants.baseUrl + ApiConstants.signup;
        developer.log('url: $url');

        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(filteredBody),
        );
        developer.log('data: ${response.body}');
        developer.log('statusCode: ${response.statusCode}');
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          emit(RegisterSuccess(response: data));
        } else {
          emit(RegisterError(message: data['message'] ?? 'Registration failed'));
        }
      } catch (e) {
        emit(RegisterError(message: e.toString()));
      }
    });
  }
}
