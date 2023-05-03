import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_watch/constants/logic.dart';
import 'package:health_watch/screens/home_screen.dart';
import 'package:health_watch/screens/login_screen.dart';
import 'package:health_watch/screens/register_screen.dart';
import 'package:health_watch/screens/reset_password_screen.dart';
import 'package:health_watch/screens/verify_email_screen.dart';
import 'constants/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? loginRoute
          : homescreenRoute,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      routes: {
        loginRoute: (context) => const LoginScreen(),
        logicRoute: (context) => const Logic(),
        registerRoute: (context) => const RegisterScreen(),
        verifyEmailRoute: (context) => const VerifyEmailScreen(),
        resetPasswordRoute: (context) => const ResetPasswordScreen(),
        homescreenRoute: (context) => const HomeScreen()
      },
    );
  }
}
