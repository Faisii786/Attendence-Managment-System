import 'dart:async';

import 'package:attendence_manag_sys/components/button.dart';
import 'package:attendence_manag_sys/components/text_field.dart';
import 'package:attendence_manag_sys/controllers/auth_services.dart';
import 'package:attendence_manag_sys/view/User%20Authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class ForgetPassowrd extends StatefulWidget {
  const ForgetPassowrd({
    super.key,
  });

  @override
  State<ForgetPassowrd> createState() => _ForgetPassowrdState();
}

class _ForgetPassowrdState extends State<ForgetPassowrd> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    AuthServices authServices = AuthServices();

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    double width = MediaQuery.sizeOf(context).width * 1;
    double height = MediaQuery.sizeOf(context).height * 1;

    bool isEmailValid(String email) {
      final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    Future resetPassword() async {
      if (emailController.text.isEmpty) {
        Get.snackbar("Error", "Please enter your email");
        return;
      } else if (!isEmailValid(emailController.text)) {
        Get.snackbar("Error", "Please enter a valid email");
        return;
      }

      setState(() {
        isloading = true;
      });

      try {
        String result = await authServices.resetPassword(
          email: emailController.text.toString(),
        );

        if (result == 'Success') {
          emailController.clear();
          passwordController.clear();
          Get.snackbar('Success',
              'Please check your email for password reset instructions');

          Get.to(() => const LoginScreen(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        } else {
          Get.snackbar('Error', 'Failed to reset password: $result');
        }
      } on FirebaseAuthException catch (e) {
        Get.snackbar('Error', 'Failed to reset password: ${e.message}');
      } catch (e) {
        Get.snackbar('Error', 'An unexpected error occurred: $e');
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image(
                  image: const AssetImage('images/signup.png'),
                  width: width * .35,
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(
                  "Click 'Reset' and check your email for password reset instructions.",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.alatsi(
                      fontSize: 13,
                      color: const Color.fromARGB(213, 104, 58, 183),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                CustomtextField(
                  title: 'Email',
                  controller: emailController,
                  prefixicon: const Icon(Icons.email),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomButton(
                    isloading: isloading,
                    title: 'Reset Password',
                    ontap: () async {
                      await resetPassword();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
