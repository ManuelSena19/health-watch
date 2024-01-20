import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_watch/constants/logic.dart';
import 'package:health_watch/providers/appointment_provider.dart';
import 'package:health_watch/providers/pharmacist_provider.dart';
import 'package:health_watch/providers/user_provider.dart';
import 'package:health_watch/screens/booking_screen.dart';
import 'package:health_watch/screens/calendar_screen.dart';
import 'package:health_watch/screens/chat_screen.dart';
import 'package:health_watch/screens/edit_profile_screen.dart';
import 'package:health_watch/screens/home_screen.dart';
import 'package:health_watch/screens/login_screen.dart';
import 'package:health_watch/screens/register_screen.dart';
import 'package:health_watch/screens/reset_password_screen.dart';
import 'package:health_watch/screens/settings_screen.dart';
import 'package:health_watch/screens/successful_booking_screen.dart';
import 'package:health_watch/screens/verify_email_screen.dart';
import 'constants/routes.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // DevicePreview(
    //   enabled: true,
    //   builder: (context) =>
      const MyApp(),
    // )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PharmacistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppointmentProvider(),
        ),
      ],
      child: MaterialApp(
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
          homescreenRoute: (context) => MainNavigationScreen(index: 0),
          profileRoute: (context) => MainNavigationScreen(index: 3),
          editProfileRoute: (context) => const EditProfileScreen(),
          appointmentRoute: (context) => MainNavigationScreen(index: 2),
          successRoute: (context) => const AppointmentBooked(),
          chatRoute: (context) =>  const ChatScreen(),
          settingsRoute: (context) => const SettingsScreen(),
          calendarRoute: (context) => const CalendarScreen(),
          bookingRoute: (context) => const BookingScreen(),
          searchRoute: (context) => MainNavigationScreen(index: 1),
        },
      ),
    );
  }
}
