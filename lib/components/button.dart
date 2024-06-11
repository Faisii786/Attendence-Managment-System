import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final bool? isloading;
  const CustomButton(
      {super.key,
      required this.title,
      required this.ontap,
      this.isloading = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width * 1;
    double height = MediaQuery.sizeOf(context).height * 1;
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.deepPurple),
        width: width * 1,
        height: height * 0.08,
        child: Center(
            child: isloading == true
                ? const SpinKitFadingCircle(
                    color: Colors.white,
                    size: 30,
                  )
                : Text(
                    title,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  )),
      ),
    );
  }
}
