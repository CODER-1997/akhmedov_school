
import 'package:akhmedov_school/screens/admin/admin_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../constants/login_utils.dart';
import '../../screens/auth/login.dart';
import '../../screens/home/home_screen.dart';

class FireAuth extends GetxController {
  TextEditingController teacherId = TextEditingController();
  RxBool isLoading = false.obs;
  RxList TeacherList = <DocumentSnapshot>[].obs;
  RxList AdminList = <DocumentSnapshot>[].obs;

  var box = GetStorage();
  RxBool isBanned = false.obs;

  @override
  void onInit() {
    getTeacherList();
    getAdminList();
    super.onInit();
  }

  // 1716225252433

  Future<List> getTeacherList() async {
    isLoading.value = true;
    TeacherList.clear();
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('AkhmedovTeachers').get();
      TeacherList.assignAll(snapshot.docs);
      isLoading.value = false;
      print("Teacher List ${TeacherList}");
   } catch (e) {
      isLoading.value = false;
    }
    return TeacherList;
  }
  Future<List> getAdminList() async {
    isLoading.value = true;
    AdminList.clear();
    try {
      QuerySnapshot snapshot =  await FirebaseFirestore.instance.collection('AkhmedovAdmins').get();
      AdminList.assignAll(snapshot.docs);
      isLoading.value = false;
      print("Admin List ${AdminList}");
    } catch (e) {
      isLoading.value = false;
    }
    return AdminList;
  }



  Future<void> getAdminById(String docId) async {
    final doc = await FirebaseFirestore.instance
        .collection('AkhmedovAdmins')
        .doc(docId)
        .get();



    if (doc.exists) {

      print(doc.data());
      print(doc.data()!['items']['allAccesses']);
      box.write('accesses', doc.data()!['items']['allAccesses']);
      if(doc.data()!['items']['passcode'] == box.read('AdminId')){
        Get.offAll(AdminHomeScreen());

      }
      else {
        showPasswordChangedModal();
      }





    } else {
      print('Document not found');
    }
  }








  void logOut() async {
    isLoading.value = true;
    try {
      box.write('isLogged', null);
      Get.off(Login());
      isLoading.value = true;
    } catch (e) {
      Get.snackbar(
        "Logout",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
    }
    isLoading.value = false;
  }


  void signIn(String userId) async {
    await getTeacherList();
     isLoading.value = true;
    var holat = true;
    int i = 0;
    isLoading.value = true;
    try {
      print("Test" + TeacherList[0]['items']['name']);

      while (holat) {
        if (TeacherList[i]['items']['uniqueId'] == userId) {
          holat = false;
          box.write('teacherName', TeacherList[i]['items']['name']);
          box.write('teacherSurname', TeacherList[i]['items']['surname']);
          box.write('teacherId', TeacherList[i]['items']['uniqueId']);
          box.write('teacherDocId', TeacherList[i].id);
          isBanned.value = TeacherList[i]['items']['isBanned'];
          box.write('isLogged', 'teacher');
          Get.offAll(HomeScreen());


        } else {
          holat = true;
          i++;

        }
      }

      isLoading.value = true;
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        "Foydalanuvchi topilmadi",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void signInAdmin(String userId,String name) async {
    await getAdminList();
     isLoading.value = true;
    var holat = true;
    int i = 0;
    isLoading.value = true;
    try {

      while (holat) {
        if (AdminList[i]['items']['passcode'] == userId && AdminList[i]['items']['name'] == name) {
          holat = false;
          box.write('AdminName', AdminList[i]['items']['name']);
          box.write('AdminSurname', AdminList[i]['items']['surname']);
          box.write('AdminId', AdminList[i]['items']['passcode']);
          box.write('admin_doc_id', AdminList[i].id);
           isBanned.value = AdminList[i]['items']['isBanned'];
          box.write('isLogged', 'admin');
          box.write('accesses', AdminList[i]['items']['allAccesses']);

          Get.off(AdminHomeScreen());


        } else {
          holat = true;
          i++;

        }
      }

      isLoading.value = true;
    } catch (e) {
      Get.snackbar(
        "Xatolik",
        "Admin topilmadi",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
    }
    isLoading.value = false;
  }







}
