import 'package:cptclient/pages/ConnectionPage.dart';
import 'package:cptclient/pages/EnrollPage.dart';
import 'package:cptclient/pages/LoginLandingPage.dart';
import 'package:cptclient/pages/MemberLandingPage.dart';
import 'package:cptclient/static/navigation.dart' as navi;
import 'package:cptclient/static/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(CptApp());
}

class CptApp extends StatefulWidget {
  const CptApp({super.key});

  @override
  CptState createState() => CptState();
}

class CptState extends State<CptApp> {
  GlobalKey<CptState> cptKey = GlobalKey();

  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    lazyLoad();
  }

  lazyLoad() async {
    await navi.preferences(cptKey);

    // Cannot modify the current state before it is 100% initialized
    // navi.applyLocale();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setLocale(Locale(prefs.getString('Language')!));

    navi.applyServer();
    navi.connectServer();
  }

  Locale getLocale() {
    return Localizations.localeOf(context);
  }

  void setLocale(Locale? locale) {
    if (locale == null) return;
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPT Client',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
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
        dataTableTheme: DataTableThemeData(
          headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
          columnSpacing: 10,
        )
      ),
      navigatorObservers: [navi.routeObserver],
      // onGenerateRoute: generateRoute,
      navigatorKey: navi.navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/connect': (context) => ConnectionPage(),
        '/login': (context) => LoginLandingPage(),
        '/user': (context) {
          if (navi.uSession == null || navi.uSession?.user == null) {
            return LoginLandingPage();
          } else {
            return MemberLandingPage(session: navi.uSession!);
          }
        },
        '/event': (context) => EnrollPage(session: navi.eSession!),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});

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
