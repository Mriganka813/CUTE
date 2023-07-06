import 'package:cute/appBehaviour/my_behaviour.dart';
import 'package:cute/constant/constant.dart';
import 'package:cute/pages/splashScreen.dart';
import 'package:cute/services/global.dart';
import 'package:cute/services/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  locator.registerLazySingleton(() => GlobalServices());
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CUTE',
      theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: primaryColor,
          fontFamily: 'Mukta',
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: primaryColor,
          ),
          tabBarTheme: TabBarTheme(
            labelColor: greyColor,
          ),
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Colors.transparent,

              // Status bar brightness (optional)
              statusBarIconBrightness:
                  Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
          )),
      debugShowCheckedModeBanner: false,
      // builder: (context, child) {
      //   return ScrollConfiguration(
      //     behavior: MyBehavior(),
      //     child: Text("CHECK"),
      //   );
      // },
      home: SplashScreen(),
    );
  }
}
