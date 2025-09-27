part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

// LOGIN EVENT
final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

// REGISTER EVENT
final class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String address;
  // Optional fields
  final String? gst;


  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.phone,
    this.gst,
    required this.businessName,
    required this.address,
  });
}
