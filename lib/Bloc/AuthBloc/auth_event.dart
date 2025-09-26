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
  final String password;
  final String contact;

  // Optional fields
  final String? gst;
  final String? businessName;
  final String? address;

  AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.contact,
    this.gst,
    this.businessName,
    this.address,
  });
}
