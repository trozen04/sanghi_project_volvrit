part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

/// Fetch all notifications (optional: unread only)
final class FetchNotificationsEventHandler extends NotificationEvent {
  final bool? unreadOnly;
  FetchNotificationsEventHandler({this.unreadOnly});
}

/// Mark a notification as read
final class MarkNotificationReadEventHandler extends NotificationEvent {
  final String notificationId;
  MarkNotificationReadEventHandler({required this.notificationId});
}
