import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'create_account.dart';
import 'forgot_password.dart';
import 'styles/styles.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: AppStyles.textTheme, 
      ),
      home: Login(),
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/create_account': (context) => CreateAccount(),
        '/forgot_password': (context) => ForgotPassword(),
      },
    );
  }
}