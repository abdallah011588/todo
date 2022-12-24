import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tasks_todo/layout/home_page.dart';
import 'package:tasks_todo/localization/localization_methods.dart';
import 'package:tasks_todo/localization/set_localization.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {



  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale? _local;
  void setLocale(Locale locale) {
    setState(() {
      _local = locale;
    });
  }
  @override
  void didChangeDependencies() {

    getLocale().then((locale) {
      setState(() {
        this._local = locale;
      });
    });
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context)
  {

    if (_local == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else
      {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tasks ToDo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.blue,
              ),
              titleSpacing: 20.0,
            ),

          ),
          home:  myHomePage(),


          locale: _local,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', 'EG')
          ],

          localizationsDelegates: [
            SetLocalization.localizationsDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocal, supportedLocales)
          {
            for (var local in supportedLocales)
            {
              if (local.languageCode == deviceLocal!.languageCode &&
                  local.countryCode == deviceLocal.countryCode)
              {
                return deviceLocal;
              }
            }
            return supportedLocales.first;
          },
        );

      }
  }
}


