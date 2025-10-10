import 'dart:convert';
import 'dart:developer' as developer;
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {

    // LOGIN
    on<AuthLoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.login;
        developer.log('url login: $url');
        final body = {
          'email': event.email,
          'password': event.password,
          //'fcmToken': Prefs.getFcmToken(),
        };

        developer.log('body:$body');
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
        developer.log('response login: ${response.body}');

        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
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
          'bussinessname': event.businessName,
          'personname': event.name,
          'email': event.email,
          'phone': event.phone,
          'gstno': event.gst ?? '',
          'bussinessaddress': event.address,
        };

        // Remove all null or empty values
        final filteredBody = body..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

        final url = ApiConstants.baseUrl + ApiConstants.register;

        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(filteredBody),
        );
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
