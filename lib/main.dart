import 'package:flutter/material.dart';

import 'package:form_validation/src/bloc/provider.dart';

import 'package:form_validation/src/share_prefs/user_preferences.dart';

import 'package:form_validation/src/pages/login_page.dart';
import 'package:form_validation/src/pages/home_page.dart';
import 'package:form_validation/src/pages/product_page.dart';
import 'package:form_validation/src/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new UserPreferences();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final prefs = new UserPreferences();
    final token = prefs.token;
    print('MAIN: Token en el Storage: ${token.toString().substring(0, 12)}...');

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': ( BuildContext context ) => LoginPage(),
          'register': ( BuildContext context ) => RegisterPage(),
          'home': ( BuildContext context ) => HomePage(),
          'product': ( BuildContext context ) => ProductPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.indigoAccent,
        ),
      ),
    );
  }
}