import 'package:flutter/material.dart';
import "package:universal_html/html.dart";

import 'static/navigation.dart' as navi;
import 'static/db.dart' as db;

import 'ConnectionPage.dart';
import 'LandingPage.dart';
import 'MemberLandingPage.dart';
import 'EnrollPage.dart';

void main() {
  window.localStorage.putIfAbsent('ServerURL', () => 'localhost:8002');
  window.localStorage.putIfAbsent('Token', () => '');
  window.localStorage.putIfAbsent('AutoLogin', () => 'none');
  window.localStorage.putIfAbsent('DefaultLocation', () => '0');

  runApp(MaterialApp(
    title: 'CPT Client',
    theme: ThemeData(
      primarySwatch: Colors.amber,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        ),
      ),
    ),
    navigatorObservers: [navi.routeObserver],
    // onGenerateRoute: generateRoute,
    navigatorKey: navi.navigatorKey,
    initialRoute: '/',
    routes: {
      '/': (context) => MainPage(),
      '/config': (context) => ConnectionPage(),
      '/login': (context) => LandingPage(),
      '/user': (context) {
        if (navi.session == null || navi.session?.user == null) {
          return LandingPage();
        } else {
          return MemberLandingPage(session: navi.session!);
        }
      },
      '/slot': (context) => EnrollPage(session: navi.session!),
    },
  ));
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    navi.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
