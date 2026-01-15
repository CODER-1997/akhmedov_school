import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/auth/login_controller.dart';
import '../admin/admin_home_screen.dart';

class Login extends StatelessWidget {
  Login({super.key});

  // UI state
  final RxBool isAdmin = false.obs;

  // controllers (LOGIC NOT CHANGED)
  final FireAuth auth = Get.put(FireAuth());
  final GetStorage box = GetStorage();
 TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF012931),
              Color(0xFF001F24),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // TITLE
                  const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ROLE SWITCH
                  Obx(() => CupertinoSlidingSegmentedControl<bool>(
                    groupValue: isAdmin.value,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    thumbColor: Colors.white.withOpacity(0.3),
                    children: const {
                      false: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Teacher',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      true: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Admin',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    },
                    onValueChanged: (v) => isAdmin.value = v!,
                  )),

                  const SizedBox(height: 20),

                  // ADMIN NAME (ONLY ADMIN)
                  Obx(() => isAdmin.value
                      ? TextFormField(
                    controller: name,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter admin name',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.white70,
                      ),
                    ),
                  )
                      : const SizedBox.shrink()),

                  Obx(() =>
                  isAdmin.value ? const SizedBox(height: 16) : const SizedBox()),

                 TextFormField(
                    keyboardType:   TextInputType.text,
                    controller: auth.teacherId,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: isAdmin.value
                          ? 'Enter admin code'
                          : 'Enter teacher code',
                      hintStyle:
                      TextStyle(color: Colors.white.withOpacity(0.5)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.white70,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // LOGIN BUTTON (LOGIC SAME)
                  ElevatedButton(
                    onPressed: () {
              if (auth.teacherId.text == '0094' ) {
                        box.write('isLogged', auth.teacherId.text);
                        Get.offAll(AdminHomeScreen());
                      }



             else {

          if(isAdmin.value){

            auth.signInAdmin(auth.teacherId.text, name.text);

          }
          else {
            auth.signIn(auth.teacherId.text);

          }




                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF00D2FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'login'.tr.capitalizeFirst!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FOOTER
                  const Text(
                    'Authorized staff only',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
