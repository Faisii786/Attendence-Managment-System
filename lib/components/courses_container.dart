import 'package:attendence_manag_sys/view/Student%20Screens/courses_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterCoursesContainer extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback? onpressed;

  const RegisterCoursesContainer({
    super.key,
    this.title,
    this.description,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width * 1;
    final double height = MediaQuery.sizeOf(context).height * 1;
    return Container(
      height: height * .2,
      width: width * 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 2, color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: onpressed ??
                  () {
                    Get.to(() => const CoursesScreen(),
                        duration: const Duration(seconds: 2),
                        transition: Transition.fade);
                  },
              child: Text(
                title ?? "REGISTER COURSES",
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: width * .2,
                    height: height * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber,
                    ),
                    child: const Center(child: Icon(Icons.light))),
                SizedBox(
                  width: width * 0.04,
                ),
                Expanded(
                  child: Text(
                    description ?? "STUDENT COURSE ENROLLMENT",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: const Color.fromARGB(255, 112, 111, 111),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
