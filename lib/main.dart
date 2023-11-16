import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:router_manager/controller/notification_controller.dart';
import 'package:router_manager/screen/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_export.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  return throw UnimplementedError();
});

Future<void> main() async {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'MyWifi_Router',
            channelKey: 'MyWifi_Router',
            channelName: 'Basic notifications',
            channelDescription:
                'Notification channel for connected devices, sms alerts etc.',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'MyWifi_Router', channelGroupName: 'MyWifi_Router')
      ],
      debug: true);

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    child: const MainApp(),
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    // Request the permission through native resources. Only one page redirection is done at this point.
    AwesomeNotifications()
        .checkPermissionList(
      channelKey: 'MyWifi_Router',
    )
        .then((value) {
      if (value.isEmpty) {
        AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: 'MyWifi_Router',
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultFont = GoogleFonts.josefinSans();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColor.primary,
        scaffoldBackgroundColor: AppColor.bg,
        dialogBackgroundColor: AppColor.bg,
        colorScheme: ColorScheme.dark(
          primary: AppColor.primary,
        ),
        textTheme: TextTheme(
          labelSmall: defaultFont,
          labelMedium: defaultFont,
          labelLarge: defaultFont,
          bodySmall: defaultFont,
          bodyMedium: defaultFont,
          bodyLarge: defaultFont,
          titleSmall: defaultFont,
          titleMedium: defaultFont,
          titleLarge: defaultFont,
          headlineSmall: defaultFont,
          headlineMedium: defaultFont,
          headlineLarge: defaultFont,
        ),
      ),
      home: Container(color: AppColor.bottomNavBG, child: LoginScreen()),
    );
  }
}

enum Device { MTN_MIFI_4G, MTN_BOARDBAND_4G }
