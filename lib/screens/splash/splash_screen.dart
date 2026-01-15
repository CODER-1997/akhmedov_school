import 'package:akhmedov_school/controllers/auth/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:akhmedov_school/controllers/students/student_controller.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   var box = GetStorage();
   FireAuth Auth = Get.put(FireAuth());

  @override
  void initState() {
    Auth.getAdminById(box.read('admin_doc_id'));



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff012931), // Set the background color
      body: Stack(
        children: [
          // Centered Logo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Replace with your logo asset
                  width: 150, // Adjust size as needed
                  height: 150,
                ),
              ],
            ),
          ),
          // Circular Progress Indicator at the Bottom
          Positioned(
            bottom: 30, // Position above the bottom of the screen
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xffC9F2D2)), // Customize color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
