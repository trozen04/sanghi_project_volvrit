part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

/// Fetch all notifications (optional: unread only)
final class FetchNotificationsEventHandler extends NotificationEvent {
  int? page;
  int? limit;
  FetchNotificationsEventHandler({this.page, this.limit});
}

/// Mark a notification as read
final class MarkNotificationReadEventHandler extends NotificationEvent {
  final String notificationId;
  MarkNotificationReadEventHandler({required this.notificationId});
}

/// Remove a notification
final class RemoveNotificationReadEventHandler extends NotificationEvent {
  final String notificationId;
  RemoveNotificationReadEventHandler({required this.notificationId});
}
