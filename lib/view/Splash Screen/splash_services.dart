import 'dart:async';

import 'package:attendence_manag_sys/view/Student%20Screens/student_dashboard.dart';
import 'package:attendence_manag_sys/view/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void checkUserStatus(BuildContext context) async {
    if (firebaseAuth.currentUser != null) {
      Timer(const Duration(seconds: 3), () {
        Get.to(() => const StudentDashboard());
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.to(
          () => const LandingPage(),
          duration: const Duration(seconds: 2),
          transition: Transition.fade,
        );
      });
    }
  }
}
