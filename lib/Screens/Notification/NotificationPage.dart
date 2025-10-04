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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List _notifications = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool isLoading = false;
  bool isPaginating = false;

  final ScrollController _scrollController = ScrollController();
  final String currentUserId = Prefs.getUserId() ?? '';

  @override
  void initState() {
    super.initState();
    _fetchNotifications(_currentPage);

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
    final index = _notifications.indexWhere((n) => n['_id'] == notificationId);
    if (index != -1) {
      final notif = _notifications[index];
      final usersRead = List.from(notif['usersRead'] ?? []);
      if (!usersRead.contains(currentUserId)) {
        usersRead.add(currentUserId);
        _notifications[index] = {...notif, 'usersRead': usersRead};

        // Tell AnimatedList to rebuild this item
        _listKey.currentState?.setState(() {}); // Force rebuild
      }
    }
  }


  void _removeNotificationWithAnimation(int index) {
    final removedItem = _notifications[index];
    _notifications.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => SizeTransition(
        sizeFactor: animation,
        axisAlignment: 0.0,
        child: NotificationCard(
          title: removedItem['title'] ?? '',
          date: removedItem['date'] ?? '',
          time: removedItem['time'] ?? '',
          description: removedItem['message'] ?? '',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          isRead: true,
          onTap: null,
          onRemove: null,
        ),
      ),
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: 'Notification'),
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationsLoaded) {
            final newData = state.notifications['notifications'] ?? [];
            final int page = state.notifications['currentPage'] ?? _currentPage;
            final int totalPages = state.notifications['totalPages'] ?? _totalPages;

            setState(() {
              isLoading = false;
              isPaginating = false;
              _currentPage = page;
              _totalPages = totalPages;

              if (page == 1) {
                // First page: reset list
                _notifications = [];
                for (int i = 0; i < newData.length; i++) {
                  _notifications.add(newData[i]);
                  _listKey.currentState?.insertItem(i);
                }
              } else {
                // Subsequent pages: append with animation
                final startIndex = _notifications.length;
                for (int i = 0; i < newData.length; i++) {
                  _notifications.add(newData[i]);
                  _listKey.currentState?.insertItem(startIndex + i);
                }
              }
            });
          }


          if (state is NotificationMarked) {
            _markAsReadLocally(state.notificationId);
          }

          if (state is NotificationRemoveSuccess) {
            final index = _notifications.indexWhere((n) => n['_id'] == state.notificationId);
            if (index != -1) {
              _removeNotificationWithAnimation(index);
            }
          }
        },
        child: isLoading
            ? NotificationPageShimmer()
            : _notifications.isEmpty
            ? Center(
          child: Text(
            'No notifications yet.\nStay tuned!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        )
            : AnimatedList(
          key: _listKey,
          controller: _scrollController,
          initialItemCount: _notifications.length,
          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
          itemBuilder: (context, index, animation) {
            final notification = _notifications[index];
            final String dateStr = notification['date'] ?? '';
            DateTime? dateTime = dateStr.isNotEmpty ? DateTime.tryParse(dateStr) : null;
            final formattedDate = dateTime != null
                ? '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}'
                : '';
            final formattedTime = dateTime != null
                ? '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}'
                : '';
            final usersRead = notification['usersRead'] ?? [];
            final isRead = usersRead.contains(currentUserId);

            return SizeTransition(
              sizeFactor: animation,
              child: NotificationCard(
                title: notification['title'] ?? '',
                date: formattedDate,
                time: formattedTime,
                description: notification['message'] ?? '',
                height: height,
                width: width,
                isRead: isRead,
                onTap: isRead
                    ? null
                    : () {
                  context.read<NotificationBloc>().add(
                      MarkNotificationReadEventHandler(notificationId: notification['_id']));
                },
                onRemove: () {
                  context.read<NotificationBloc>().add(
                      RemoveNotificationReadEventHandler(notificationId: notification['_id']));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

