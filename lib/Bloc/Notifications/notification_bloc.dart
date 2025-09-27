import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<FetchNotificationsEventHandler>((event, emit) async {
      emit(NotificationsLoading());
      try {
        // Optional query parameters
        final body = {
          'unread_only': event.unreadOnly,
          // 'user_id': Prefs.getUserId(), // if needed
        }..removeWhere((key, value) => value == null || value.toString().trim().isEmpty);

        final url = '${ApiConstants.baseUrl}';
        developer.log('url: $url, params: $body');

        final uri = Uri.parse(url).replace(queryParameters: body);
        final res = await http.get(uri);

        developer.log('body: ${res.body}');
        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200) {
          emit(NotificationsLoaded(responseData['notifications'] ?? []));
        } else {
          emit(NotificationsError(responseData['message'] ?? 'Failed to fetch notifications'));
        }
      } catch (e) {
        emit(NotificationsError(e.toString()));
      }
    });

    on<MarkNotificationReadEventHandler>((event, emit) async {
      emit(NotificationMarking());
      try {
        final body = {
          'notification_id': event.notificationId,
          // 'user_id': Prefs.getUserId(), // optional
        }..removeWhere((key, value) => value == null || value.toString().trim().isEmpty);

        final url = '${ApiConstants.baseUrl}';
        developer.log('url: $url, body: $body');

        final res = await http.post(Uri.parse(url), body: body);

        developer.log('body: ${res.body}');
        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200) {
          emit(NotificationMarked(event.notificationId));
        } else {
          emit(NotificationMarkError(responseData['message'] ?? 'Failed to mark notification'));
        }
      } catch (e) {
        emit(NotificationMarkError(e.toString()));
      }
    });
  }
}
