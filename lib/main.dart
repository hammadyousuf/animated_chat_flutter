import 'package:flutter/material.dart';
import 'package:animated_chat_flutter/screens/welcome_screen.dart';
import 'package:animated_chat_flutter/screens/login_screen.dart';
import 'package:animated_chat_flutter/screens/registration_screen.dart';
import 'package:animated_chat_flutter/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),

    initialRoute: WelcomeScreen.id,
    routes: {
    WelcomeScreen.id:(context) => WelcomeScreen(),
    'login_screen': (context) => LoginScreen(),
    'registration_screen': (context) => RegistrationScreen(),
      'chat_screen': (context)=>  ChatScreen(),
    },
    );
}
}
