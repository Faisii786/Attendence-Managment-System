import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisteredStudentPage extends StatefulWidget {
  const RegisteredStudentPage({super.key});

  @override
  State<RegisteredStudentPage> createState() => _RegisteredStudentPageState();
}

class _RegisteredStudentPageState extends State<RegisteredStudentPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width * 1;
    // double height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students Record'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: firebaseFirestore.collection('students').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DataTable(
                        columnSpacing: width * 0.06,
                        border: const TableBorder(
                          verticalInside: BorderSide(color: Colors.grey),
                          left: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                          top: BorderSide(color: Colors.grey),
                        ),
                        columns: const [
                          DataColumn(label: Text('Profile')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Email')),
                        ],
                        rows: snapshot.data?.docs.map((doc) {
                              return DataRow(cells: [
                                DataCell(CircleAvatar(
                                  backgroundImage: NetworkImage(doc[
                                          'photoUrl'] ??
                                      const AssetImage('images/profile.png')),
                                )),
                                DataCell(Text(doc['name'] ?? '')),
                                DataCell(Text(doc['email'] ?? '')),
                              ]);
                            }).toList() ??
                            [],
                      ),
                    ),
                  );
                }
                return const Text("No Courses Available");
              },
            ),
          ),
        ],
      ),
    );
  }
}
