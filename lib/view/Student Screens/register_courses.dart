import 'package:attendence_manag_sys/components/reg_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterCourses extends StatefulWidget {
  const RegisterCourses({super.key});

  @override
  State<RegisterCourses> createState() => _RegisterCoursesState();
}

class _RegisterCoursesState extends State<RegisterCourses> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List selectedCourses = [];
  List registeredCourseIds = [];

  @override
  void initState() {
    super.initState();
    fetchRegisteredCourses();
  }

  Future<void> fetchRegisteredCourses() async {
    var currentUser = firebaseAuth.currentUser;
    var registeredCoursesSnapshot = await firebaseFirestore
        .collection('registered_courses')
        .where('student_id', isEqualTo: currentUser!.uid)
        .get();
    setState(() {
      registeredCourseIds = registeredCoursesSnapshot.docs
          .map((doc) => doc['course_id'])
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Course Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<QuerySnapshot>(
              future: firebaseFirestore.collection('courses').get(),
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
                        "No Course Available \n Please consult our teacher to assign courses",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          border: TableBorder.all(),
                          columns: const [
                            DataColumn(label: Text('Course')),
                            DataColumn(label: Text('Program')),
                            DataColumn(label: Text('Session')),
                            DataColumn(label: Text('Course Code')),
                          ],
                          rows: snapshot.data?.docs
                                  .where((doc) =>
                                      !registeredCourseIds.contains(doc.id))
                                  .map((doc) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: selectedCourses
                                                .contains(doc.id),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                if (value == true) {
                                                  selectedCourses.add(doc.id);
                                                } else {
                                                  selectedCourses
                                                      .remove(doc.id);
                                                }
                                              });
                                            },
                                          ),
                                          Text(doc['course'] ?? ''),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(doc['program'] ?? '')),
                                    DataCell(Text(doc['session'] ?? '')),
                                    DataCell(Text(doc['course_code'] ?? '')),
                                  ],
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RegisteredCourseButton(
                        ontap: () async {
                          var currentUser = firebaseAuth.currentUser;
                          for (var courseId in selectedCourses) {
                            var course = await firebaseFirestore
                                .collection('courses')
                                .doc(courseId)
                                .get();
                            var courseData = course.data();
                            courseData!['student_id'] = currentUser!.uid;
                            courseData['student_email'] = currentUser.email;
                            courseData['course_id'] = courseId;
                            await firebaseFirestore
                                .collection('registered_courses')
                                .add(courseData);
                          }
                          Get.snackbar(
                              'Success', 'Courses Registered Successfully');

                          setState(() {
                            selectedCourses.clear();
                            fetchRegisteredCourses();
                          });
                        },
                        title: 'Register Courses',
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
