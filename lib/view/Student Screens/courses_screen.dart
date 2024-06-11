import 'package:attendence_manag_sys/components/reg_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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
                } else if (snapshot.hasData) {
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
            const SizedBox(
              height: 20,
            ),
            const RegisteredCourseButton(
              title: 'Registered Courses',
            ),
          ],
        ),
      ),
    );
  }
}
