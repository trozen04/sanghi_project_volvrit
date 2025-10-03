part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

/// ----- FETCH NOTIFICATIONS -----
final class NotificationsLoading extends NotificationState {}
final class NotificationsLoaded extends NotificationState {
  var notifications;
  NotificationsLoaded(this.notifications);
}
final class NotificationsError extends NotificationState {
  final String message;
  NotificationsError(this.message);
}

/// ----- MARK READ -----
final class NotificationMarking extends NotificationState {}
final class NotificationMarked extends NotificationState {
  final String notificationId;
  NotificationMarked(this.notificationId);
}
final class NotificationMarkError extends NotificationState {
  final String message;
  NotificationMarkError(this.message);
}
/// ----- Remove -----
final class NotificationRemoveLoading extends NotificationState {}
final class NotificationRemoveSuccess extends NotificationState {
  final String notificationId;
  NotificationRemoveSuccess({required this.notificationId});
}
final class NotificationRemoveError extends NotificationState {
  final String message;
  NotificationRemoveError(this.message);
}
