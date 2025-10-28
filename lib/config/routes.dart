import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/program_listing_screen.dart';
import '../screens/program_details_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/progress.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String progress = '/progress';
  static const String programListing = '/programs';
  static const String programDetails = '/program-details';
  static const String profile = '/profile';
  static const String feedback = '/feedback';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      progress: (context) => const ProgressScreen(),
      programListing: (context) => const ProgramListingScreen(),
      programDetails: (context) => const ProgramDetailsScreen(),
      profile: (context) => const ProfileScreen(),
      feedback: (context) => const FeedbackScreen(),
    };
  }

  static String? get learning => null;
}
