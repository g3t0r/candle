import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyNotification extends AndroidNotificationDetails {
  MyNotification(
      String channelId, String channelName, String channelDescription)
      : super(
          channelId,
          channelName,
          channelDescription,
          importance: Importance.low,
          priority: Priority.min,
          ongoing: true,
          color: Color(0x000000),
          largeIcon: DrawableResourceAndroidBitmap('app_icon'),
          // styleInformation: new MediaStyleInformation(),
        );
}
