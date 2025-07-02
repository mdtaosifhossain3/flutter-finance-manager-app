import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final String category;
  final IconData icon;
  final Color iconColor;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.icon,
    required this.iconColor,
  });
}

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'Reminder!',
      description: 'Set up your automatic savings to meet your savings goal...',
      time: '17:00 - April 24',
      category: 'Today',
      icon: Icons.savings,
      iconColor: Color(0xFF00C896),
    ),
    NotificationItem(
      id: '2',
      title: 'New Update',
      description: 'Set up your automatic savings to meet your savings goal...',
      time: '17:00 - April 24',
      category: 'Today',
      icon: Icons.system_update,
      iconColor: Color(0xFF00C896),
    ),
    NotificationItem(
      id: '3',
      title: 'Transactions',
      description: 'A new transaction has been registered\nGroceries | Pantry | -\$100.00',
      time: '17:00 - April 24',
      category: 'Yesterday',
      icon: Icons.monetization_on,
      iconColor: Color(0xFF00C896),
    ),
    NotificationItem(
      id: '4',
      title: 'Reminder!',
      description: 'Set up your automatic savings to meet your savings goal...',
      time: '17:00 - April 24',
      category: 'Yesterday',
      icon: Icons.savings,
      iconColor: Color(0xFF00C896),
    ),
    NotificationItem(
      id: '5',
      title: 'Expense Record',
      description: 'We recorded that you are more attentive to your finances.',
      time: '17:00 - April 24',
      category: 'This Weekend',
      icon: Icons.monetization_on,
      iconColor: Color(0xFF00C896),
    ),
    NotificationItem(
      id: '6',
      title: 'Transactions',
      description: 'A new transaction has been registered\nFood | Dinner | -\$70.40',
      time: '17:00 - April 24',
      category: 'This Weekend',
      icon: Icons.monetization_on,
      iconColor: Color(0xFF00C896),
    ),
  ];

  void _removeNotification(String id) {
    setState(() {
      notifications.removeWhere((notification) => notification.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification deleted'),
        backgroundColor: Color(0xFF00C896),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear All Notifications'),
          content: Text('Are you sure you want to clear all notifications?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  notifications.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All notifications cleared'),
                    backgroundColor: Color(0xFF00C896),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Clear All',
                style: TextStyle(color: Color(0xFF00C896)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group notifications by category
    Map<String, List<NotificationItem>> groupedNotifications = {};
    for (var notification in notifications) {
      if (!groupedNotifications.containsKey(notification.category)) {
        groupedNotifications[notification.category] = [];
      }
      groupedNotifications[notification.category]!.add(notification);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF00C896),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  InkWell(onTap: (){
                    Get.back();
                  }, child: 
                  
                  
                  Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'Notification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: notifications.isNotEmpty ? _clearAllNotifications : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: notifications.isNotEmpty 
                          ? Colors.white.withOpacity(0.2) 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: notifications.isNotEmpty 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: notifications.isEmpty
                    ? _buildEmptyState()
                    : ListView(
                        padding: EdgeInsets.all(20),
                        children: _buildNotificationList(groupedNotifications),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationList(Map<String, List<NotificationItem>> groupedNotifications) {
    List<Widget> widgets = [];
    
    groupedNotifications.forEach((category, notifications) {
      // Add category header
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 12, top: widgets.isEmpty ? 0 : 20),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      );
      
      // Add notifications for this category
      for (var notification in notifications) {
        widgets.add(_buildNotificationCard(notification));
        widgets.add(SizedBox(height: 12));
      }
    });
    
    // Remove the last SizedBox
    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }
    
    return widgets;
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (direction) {
        _removeNotification(notification.id);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                notification.icon,
                color: notification.iconColor,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    notification.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00C896),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}