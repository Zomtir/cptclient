import 'package:cptclient/core/navigation.dart' as navi;
import 'package:cptclient/core/router.dart' as router;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await navi.initPreferences();
  await navi.applyServer();

  runApp(CptApp());
}

class CptApp extends StatefulWidget {
  const CptApp({super.key});

  @override
  CptState createState() => CptState();
}

class CptState extends State<CptApp> {
  final GoRouter _router = router.createRouter();

  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    lazyLoad(context);
  }

  lazyLoad(BuildContext context) async {
    // Cannot modify the current state before it is 100% initialized
    // navi.applyLocale();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setLocale(Locale(prefs.getString('Language')!));
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
    return MaterialApp.router(
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
      routerConfig: _router,
    );
  }
}
