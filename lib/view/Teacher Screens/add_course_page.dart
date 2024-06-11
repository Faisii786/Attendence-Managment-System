import 'package:attendence_manag_sys/components/button.dart';
import 'package:attendence_manag_sys/components/text_field.dart';
import 'package:attendence_manag_sys/controllers/auth_services.dart';
import 'package:attendence_manag_sys/view/Teacher%20Screens/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController programtController = TextEditingController();
  TextEditingController sessionController = TextEditingController();
  TextEditingController courseCodeController = TextEditingController();
  bool isloading = false;

  AuthServices authServices = AuthServices();

  Future addCourses() async {
    if (subjectController.text.isEmpty) {
      Get.snackbar("Error", "Please enter subject name");
      return;
    } else if (programtController.text.isEmpty) {
      Get.snackbar("Error", "Please enter program name");
      return;
    } else if (sessionController.text.isEmpty) {
      Get.snackbar("Error", "Please enter session name");
      return;
    } else if (courseCodeController.text.isEmpty) {
      Get.snackbar("Error", "Please enter course code");
      return;
    }

    setState(() {
      isloading = true;
    });
    try {
      String? result = await authServices.addCourse(
          subject: subjectController.text.toString(),
          program: programtController.text.toString(),
          session: sessionController.text.toString(),
          courseCode: courseCodeController.text.toString());

      if (result == 'Success') {
        subjectController.clear();
        programtController.clear();
        sessionController.clear();
        courseCodeController.clear();
        Get.snackbar('Success', 'Course is added Sucessfully');

        Get.to(() => const TeacherDashboard(),
            transition: Transition.fade, duration: const Duration(seconds: 2));

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add courses"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Please enter the above detail",
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomtextField(
                title: 'Subject',
                controller: subjectController,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomtextField(
                title: 'Program',
                controller: programtController,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomtextField(
                title: 'Session',
                controller: sessionController,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomtextField(
                title: 'Course Code',
                controller: courseCodeController,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomButton(
                  title: 'Add Course',
                  isloading: isloading,
                  ontap: () async {
                    await addCourses();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
