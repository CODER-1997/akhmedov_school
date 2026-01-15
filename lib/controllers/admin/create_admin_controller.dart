import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../constants/utils.dart';
import '../../models/admin_model.dart';

class CreateAdminController extends GetxController {
  final nameCtrl = TextEditingController();
  final surnameCtrl = TextEditingController();
  final passcode = TextEditingController();






  // editable fields
  TextEditingController nameCtrlEdit = TextEditingController();
  TextEditingController surnameCtrlEdit = TextEditingController();
  TextEditingController passcodeEdit = TextEditingController();

  // Permissions
  RxBool attendance = false.obs;
  RxBool canEditPayment = false.obs;
  RxBool canEditStudent = false.obs;
  RxBool canDeleteStudent = false.obs;
  RxBool canEditGroup = false.obs;
  RxBool canRemoveGroup = false.obs;
  final CollectionReference _dataCollection =  FirebaseFirestore.instance.collection('AkhmedovAdmins');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  void addNewAdmin() async {
     try {
      AdminModel newData = AdminModel(
        name: nameCtrl.text,
        surname: surnameCtrl.text,
        uniqueId: generateUniqueId(),
        isBanned: false, allAccesses: {
        "attendance": attendance.value,
        "editPayment": canEditPayment.value,
        "editStudent": canEditStudent.value,
        "deleteStudent": canDeleteStudent.value,
        "editGroup": canEditGroup.value,
        "removeGroup": canRemoveGroup.value,
      },
          passcode: passcode.text

      );
      // Create a new document with an empty list
      await _dataCollection.add({
        'items': newData.toMap(),
      });

      Get.back();
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error:${e}',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
   }



  setValues(
      String name,
      String surname,
      String passcode,
      bool attendance,
      bool editPayment,
      bool editStudent,
       bool dltStudent,
      bool cnEdtGr,
      bool cnDltGr,


      ) {
    nameCtrlEdit = TextEditingController(text: name);
    surnameCtrlEdit = TextEditingController(text: surname);
    passcodeEdit = TextEditingController(text: passcode);
    attendanceEdit.value = attendance;
    canEditPaymentEdit.value=editPayment;
    canEditStudentEdit.value = editStudent;
    canDeleteStudentEdit.value  = dltStudent;
    canRemoveGroupEdit.value = cnDltGr;
    canEditGroupEdit.value = cnEdtGr;


   }



  RxBool attendanceEdit = false.obs;
  RxBool canEditPaymentEdit = false.obs;
  RxBool canEditStudentEdit = false.obs;
  RxBool canDeleteStudentEdit = false.obs;
  RxBool canEditGroupEdit = false.obs;
  RxBool canRemoveGroupEdit = false.obs;





  void editAdmin(String documentId) async {
     final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {

      // Reference to the document
      DocumentReference documentReference =
      _firestore.collection('AkhmedovAdmins').doc(documentId);
      // Update the desired field
      await documentReference.update({
        'items.name':nameCtrlEdit.text,
        'items.surname':surnameCtrlEdit.text,
        'items.passcode':passcodeEdit.text,
         'items.allAccesses': {
          "attendance": attendanceEdit.value,
          "editPayment": canEditPaymentEdit.value,
          "editStudent": canEditStudentEdit.value,
          "deleteStudent": canDeleteStudentEdit.value,
          "editGroup": canEditGroupEdit.value,
          "removeGroup": canRemoveGroupEdit.value,
        },

      });
       Get.back();

    } catch (e) {
      print('Error updating document field: $e');

    }
   }


}
