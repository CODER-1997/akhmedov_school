
import 'package:akhmedov_school/screens/admin/admins/adminCard.dart';
import 'package:akhmedov_school/screens/admin/admins/create_new_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:akhmedov_school/screens/admin/teachers/teacherInfo.dart';
import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/custom_dialog.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../controllers/admin/teachers_controller.dart';
import '../../../controllers/students/student_controller.dart';

class AllAdmins extends StatefulWidget {
  @override
  State<AllAdmins> createState() => _AllAdminsState();
}

class _AllAdminsState extends State<AllAdmins> {
  final _formKey = GlobalKey<FormState>();


  String _searchText = '';









  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe8e8e8),
        appBar: AppBar(
          backgroundColor: dashBoardColor,
          toolbarHeight: 64,
          actions: [

             CreateNewAdmin()



          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all( 0),
            child: Column(
              children: [

                StreamBuilder(
                    stream:FirebaseFirestore.instance
                        .collection('AkhmedovAdmins')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.hasData) {
                        var admins = snapshot.data!.docs;

                        return admins.length != 0
                            ? Column(
                          children: [
                            for (int i = 0; i < admins.length; i++)
                              AdminCard(
                                  name: admins[i]['items']['name'],
                                  passcode: admins[i]['items']['passcode'],
                                  surname: admins[i]['items']['surname'],
                                documentId:  admins[i].id,
                                attendance: admins[i]['items']['allAccesses']['attendance'],
                                editPayment: admins[i]['items']['allAccesses']['editPayment'],
                                editStudent: admins[i]['items']['allAccesses']['editStudent'],
                                 dltStudent: admins[i]['items']['allAccesses']['deleteStudent'],
                                cnEdtGr: admins[i]['items']['allAccesses']['editGroup'],
                                cnDltGr: admins[i]['items']['allAccesses']['removeGroup'],)
                          ],
                        )
                            : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: Get.height/5,),
                              Image.asset(
                                'assets/empty.png',
                                width: 222,
                              ),
                              Text(
                                'Our center has not any Admins ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        );
                      }
                      // If no data available

                      else {
                        return Text('No data'); // No data available
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
