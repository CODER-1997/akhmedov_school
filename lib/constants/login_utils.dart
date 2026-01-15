
import 'package:akhmedov_school/screens/auth/login.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
GetStorage box = GetStorage();

bool checkAccess(String type){
      final accessType = box.read('accesses');
      final login = box.read('isLogged');
      if(accessType !=null && login =='admin'){
         return box.read('accesses')[type] ;

      }
      return true;

}


    void showPasswordChangedModal() {
      Get.bottomSheet(
         Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(20),
               boxShadow: [
                  BoxShadow(
                     color: Colors.black.withOpacity(0.1),
                     blurRadius: 10,
                     offset: const Offset(0, 5),
                  ),
               ],
            ),
            child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                  // Icon
                  Container(
                     width: 60,
                     height: 60,
                     decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                     ),
                     child: const Icon(
                        Icons.lock,
                        size: 32,
                        color: Colors.blue,
                     ),
                  ),
                  const SizedBox(height: 16),

                  // Message
                  const Text(
                     "Your password was changed by Admin",
                     textAlign: TextAlign.center,
                     style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                     ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                     children: [
                        // Cancel Button
                        Expanded(
                           child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.grey.shade300,
                                 shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                 ),
                              ),
                              onPressed: () {
                               },
                              child: const Text(
                                 "Cancel",
                                 style: TextStyle(color: Colors.black),
                              ),
                           ),
                        ),
                        const SizedBox(width: 12),

                        // Go to Login Button
                        Expanded(
                           child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.blue,
                                 shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                 ),
                              ),
                              onPressed: () {
                                 Get.to(Login()); // Navigate to login
                              },
                              child: const Text(
                                 "Go to Login",
                                 style: TextStyle(color: Colors.white),
                              ),
                           ),
                        ),
                     ],
                  ),
               ],
            ),
         ),
         isDismissible: false,
         enableDrag: false,
         backgroundColor: Colors.transparent,
      );
   }

