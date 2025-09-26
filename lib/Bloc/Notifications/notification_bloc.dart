import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<FetchNotificationsEventHandler>(_onFetchNotifications);
    on<MarkNotificationReadEventHandler>(_onMarkNotificationRead);
  }

  /// Remove null/empty values from body map
  Map<String, dynamic> _filterNulls(Map<String, dynamic> data) {
    final filtered = <String, dynamic>{};
    data.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        filtered[key] = value;
      }
    });
    return filtered;
  }

  /// Fetch all notifications
  Future<void> _onFetchNotifications(
      FetchNotificationsEventHandler event, Emitter<NotificationState> emit) async {
    emit(NotificationsLoading());
    try {
      final body = {
        'unread_only': event.unreadOnly,
        // 'user_id': '123', // example optional param
      };
      final params = _filterNulls(body);

      final res = await http.get(
        Uri.parse(ApiConstants.baseUrl).replace(queryParameters: params),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        emit(NotificationsLoaded(data['notifications'] ?? []));
      } else {
        emit(NotificationsError(data['message'] ?? 'Failed to fetch notifications'));
      }
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  /// Mark a notification as read
  Future<void> _onMarkNotificationRead(
      MarkNotificationReadEventHandler event, Emitter<NotificationState> emit) async {
    emit(NotificationMarking());
    try {
      final body = {
        'notification_id': event.notificationId,
        // 'user_id': '123', // example optional param
      };
      final params = _filterNulls(body);

      final res = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: params,
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        emit(NotificationMarked(event.notificationId));
      } else {
        emit(NotificationMarkError(data['message'] ?? 'Failed to mark notification'));
      }
    } catch (e) {
      emit(NotificationMarkError(e.toString()));
    }
  }
}
