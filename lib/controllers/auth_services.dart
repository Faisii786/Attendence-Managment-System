import 'dart:io';

import 'package:attendence_manag_sys/Model/use_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String result = 'Some Error Occured';

  // student portal
  Future<String?> userSignUp({
    required String name,
    required String email,
    required String role,
    required String password,
    required File? img,
  }) async {
    try {
      // Sign up the user with Firebase Auth
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      // Profile pic stored in Database
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('profilePicture')
          .child(user!.uid)
          .putFile(img!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Data is stored on Firestore
      StudentModel userModel = StudentModel(
          user.uid, name, email, role, password, downloadUrl, '', '', '', '');
      await firestore.collection('students').doc(user.uid).set(
            userModel.toJson(),
          );
      result = 'Success';
    } on FirebaseAuthException catch (e) {
      result = e.message.toString();
    } catch (ex) {
      result = ex.toString();
    }
    return result;
  }

  Future userlogin({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      result = 'Success';
    } on FirebaseAuthException catch (e) {
      result = e.message.toString();
    } catch (ex) {
      result = ex.toString();
    }
    return result;
  }

  Future resetPassword({
    required String email,
  }) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
      result = 'Success';
    } on FirebaseAuthException catch (e) {
      result = e.message.toString();
    } catch (ex) {
      result = ex.toString();
    }
    return result;
  }

  Future logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }
    return result;
  }

  // teacher portal
  Future<String?> addCourse({
    required String subject,
    required String program,
    required String session,
    required String courseCode,
  }) async {
    try {
      await firestore.collection('courses').doc(const Uuid().v1()).set({
        'course': subject,
        'program': program,
        'session': session,
        'course_code': courseCode
      });
      result = 'Success';
    } on FirebaseAuthException catch (e) {
      result = e.message.toString();
    } catch (ex) {
      result = ex.toString();
    }
    return result;
  }
}
