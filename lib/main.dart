import 'package:flutter/material.dart';
import 'package:flutternode_todo/dashboard.dart';
import 'package:flutternode_todo/login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  // Print the token for debugging
  print('Token: $token');

  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({
    Key? key,
    this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure token is not null or invalid before using JwtDecoder
    if (token != null) {
      try {
        if (!JwtDecoder.isExpired(token!)) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.black,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Dashboard(token: token),
          );
        }
      } catch (e) {
        print('Error decoding token: $e');
      }
    }

    // If the token is null or expired, show the Login screen
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
    );
  }
}
