import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:eraser/eraser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notification_course/main.dart';
import 'package:notification_course/second_screen.dart';
import 'package:notification_course/services/local_notifications.dart';
import 'package:notification_course/third_screen.dart';

class NotificationController extends ChangeNotifier {
  // SINGLETON PATTERN
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }
  NotificationController._internal();

  // INITIALIZATION METHOD
  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.Max,
          // defaultPrivacy: NotificationPrivacy.Private,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          enableVibration: true,
          defaultColor: Colors.redAccent,
          channelShowBadge: true,
          enableLights: true,
          // icon: 'resource://drawable/res_naruto',
          // playSound: true,
          // soundSource: 'resource://raw/naruto_jutsu',
        ),
        NotificationChannel(
          channelGroupKey: "chat_tests",
          channelKey: "chats",
          channelName: "Group chats",
          channelDescription: "This is a simple example of a channel app",
          channelShowBadge: true,
          importance: NotificationImportance.Max,
        ),
      ],
      debug: debug,
    );
  }

  // LISTENER METHODS
  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
    );
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    bool isSilentAction =
        receivedAction.actionType == ActionType.SilentAction ||
            receivedAction.actionType == ActionType.SilentBackgroundAction;
    log("${isSilentAction ? 'silent action' : 'Action'} notification received");
    log("receivedAction -> $receivedAction");

    if (receivedAction.buttonKeyPressed == "ACCEPT") {
      log("Hirak da rocks");

      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => const ThirdScreen()),
      );
    }

    // if (receivedAction.channelKey == "chats") {
    //   receiveChatNotificationAction(receivedAction);
    // }
  }

  static Future<void> receiveChatNotificationAction(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == "REPLY") {
      await LocalNotifications.createMessagingNotification(
        channelKey: "chats",
        groupKey: receivedAction.groupKey!,
        chatName: receivedAction.summary!,
        userName: "You",
        message: receivedAction.buttonKeyInput,
        largeIcon:
            "https://images.pexels.com/photos/15577641/pexels-photo-15577641/free-photo-of-sky-sunset-sunny-fashion.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load",
      );
    } else {
      // Navigate the user to the chat page
    }
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log("Notification Dismissed");
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    log("Notification Created -> $receivedNotification");
    if (receivedNotification.payload!["secret"] ==
        "Awesome Notifications Rocks!") {
      log("Clearing Notifications");
      // Clear All Notifications
      // await ClearAllNotifications.clear();
      Eraser.clearAllAppNotifications();
    } else {
      log("Can't Clear Notifications");
    }
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    log("Notification Displayed -> $receivedNotification");
  }

  // REMOTE NOTIFICATION INITIALIZATION
  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
      onFcmTokenHandle: NotificationController.onFcmTokenHandle,
      onFcmSilentDataHandle: NotificationController.onFcmSilentDataHandle,
      onNativeTokenHandle: NotificationController.onNativeTokenHandle,
      licenseKeys: [],
      debug: debug,
    );
  }

  // REMOTE NOTIFICATION EVENT LISTENERS

  //* Use this method to detect when a new fcm token is received
  static Future<void> onFcmTokenHandle(String token) async {
    log("FCM token received -> $token");
  }

  //* Use this method to execute on background when a silent data arrives
  //* even while terminated
  static Future<void> onFcmSilentDataHandle(FcmSilentData silentData) async {
    log("Silent data received -> ${silentData.data}");
  }

  //* Use this method to detect when a new native token is received
  static Future<void> onNativeTokenHandle(String token) async {
    log("Native token received -> $token");
  }

  // REQUEST FCM Token
  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (e) {
        log("$e");
      }
    } else {
      log("Firebase not available");
    }
    return '';
  }
}
