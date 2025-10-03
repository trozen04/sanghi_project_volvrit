import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/Notifications/notification_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = false;
  bool isPaginating = false;

  List _notifications = [];
  int _currentPage = 1;
  int _totalPages = 1;

  final ScrollController _scrollController = ScrollController();
  final String currentUserId = Prefs.getUserId() ?? '';

  @override
  void initState() {
    super.initState();
    _fetchNotifications(_currentPage);

    // Auto-load more when reaches bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50 &&
          !isPaginating &&
          _currentPage < _totalPages) {
        _loadMore();
      }
    });
  }

  void _fetchNotifications(int page) {
    context.read<NotificationBloc>().add(FetchNotificationsEventHandler(page: page));
  }

  void _loadMore() {
    setState(() {
      isPaginating = true;
    });
    _fetchNotifications(_currentPage + 1);
  }

  void _markAsReadLocally(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['_id'] == notificationId);
      if (index != -1) {
        final notif = _notifications[index];
        final usersRead = List.from(notif['usersRead'] ?? []);
        if (!usersRead.contains(currentUserId)) {
          usersRead.add(currentUserId);
          _notifications[index] = {...notif, 'usersRead': usersRead};
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: 'Notification'),
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationsLoading && _currentPage == 1) {
            setState(() {
              isLoading = true;
            });
          } else if (state is NotificationsLoaded) {
            developer.log('NotificationsLoaded: ${state.notifications}');
            setState(() {
              isLoading = false;
              isPaginating = false;
              _currentPage = state.notifications['page'] ?? 1;
              _totalPages = state.notifications['totalPages'] ?? 1;

              final newData = state.notifications['data'] ?? [];
              if (_currentPage == 1) {
                _notifications = newData;
              } else {
                _notifications.addAll(newData);
              }
            });
          } else if (state is NotificationsError) {
            setState(() {
              isLoading = false;
              isPaginating = false;
            });
          }

          if (state is NotificationMarked) {
            _markAsReadLocally(state.notificationId);
          }

          if (state is NotificationRemoveSuccess) {
            // Remove notification locally without fetching again
            setState(() {
              _notifications.removeWhere((n) => n['_id'] == state.notificationId);
            });
          }
        },

        child: isLoading
            ? NotificationPageShimmer()
            : _notifications.isEmpty
            ? Center(
          child: Text(
            'No notifications yet.\nStay tuned!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        )
        : ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];

            final String dateStr = notification['date'] ?? '';
            DateTime? dateTime;
            try {
              if (dateStr.isNotEmpty) {
                dateTime = DateTime.tryParse(dateStr);
              }
            } catch (_) {}

            final String formattedDate = dateTime != null
                ? '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}'
                : '';

            final String formattedTime = dateTime != null
                ? '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}'
                : '';

            final List<dynamic> usersRead = notification['usersRead'] ?? [];
            final bool isRead = usersRead.contains(currentUserId);

            return NotificationCard(
              title: notification['title'] ?? '',
              date: formattedDate,
              time: formattedTime,
              description: notification['message'] ?? '',
              height: height,
              width: width,
              isRead: isRead,
              onTap: isRead
                  ? null // disable tap if read
                  : () {
                context.read<NotificationBloc>().add(
                  MarkNotificationReadEventHandler(
                      notificationId: notification['_id']),
                );
              },
              onRemove: () {
                context.read<NotificationBloc>().add(
                  RemoveNotificationReadEventHandler(
                      notificationId: notification['_id']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
