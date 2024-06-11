import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisteredCourseButton extends StatelessWidget {
  final String? title;
  final VoidCallback? ontap;
  const RegisteredCourseButton({super.key, this.title, this.ontap});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width * 1;
    final double height = MediaQuery.sizeOf(context).height * 1;
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width * .6,
        height: height * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.amber),
        child: Center(
          child: Text(
            title ?? "Search",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
