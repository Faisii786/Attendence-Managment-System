import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendencePage extends StatefulWidget {
  const AttendencePage({super.key});

  @override
  State<AttendencePage> createState() => _AttendencePageState();
}

class _AttendencePageState extends State<AttendencePage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String selectedCourse = '';
  Map<String, bool> attendanceMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
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
                        "No Course Available \n Please consult your administrator to assign courses",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    ),
                  );
                } else {
                  return DropdownButton<String>(
                    value: selectedCourse.isEmpty ? null : selectedCourse,
                    hint: const Text("Select a course"),
                    onChanged: (value) {
                      setState(() {
                        selectedCourse = value!;
                      });
                    },
                    items: snapshot.data?.docs.map((doc) {
                          return DropdownMenuItem(
                            value: doc.id,
                            child: Text(doc['course'] ?? ''),
                          );
                        }).toList() ??
                        [],
                  );
                }
              },
            ),
            if (selectedCourse.isNotEmpty)
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: firebaseFirestore
                      .collection('students')
                      .where('registered_courses',
                          arrayContains: selectedCourse)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Text(
                            "No Students Enrolled in this course",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ),
                      );
                    } else {
                      return ListView(
                        children: snapshot.data!.docs.map((doc) {
                          return ListTile(
                            title: Text(doc['name'] ?? ''),
                            trailing: Checkbox(
                              value: attendanceMap[doc.id] ?? false,
                              onChanged: (value) {
                                setState(() {
                                  attendanceMap[doc.id] = value!;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            if (selectedCourse.isNotEmpty)
              ElevatedButton(
                onPressed: () async {
                  DateTime now = DateTime.now();
                  for (var studentId in attendanceMap.keys) {
                    await firebaseFirestore.collection('attendance').add({
                      'courseId': selectedCourse,
                      'studentId': studentId,
                      'date': now,
                      'status': attendanceMap[studentId] == true
                          ? 'Present'
                          : 'Absent',
                    });
                  }
                  Get.snackbar('Success', 'Attendance marked successfully');
                  setState(() {
                    attendanceMap.clear();
                  });
                },
                child: const Text("Submit Attendance"),
              ),
          ],
        ),
      ),
    );
  }
}
