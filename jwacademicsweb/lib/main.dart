import 'package:easy_nav/easy_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwacademicsweb/ui/landing_page/landing_page.dart';
import 'package:jwacademicsweb/ui/login/login_screen.dart';
import 'package:jwacademicsweb/ui/register/register_screen.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: dotenv.env["apiKey"] ?? "",
    appId: dotenv.env["appId"] ?? "",
    messagingSenderId: dotenv.env["messagingSenderId"] ?? "",
    projectId: dotenv.env["projectId"] ?? "",
    databaseURL: dotenv.env["databaseURL"] ?? "",
    authDomain: dotenv.env["authDomain"] ?? "",
    storageBucket: dotenv.env["storageBucket"] ?? "",
  ));

  setPathUrlStrategy();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JW Academics',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LandingPageScreen(),
        LoginScreen.routeName : (context) => LoginScreen(),
        RegisterScreen.routeName : (context) => RegisterScreen(),
      },
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
      ),
      navigatorKey: EasyNav.navigatorKey,
      initialRoute: '/',
    );
  }
}