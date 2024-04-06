import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tillkhatam/core/app_color.dart';
import 'package:tillkhatam/core/app_helper.dart';
import 'package:tillkhatam/core/app_route.dart';
import 'package:tillkhatam/core/app_style.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PageNotificationDialog extends StatefulWidget {
  const PageNotificationDialog({super.key});

  @override
  State<PageNotificationDialog> createState() => _PageNotificationDialogState();
}

class _PageNotificationDialogState extends State<PageNotificationDialog> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');
  List<ActiveNotification> activeNotifications = [];

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.pushNamed(context, AppRoute.HOME);
  }

  setNotification() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    //test set noti
    var res = await flutterLocalNotificationsPlugin.getActiveNotifications();
    setState(() {
      activeNotifications = res;
    });
  }

  @override
  void initState() {
    tz.initializeTimeZones();
    setNotification();
    super.initState();
  }

  onSelectNotify(context) async {
    Future<TimeOfDay?> selectedTime = showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    var time = await selectedTime;
    var now = DateTime.now();
    tz.TZDateTime date = tz.TZDateTime.from(
      DateTime(now.year, now.month, now.day, time!.hour, time.minute),
      tz.local,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Till Khatam',
        'Read Quran Today!',
        date,
        const NotificationDetails(
            android: AndroidNotificationDetails('0', 'till_khatam',
                channelDescription: 'reading quran')),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    AppHelper.snackbar(
        context, "Created notification at ${date.toIso8601String()}");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Container(
        height: 300,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        margin: const EdgeInsets.all(5.0),
        //padding: const EdgeInsets.only(top: 23),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16))),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Text(
                      'Notification Setup',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Select when to notify',
                    style: AppStyle.text(context, color: AppColor.lightBlack),
                  ),
                  FilledButton(
                      onPressed: () => onSelectNotify(context),
                      child: const Text("Remind me at <WIP> ongoing"))
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              //width: 280,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16))),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        'Done',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
