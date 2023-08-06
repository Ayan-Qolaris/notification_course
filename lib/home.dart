// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'package:notification_course/second_screen.dart';
import 'package:notification_course/services/local_notifications.dart';
import 'package:notification_course/services/notification_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((value) {
      if (!value) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    NotificationController.initializeNotificationsEventListeners();
    NotificationController.requestFirebaseToken();
    navigate();
  }

  Future<void> navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SecondScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: triggerNotification,
              child: const Text("Trigger Notification"),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: triggerBigPictureNotification,
              child: const Text("Big Picture"),
            ),
            const SizedBox(height: 5),
            const ElevatedButton(
              onPressed: LocalNotifications.triggerScheduledNotification,
              child: Text("Schedule Once"),
            ),
            const SizedBox(height: 5),
            const ElevatedButton(
              onPressed: LocalNotifications.repeatScheduledNotification,
              child: Text("Schedule Repeat"),
            ),
            const SizedBox(height: 5),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 20.0),
            ),
            ElevatedButton(
              onPressed: () =>
                  LocalNotifications.cancelScheduledNotification(10),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
              ),
              child: const Text("Schedule Cancel"),
            ),
            const SizedBox(height: 5),

            ElevatedButton(
              onPressed: () =>
                  LocalNotifications.showActionButtonNotification(10),
              child: const Text("Action button"),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () => LocalNotifications.createMessagingNotification(
                channelKey: "chats",
                groupKey: "Emma_group",
                chatName: "Emma Group",
                userName: "Emma",
                message: "Emma has sent a message",
                largeIcon: "asset://assets/profile_photo.png",
              ),
              child: const Text("Group chat"),
            ),
            // const SizedBox(height: 5),
            // const CircleAvatar(
            //   backgroundImage: AssetImage(
            //     "assets/profile_photo.png",
            //   ),
            //   radius: 25,
            // ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () =>
                  // LocalNotifications.showIndeterminateProgressNotification(10),
                  LocalNotifications.createPromoNotification(2),
              child: const Text("Progress notification"),
            ),
          ],
        ),
      ),
    );
  }

  void triggerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: "basic_channel",
        title: "Simple Notification",
        body: "Simple button",
      ),
    );
  }

  void triggerBigPictureNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: "basic_channel",
        title: "Big Picture",
        body: "Big picture notification",
        bigPicture:
            "https://images.pexels.com/photos/17518151/pexels-photo-17518151/free-photo-of-milan-galleria-vittorio-emanuele-ii.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
