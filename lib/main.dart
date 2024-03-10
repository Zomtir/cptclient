import 'package:cptclient/pages/ConnectionPage.dart';
import 'package:cptclient/pages/EnrollPage.dart';
import 'package:cptclient/pages/LoginLandingPage.dart';
import 'package:cptclient/pages/MemberLandingPage.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MaterialApp(
    title: 'CPT Client',
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en'), // English
      Locale('de'), // German
    ],
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 208, 190, 135),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Color.fromARGB(255, 208, 190, 135),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.amber, width: 2),
        ),
        isDense: true,
      ),
    ),
    navigatorObservers: [navi.routeObserver],
    // onGenerateRoute: generateRoute,
    navigatorKey: navi.navigatorKey,
    initialRoute: '/',
    routes: {
      '/': (context) => MainPage(),
      '/config': (context) => ConnectionPage(),
      '/login': (context) => LoginLandingPage(),
      '/user': (context) {
        if (navi.session == null || navi.session?.user == null) {
          return LoginLandingPage();
        } else {
          return MemberLandingPage(session: navi.session!);
        }
      },
      '/slot': (context) => EnrollPage(session: navi.session!),
    },
  ));
}

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    navi.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          value: null,
          strokeWidth: 5,
        ),
      ),
    );
  }
}
