import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'MyNotification.dart';

Future<void> main() {
  runApp(MyApp());
}

enum NotificationState { VISIBLE, HIDDEN, UNDEFINED }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candle',
      theme: ThemeData(
          // primarySwatch: MaterialColor(),
          // backgroundColor: Colors.blueGrey,
          // visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.deepOrange,
          brightness: Brightness.dark),
      home: MyHomePage(title: 'Candle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState
    extends State<MyHomePage> /* with WidgetsBindingObserver */ {
  int _counter = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationState notificationState = NotificationState.UNDEFINED;
  MyNotification notification;
  final myController = TextEditingController(text: '');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  _MyHomePageState() {
    initNotifications();
  }

  void customSetState() {
    setState(() {});
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   setState(() {
  //     switch (state) {
  //       case AppLifecycleState.resumed:
  //         print("app in resumed");
  //         // if (notificationState != NotificationState.UNDEFINED) {
  //         //   // this.showNotification();
  //         // }
  //         // this.notificationState = NotificationState.VISIBLE;
  //         break;
  //       case AppLifecycleState.inactive:
  //         print("app in inactive");
  //         break;
  //       case AppLifecycleState.paused:
  //         print("app in paused");
  //         break;
  //       case AppLifecycleState.detached:
  //         print("app in detached");
  //         break;
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  Future<void> initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: true,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    print("notifications innit done");
  }

  void showNotification() {
    // this.flutterLocalNotificationsPlugin.cancelAll();
    var androidDetails =
        new MyNotification("channelId", "channelName", "channelDescription");
    // AndroidNotificationDetails('channelId', 'channelName', 'channelDescription', importance: Importance.none, priority: Priority.min, ongoing: true);
    AndroidNotificationChannel anc = AndroidNotificationChannel(
        'xDDD', 'name', 'description',
        importance: Importance.none);
    var iosDetails = IOSNotificationDetails();
    var platformDetails =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);
    this.notification = androidDetails;
    flutterLocalNotificationsPlugin.show(2, "You lighted candle with intention",
        myController.value.text , platformDetails);
    print("showNotification");
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addObserver(this);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Set your intention:',
            ),
            TextField(
              controller: myController,
            )
          ],
        ),
      ),
      floatingActionButton: new Visibility(
        child: FloatingActionButton(
            onPressed: () => {
                  if (this.notification == null)
                    {showNotification()}
                  else
                    {
                      this.flutterLocalNotificationsPlugin.cancelAll(),
                      this.notification = null
                    },
                  customSetState()
                },
            tooltip: 'Light up candle',
            child: ImageIcon(AssetImage(this.notification == null
                ? "assets/fire_icon.png"
                : "assets/fire-off.png")),
            backgroundColor: this.notification == null
                ? Colors.redAccent
                : Colors.blueAccent),
      ),
    );
  }

  Future onSelectNotification(String payload) {
    print("onSelectNotification");
    this.delayedRunner();
  }

  void delayedRunner() async {
    print("before waiting");
    await Future.delayed(const Duration(milliseconds: 400), () {});
    print("before after");
    showNotification();
  }
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) {}

class CustomAndroidBitmap extends AndroidBitmap {
  @override
  // TODO: implement bitmap
  String get bitmap => "app_icon";

  @override
  // TODO: implement hashCode
  int get hashCode => bitmap.hashCode;

// TODO: implement runtimeType
}
