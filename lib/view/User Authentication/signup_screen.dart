import 'dart:io';
import 'package:attendence_manag_sys/components/button.dart';
import 'package:attendence_manag_sys/components/password_textfield.dart';
import 'package:attendence_manag_sys/components/text_field.dart';
import 'package:attendence_manag_sys/controllers/auth_services.dart';
import 'package:attendence_manag_sys/view/User%20Authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isloading = false;

  var options = [
    'Student',
    'Teacher',
  ];

  var currentItemSelected = "Student";
  var role = "Student";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? profilepic;

  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;

    bool isEmailValid(String email) {
      final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    Future createUser() async {
      String email = emailController.text.trim().toLowerCase();

      if (profilepic == null) {
        Get.snackbar("Error", "Please select a profile image");
        return;
      } else if (nameController.text.isEmpty) {
        Get.snackbar("Error", "Please enter your name");
        return;
      } else if (email.isEmpty) {
        Get.snackbar("Error", "Please enter email");
        return;
      } else if (!isEmailValid(email)) {
        Get.snackbar("Error", "Please enter a valid email");
        return;
      } else if (passwordController.text.isEmpty) {
        Get.snackbar("Error", "Please enter password");
        return;
      } else if (passwordController.text.length < 8) {
        Get.snackbar("Error", "Password should be at least 8 characters");
        return;
      }

      setState(() {
        isloading = true;
      });
      try {
        String? result = await authServices.userSignUp(
          name: nameController.text.toString(),
          email: emailController.text.toString(),
          role: role,
          password: passwordController.text.toString(),
          img: profilepic!,
        );
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        if (result == 'Success') {
          Get.snackbar('Success', 'Your account has been successfully created');
          Get.to(() => const LoginScreen(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        } else {
          Get.snackbar('Error', result!);
        }
      } catch (e) {
        Get.snackbar('Error', '$e');
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }

    // pick image from gallery
    Future pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        File convertedFile = File(image.path);
        setState(() {
          profilepic = convertedFile;
        });
      } else {
        Get.snackbar("Error", "No image selected");
      }
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: profilepic != null
                          ? FileImage(profilepic!)
                          : const AssetImage('images/profile.png'),
                    ),
                    IconButton(
                      onPressed: pickImage,
                      icon: const Icon(Icons.camera_enhance_sharp),
                      color: Colors.black,
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                CustomtextField(
                  title: 'Name',
                  controller: nameController,
                  prefixicon: const Icon(Icons.person),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomtextField(
                  title: 'Email',
                  controller: emailController,
                  prefixicon: const Icon(Icons.email),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                PasstextField(
                  title: 'Password',
                  controller: passwordController,
                  prefixicon: const Icon(Icons.lock),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomButton(
                  isloading: isloading,
                  title: 'SignUp',
                  ontap: createUser,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Didn't have an account? ",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(
                            () => const LoginScreen(
                                  role: true,
                                ),
                            transition: Transition.fade,
                            duration: const Duration(seconds: 2));
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                            color: Colors.deepPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
