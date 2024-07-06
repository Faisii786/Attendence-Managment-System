import 'package:attendence_manag_sys/components/courses_container.dart';
import 'package:attendence_manag_sys/controllers/auth_services.dart';
import 'package:attendence_manag_sys/view/User%20Authentication/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome'),
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
              FutureBuilder<QuerySnapshot>(
                future: firebaseFirestore
                    .collection('registered_courses')
                    .where('student_id',
                        isEqualTo: firebaseAuth.currentUser!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "No record Found ! \n Please Register Courses First",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    ));
                  } else {
                    List registeredCourses = snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();
                    registeredCourses = registeredCourses.toSet().toList();
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: TableBorder.all(),
                        columns: const [
                          DataColumn(label: Text('Course')),
                          DataColumn(label: Text('Program')),
                          DataColumn(label: Text('Session')),
                          DataColumn(label: Text('Course Code')),
                        ],
                        rows: registeredCourses.map((course) {
                          return DataRow(
                            cells: [
                              DataCell(Text(course['course'] ?? '')),
                              DataCell(Text(course['program'] ?? '')),
                              DataCell(Text(course['session'] ?? '')),
                              DataCell(Text(course['course_code'] ?? '')),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
