import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_watch/constants/logic.dart';
import 'package:health_watch/screens/apppointment_screen.dart';
import 'package:health_watch/screens/calendar_screen.dart';
import 'package:health_watch/screens/chat_screen.dart';
import 'package:health_watch/screens/edit_profile_screen.dart';
import 'package:health_watch/screens/home_screen.dart';
import 'package:health_watch/screens/login_screen.dart';
import 'package:health_watch/screens/pharmacist_details_screen.dart';
import 'package:health_watch/screens/profile_screen.dart';
import 'package:health_watch/screens/register_screen.dart';
import 'package:health_watch/screens/reset_password_screen.dart';
import 'package:health_watch/screens/successful_booking_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? loginRoute
          : homescreenRoute,
      title: 'Health Watch',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      routes: {
        loginRoute: (context) => const LoginScreen(),
        logicRoute: (context) => const Logic(),
        registerRoute: (context) => const RegisterScreen(),
        verifyEmailRoute: (context) => const VerifyEmailScreen(),
        resetPasswordRoute: (context) => const ResetPasswordScreen(),
        homescreenRoute: (context) => const MainNavigationScreen(),
        profileRoute: (context) => const ProfileScreen(),
        editProfileRoute: (context) => const EditProfileScreen(),
        appointmentRoute: (context) => const AppointmentScreen(),
        calendarRoute: (context) => const CalendarScreen(),
        detailsRoute: (context) => const PharmacistDetailsScreen(),
        successRoute: (context) => const AppointmentBooked(),
        chatRoute: (context) => const ChatScreen(),
      },
    );
  }
}
