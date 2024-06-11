import 'package:attendence_manag_sys/components/courses_container.dart';
import 'package:attendence_manag_sys/controllers/auth_services.dart';
import 'package:attendence_manag_sys/view/User%20Authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({
    super.key,
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  AuthServices authServices = AuthServices();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.sizeOf(context).width * 1;
    final double height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Wellcome'),
        actions: [
          InkWell(
              onTap: () async {
                await authServices.logout();
                Get.to(
                    () => const LoginScreen(
                          role: true,
                        ),
                    duration: const Duration(seconds: 2),
                    transition: Transition.fade);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to Student Dashboard",
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              const RegisterCoursesContainer(),
              SizedBox(
                height: height * 0.03,
              ),
              Text(
                "Class room",
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
