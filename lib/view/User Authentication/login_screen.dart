import 'dart:async';
import 'package:attendence_manag_sys/components/button.dart';
import 'package:attendence_manag_sys/components/password_textfield.dart';
import 'package:attendence_manag_sys/components/text_field.dart';
import 'package:attendence_manag_sys/controllers/auth_services.dart';
import 'package:attendence_manag_sys/view/Teacher%20Screens/teacher_dashboard.dart';
import 'package:attendence_manag_sys/view/User%20Authentication/forget_password.dart';
import 'package:attendence_manag_sys/view/User%20Authentication/signup_screen.dart';
import 'package:attendence_manag_sys/view/Student%20Screens/student_dashboard.dart';
import 'package:attendence_manag_sys/view/landing_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  final bool? role;
  const LoginScreen({
    super.key,
    this.role,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    AuthServices authServices = AuthServices();

    final TextEditingController teacherIDController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    double width = MediaQuery.sizeOf(context).width * 1;
    double height = MediaQuery.sizeOf(context).height * 1;

    // Function to validate email format
    bool isEmailValid(String email) {
      final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    // role based login
    void route() async {
      User? user = FirebaseAuth.instance.currentUser;

      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('students')
            .doc(user!.uid)
            .get();

        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role') == "Student") {
            Get.to(() => const StudentDashboard(),
                transition: Transition.fade,
                duration: const Duration(seconds: 2));
          } else {
            Get.to(() => const TeacherDashboard(),
                transition: Transition.fade,
                duration: const Duration(seconds: 2));
          }
        } else {
          // If the document does not exist, assume the user is a teacher
          Get.to(() => const TeacherDashboard(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        }
      } catch (e) {
        Get.snackbar(
            'Error', 'Unable to determine user role. / ${e.toString()}');
      }
    }
    // done

    Future userLogin() async {
      String email = emailController.text.trim().toLowerCase();

      if (teacherIDController.text.toString().isEmpty) {
        Get.snackbar('Error', 'Please enter your teacher ID');
      } else if (email.isEmpty) {
        Get.snackbar("Error", "Please enter your email");
        return;
      } else if (!isEmailValid(email)) {
        Get.snackbar("Error", "Please enter a valid email");
        return;
      } else if (passwordController.text.isEmpty) {
        Get.snackbar("Error", "Please enter your password");
        return;
      }

      setState(() {
        isloading = true;
      });
      try {
        String result = await authServices.userlogin(
            email: emailController.text.toString(),
            password: passwordController.text.toString());

        if (result == 'Success') {
          route();
          emailController.clear();
          passwordController.clear();
          Get.snackbar('Success', 'Successfully Login');

          setState(() {
            isloading = false;
          });
        }
      } catch (e) {
        Get.snackbar('Error', '$e');
        setState(() {
          isloading = false;
        });
      }
      setState(() {
        isloading = false;
      });
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image(
                  image: const AssetImage('images/login.png'),
                  width: width * .5,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                if (widget.role == false)
                  CustomtextField(
                    title: 'Teacher ID',
                    controller: teacherIDController,
                    prefixicon: const Icon(Icons.person),
                  ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomtextField(
                  title: 'Email',
                  controller: emailController,
                  prefixicon: const Icon(Icons.email),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                PasstextField(
                  title: 'Password',
                  controller: passwordController,
                  prefixicon: const Icon(Icons.lock),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                if (widget.role == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.to(() => const ForgetPassowrd(),
                                transition: Transition.fade,
                                duration: const Duration(seconds: 2));
                          },
                          child: Text(
                            "Forget Password ?",
                            style: GoogleFonts.alatsi(
                                fontSize: 13,
                                color: const Color.fromARGB(213, 104, 58, 183),
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomButton(
                    isloading: isloading,
                    title: 'Login',
                    ontap: () async {
                      await userLogin();
                    }),
                SizedBox(
                  height: height * 0.02,
                ),
                if (widget.role == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't have an accout ? ",
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const SignupScreen(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 2));
                        },
                        child: Text("Signup",
                            style: GoogleFonts.poppins(
                                color: Colors.deepPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                SizedBox(
                  height: height * 0.02,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const LandingPage(),
                        transition: Transition.fade,
                        duration: const Duration(seconds: 2));
                  },
                  child: Text("Back to Portal",
                      style: GoogleFonts.poppins(
                          color: Colors.deepPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
