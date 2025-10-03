part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

/// Fetch the current user profile
final class FetchProfileEventHandler extends ProfileEvent {
  final String userToken;
  FetchProfileEventHandler({required this.userToken});
}

/// Update user profile
final class UpdateProfileEventHandler extends ProfileEvent {
  final String? name;
  final String? phone;
  final String? businessName;
  final String? gst;
  final String? address;
  final String? email;

  UpdateProfileEventHandler({
    this.name,
    this.phone,
    this.businessName,
    this.gst,
    this.address,
    this.email,
  });
}
