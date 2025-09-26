import 'package:flutter/material.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = false;

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Today\'s Gold Rate',
      'date': 'March 1, Monday',
      'time': '3 Hours ago',
      'description': null,
    },
    {
      'title': 'New Today\'s Gold Rate',
      'date': 'March 1, Monday',
      'time': '3 Hours ago',
      'description': null,
    },
    {
      'title': 'New Today\'s Gold Rate',
      'date': 'March 1, Monday',
      'time': '3 Hours ago',
      'description': 'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(title: 'Notification'),
      body: isLoading
          ? NotificationPageShimmer()
          : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return NotificationCard(
            title: notification['title'],
            date: notification['date'],
            time: notification['time'],
            description: notification['description'],
            height: height,
            width: width,
          );
        },
      ),
    );
  }

  // Method to add a new notification
  void addNotification(Map<String, dynamic> newNotification) {
    setState(() {
      _notifications.insert(0, newNotification);
    });
  }
}