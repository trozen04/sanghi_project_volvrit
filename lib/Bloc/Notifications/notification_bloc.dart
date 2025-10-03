import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
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
        final url = '${ApiConstants.baseUrl}${ApiConstants.notification}';
        developer.log('url: $url,');

        final uri = Uri.parse(url).replace(queryParameters: {
          'page': event.page?.toString() ?? '1',   // default page = 1
          'limit': event.limit?.toString() ?? '10' // default limit = 10
        });

        developer.log('url with params: $uri');

        final res = await http.get(
            uri,
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Accept': 'application/json',
          },
        );

        developer.log('notification body: ${res.body}');
        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(NotificationsLoaded(responseData));
        } else {
          emit(NotificationsError(responseData['message'] ?? 'Failed to fetch notifications'));
        }
      } catch (e) {
        developer.log('${e.toString()}');
        emit(NotificationsError('Something went wrong. Please try again later.'));
      }
    });

    on<MarkNotificationReadEventHandler>((event, emit) async {
      emit(NotificationMarking());
      try {

        final url = '${ApiConstants.baseUrl}${ApiConstants.notification}/${event.notificationId}/read';
        developer.log('url: $url, body');

        final res = await http.patch(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Accept': 'application/json',
          },
        );

        developer.log('mark read body: ${res.body}');
        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(NotificationMarked(event.notificationId));
        } else {
          emit(NotificationMarkError(responseData['message'] ?? 'Failed to mark notification'));
        }
      } catch (e) {
        emit(NotificationMarkError(e.toString()));
      }
    });

    on<RemoveNotificationReadEventHandler>((event, emit) async {
      emit(NotificationRemoveLoading());
      try {

        final url = '${ApiConstants.baseUrl}${ApiConstants.notification}/${event.notificationId}';
        developer.log('url: $url,');

        final res = await http.patch(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Accept': 'application/json',
          },
        );

        developer.log('NotificationRemove body: ${res.body}');
        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(NotificationRemoveSuccess(notificationId: responseData['notificationId']));
        } else {
          emit(NotificationRemoveError(responseData['message'] ?? 'Failed to mark notification'));
        }
      } catch (e) {
        emit(NotificationRemoveError(e.toString()));
      }
    });


  }
}
