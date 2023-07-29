import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotifications {
  static int createUniqueId(int maxValue) {
    Random random = Random();
    return random.nextInt(maxValue);
  }

  static void triggerScheduledNotification() {
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
      schedule: NotificationCalendar.fromDate(
        date: DateTime.now().add(
          const Duration(minutes: 1),
        ),
        preciseAlarm: true,
        allowWhileIdle: true,
        repeats: true, // doesn't work
      ),
    );
  }

  static void repeatScheduledNotification() {
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
      schedule: NotificationCalendar(
        day: 3,
        month: 7,
        hour: 0,
        minute: 0,
        second: 0,
        repeats: true,
      ),
    );
  }

  static void cancelScheduledNotification(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  static void showActionButtonNotification(int id) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Anonymous says:',
        body: 'Hi there!',
      ),
      actionButtons: [
        NotificationActionButton(
          key: "SUBSCRIBE",
          label: "Subscribe",
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: "DISMISS",
          label: "Dismiss",
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  // CHAT NOTIFICATION
  static Future<void> createMessagingNotification({
    required String channelKey,
    required String groupKey,
    required String chatName,
    required String userName,
    required String message,
    String? largeIcon,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(AwesomeNotifications.maxID),
        channelKey: channelKey,
        groupKey: groupKey,
        summary: chatName,
        title: userName,
        body: message,
        largeIcon: largeIcon,
        roundedLargeIcon: true,
        notificationLayout: NotificationLayout.MessagingGroup,
        category: NotificationCategory.Message,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'REPLY',
          label: "Reply",
          requireInputText: true,
          autoDismissible: false,
        ),
        NotificationActionButton(
          key: 'READ',
          label: "Mark as Read",
          autoDismissible: true,
        ),
      ],
    );
  }

  // PROGRESS BAR NOTIFICATION
  static Future<void> showIndeterminateProgressNotification(int id) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Downloading fake file...',
        body: 'fileName.txt',
        category: NotificationCategory.Progress,
        payload: {
          'file': 'fileName.txt',
        },
        notificationLayout: NotificationLayout.ProgressBar,
        progress: null,
        locked: true,
      ),
    );

    // FOR DEMO
    await Future.delayed(const Duration(seconds: 5));
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Download finished',
        body: 'fileName.txt',
        category: NotificationCategory.Progress,
        locked: false,
      ),
    );
  }

  static int currentStep = 0;

  static Future<void> showProgressNotification(int id) async {
    int maxStep = 10;
    for (var i = 1; i <= maxStep + 1; i++) {
      currentStep = i;
      await Future.delayed(const Duration(seconds: 1));
      _updateCurrentProgressBar(
        id: id,
        simulatedStep: currentStep,
        maxStep: maxStep,
      );
    }
  }

  // the trick to create progress notification is
  // to create a new notification with update progress and
  // send the notification to the same id
  static void _updateCurrentProgressBar({
    required int id,
    required int simulatedStep,
    required int maxStep,
  }) {
    if (simulatedStep > maxStep) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Download finished',
          body: 'fileName.txt',
          category: NotificationCategory.Progress,
          payload: {
            'file': 'fileName.txt',
          },
          locked: false,
        ),
      );
    } else {
      int progress = min((simulatedStep / maxStep * 100).round(), 100);
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Downloading fake file in progress $progress%',
          body: 'fileName.txt',
          category: NotificationCategory.Progress,
          payload: {
            'file': 'fileName.txt',
          },
          progress: progress,
          locked: true,
        ),
      );
    }
  }

  static Future<void> createPromoNotification(int id) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Hurry',
        body: 'Time is running out',
        category: NotificationCategory.Progress,
        notificationLayout: NotificationLayout.BigPicture,
        backgroundColor: Colors.amberAccent,
        progress: 50,
        bigPicture:
            "https://images.pexels.com/photos/4968390/pexels-photo-4968390.jpeg?auto=compress&cs=tinysrgb&w=800",
      ),
    );
  }
}
