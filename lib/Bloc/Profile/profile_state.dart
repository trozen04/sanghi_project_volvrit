part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

/// ----- FETCH -----
final class ProfileLoading extends ProfileState {}
final class ProfileLoaded extends ProfileState {
  final profileData;
  ProfileLoaded(this.profileData);
}
final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

/// ----- UPDATE -----
final class ProfileUpdating extends ProfileState {}
final class ProfileUpdated extends ProfileState {
  final Map<String, dynamic> profile;
  ProfileUpdated(this.profile);
}
final class ProfileUpdateError extends ProfileState {
  final String message;
  ProfileUpdateError(this.message);
}
