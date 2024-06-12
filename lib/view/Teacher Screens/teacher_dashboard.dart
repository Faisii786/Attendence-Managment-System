import 'package:attendence_manag_sys/components/courses_container.dart';
import 'package:attendence_manag_sys/controllers/auth_services.dart';
import 'package:attendence_manag_sys/view/Teacher%20Screens/add_course_page.dart';
import 'package:attendence_manag_sys/view/Teacher%20Screens/attendence_page.dart';
import 'package:attendence_manag_sys/view/Teacher%20Screens/registered_student_page.dart';
import 'package:attendence_manag_sys/view/User%20Authentication/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.sizeOf(context).width * 1;
    final double height = MediaQuery.sizeOf(context).height * 1;
    AuthServices authServices = AuthServices();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher"),
        actions: [
          InkWell(
              onTap: () async {
                await authServices.logout();
                Get.to(
                    () => const LoginScreen(
                          role: false,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegisterCoursesContainer(
              title: 'View Students',
              description: 'All Registered Students',
              onpressed: () {
                Get.to(() => const RegisteredStudentPage());
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            RegisterCoursesContainer(
              title: 'Mark Attendence',
              description: 'Mark Student Attendence',
              onpressed: () {
                Get.to(() => const AttendencePage());
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Courses",
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const AddCoursePage());
                  },
                  child: Text(
                    "Add Course",
                    style: GoogleFonts.poppins(
                        color: Colors.deepPurple,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: firebaseFirestore.collection('courses').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: TableBorder.all(),
                        columns: const [
                          DataColumn(label: Text('Subject')),
                          DataColumn(label: Text('Program')),
                          DataColumn(label: Text('Session')),
                          DataColumn(label: Text('Course Code')),
                        ],
                        rows: snapshot.data?.docs.map((doc) {
                              return DataRow(cells: [
                                DataCell(Text(doc['course'] ?? '')),
                                DataCell(Text(doc['program'] ?? '')),
                                DataCell(Text(doc['session'] ?? '')),
                                DataCell(Text(doc['course_code'] ?? '')),
                              ]);
                            }).toList() ??
                            [],
                      ),
                    );
                  }
                  return const Text("No Courses Available");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
