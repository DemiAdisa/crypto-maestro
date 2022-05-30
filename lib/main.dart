import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learning/models/app_config.dart';
import 'package:flutter_learning/screens/exchange_rate_screen.dart';
import 'package:flutter_learning/screens/homepage.dart';
import 'package:flutter_learning/services/http_services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  String _configContent =
      await rootBundle.loadString("assets/config/main.json");

  Map _configData = jsonDecode(_configContent);
  GetIt.instance.registerSingleton<AppConfig>(
      AppConfig(COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"]));
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>(HTTPService());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromRGBO(88, 60, 197, 1.0),
        ),

        // Start the app with the "/" named route. In this case, the app starts
        // on the FirstScreen widget.
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const HomePage(),
        });
  }
}
