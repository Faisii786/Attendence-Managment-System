import 'package:attendence_manag_sys/components/button.dart';
import 'package:attendence_manag_sys/view/User%20Authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('images/bg.png'),
              width: width * 1,
              height: height * .4,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              'Wellcome Back !',
              style: GoogleFonts.poppins(
                  fontSize: 13, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            CustomButton(
                title: 'Teacher Portal ',
                ontap: () {
                  Get.to(
                    () => const LoginScreen(
                      role: false,
                    ),
                    duration: const Duration(seconds: 2),
                    transition: Transition.fade,
                  );
                }),
            SizedBox(
              height: height * 0.03,
            ),
            CustomButton(
                title: 'Student Portal ',
                ontap: () {
                  Get.to(
                    () => const LoginScreen(
                      role: true,
                    ),
                    duration: const Duration(seconds: 2),
                    transition: Transition.fade,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
