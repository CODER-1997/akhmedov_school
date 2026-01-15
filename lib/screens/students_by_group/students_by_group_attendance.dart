import 'package:akhmedov_school/constants/custom_widgets/no_access_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../constants/custom_widgets/gradient_button.dart';
import '../../constants/date_utils.dart';
import '../../constants/login_utils.dart';
import '../../constants/text_styles.dart';
import '../../constants/utils.dart';
import '../../controllers/students/student_controller.dart';
import '../../services/sms_service.dart';
import '../admin/students/student_info.dart';
import 'additional_funcs/add_student.dart';

class Attendance extends StatelessWidget {
  final String groupId;
  final String groupName;

  Attendance({
    required this.groupId,
    required this.groupName,
  });

  GetStorage box = GetStorage();

  RxList students = [].obs;
  RxList selectedStudents = [].obs;
  static RxBool messageLoader = false.obs;
  RxBool messageLoader2 = false.obs;
  RxBool messageLoader3 = false.obs;
  TextEditingController customMessage = TextEditingController();
  RxBool isStudentChoosen = false.obs;
  StudentController studentController = Get.put(StudentController());
  final _formKey = GlobalKey<FormState>();
  RxList studentList = [].obs;
  SMSService _smsService = SMSService();

  RxList list = [].obs;
  RxList attendedStudents = [].obs;
  RxList unattendedStudents = [].obs;


  List calculateUnpaidMonths(List studyDays,List payments){

    var studyMonths = [];
    var paidMonths = [];
    var shouldPay=[];

    for(int i = 0;i < studyDays.length;i++){
      if(!studyMonths.contains(convertDateToMonthYear(studyDays[i]['studyDay']))){
        studyMonths.add(convertDateToMonthYear(studyDays[i]['studyDay']));
      }
    }
    for(int i = 0;i < payments.length;i++){
      if(!paidMonths.contains(convertDateToMonthYear(payments[i]['paidDate']))){
        paidMonths.add(convertDateToMonthYear(payments[i]['paidDate']));
      }
    }
    for(int i = 0;i< studyMonths.length;i++){
      var month = studyMonths[i];
      if(!paidMonths.contains(month)){
        shouldPay.add(month);
      }

    }





    return shouldPay;

  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   width: Get.width-32,
            //   padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 8),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(4)
            //   ),
            //   child: Text(widget.lessonType.capitalizeFirst! + " Lesson",style: appBarStyle,),
            // ),
            // Form(
            //   key: _formKey,
            //   child: TextField(
            //     decoration: InputDecoration(
            //       labelText: 'Search Items',
            //       border: OutlineInputBorder(),
            //     ),
            //     onChanged: (value) {
            //       setState(() {
            //         _searchText = value.toLowerCase();
            //       });
            //     },
            //   ),
            // ),
            // SizedBox(height: 20),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('AkhmedovStudents')
                    .where('items.isDeleted', isEqualTo: false)
                    .where('items.groupId', isEqualTo: groupId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    var list = snapshot.data!.docs;

                    students.clear();
                    for (int i = 0; i < list.length; i++) {
                      students.add({
                        'name': list[i]['items']['name'],
                        'id': list[i].id,
                        'surname': list[i]['items']['surname'],
                        'payments': list[i]['items']['payments'],
                        'studyDays': list[i]['items']['studyDays'],
                        'uniqueId': list[i]['items']['uniqueId'],
                        'phone': list[i]['items']['phone'],
                        'parentPhone': list[i]['items']['parentPhone'],
                        'isFreeOfcharge': list[i]['items']['isFreeOfcharge'],
                      });
                    }

                    return students.length != 0
                        ? Obx(() => Column(
                              children: [
                                isStudentChoosen.value
                                    ? Container(
                                        padding: EdgeInsets.all(16),
                                        width: Get.width,
                                        decoration:
                                            BoxDecoration(color: Colors.green),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${selectedStudents.length} student(s) selected',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 22,
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        isStudentChoosen.value =
                                                            false;
                                                        selectedStudents
                                                            .clear();
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 22,
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        if (selectedStudents
                                                                .length ==
                                                            students.length) {
                                                          selectedStudents
                                                              .clear();
                                                        } else {
                                                          selectedStudents
                                                              .clear();
                                                          selectedStudents
                                                              .addAll(students);
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.select_all,
                                                        color: Colors.white,
                                                      )),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                for (int i = 0; i < students.length; i++)
                                  Container(
                                    key: ValueKey(students[i]['id']),
                                    child: GestureDetector(
                                      onLongPress: () {
                                        isStudentChoosen.value = true;
                                      },
                                      onTap: () {
                                        if (
                                            isStudentChoosen.value == false) {
                                          Get.to(StudentInfo(
                                            studentId: students[i]['id'],
                                          ));
                                        }
                                        if (isStudentChoosen.value == true) {
                                          print('Working....');
                                          if (selectedStudents
                                              .contains(students[i])) {
                                            selectedStudents.removeWhere(
                                                (el) => el == students[i]);
                                          } else {
                                            selectedStudents.add(students[i]);
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 1),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: CupertinoColors.white),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                isStudentChoosen.value
                                                    ? Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: selectedStudents
                                                                    .contains(students[
                                                                        i])
                                                                ? Colors.green
                                                                : Colors.white,
                                                            border: Border.all(
                                                                color: selectedStudents
                                                                        .contains(
                                                                            students[
                                                                                i])
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .grey,
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 12,
                                                        ),
                                                      )
                                                    : Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: students[i][
                                                                    'isFreeOfcharge'] ==
                                                                true
                                                            ? Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/verified.png',
                                                                    width: 25,
                                                                    color: CupertinoColors
                                                                        .systemYellow,
                                                                  ),
                                                                  Text(
                                                                    "${i + 1}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(
                                                                child: Text(
                                                                  "${i + 1}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                width: 25,
                                                                height: 25,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    color: hasDebt(students[i]
                                                                            [
                                                                            'payments'])
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .green),
                                                              ),
                                                      ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: Get.width / 2.5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            students[i]['name']
                                                                    .toString()
                                                                    .capitalizeFirst! +
                                                                " " +
                                                                students[i][
                                                                        'surname']
                                                                    .toString()
                                                                    .capitalizeFirst!,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          students[i]['phone']
                                                                  .toString()
                                                                  .isEmpty
                                                              ? Text(
                                                                  "Phone number is empty",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                )
                                                              : SizedBox()
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    hasDebtFromPayment(
                                                            students[i]
                                                                ['payments'])
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: Text(
                                                              "To'lovda chalasi bor !",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                          )
                                                        : SizedBox(),
                                                    students[i]['isFreeOfcharge'] ==
                                                            false
                                                        ? (calculateUnpaidMonths(
                                                                        students[i]
                                                                            [
                                                                            'studyDays'],
                                                                        students[i]
                                                                            [
                                                                            'payments'])
                                                                    .length !=
                                                                0
                                                            ? Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                child: Text(
                                                                  '${calculateUnpaidMonths(students[i]['studyDays'], students[i]['payments']).length} oylik to\'lov qolgan',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .red,
                                                                        width:
                                                                            1)),
                                                              )
                                                            : SizedBox())
                                                        : SizedBox(),
                                                  ],
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                )
                                              ],
                                            ),
                                            checkAccess('attendance') == true?  Row(
                                              children: [
                                                getReason(
                                                            students[i]
                                                                ['studyDays'],
                                                            studentController
                                                                .selectedStudyDate
                                                                .value)
                                                        .isNotEmpty
                                                    ? Container(
                                                        width: Get.width / 6,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            right: 4, top: 8),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4,
                                                                vertical: 4),
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        122),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.red,
                                                                width: 2)),
                                                        child: Text(
                                                          "${getReason(students[i]['studyDays'], studentController.selectedStudyDate.value)}",
                                                          style: appBarStyle.copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 8,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                InkWell(
                                                  onTap: () {
                                                    if (checkStatus(
                                                            students[i]
                                                                ['studyDays'],
                                                            studentController
                                                                .selectedStudyDate
                                                                .value) ==
                                                        'true') {
                                                      studentController
                                                          .removeStudyDay(
                                                              students[i]['id'],
                                                              groupId,
                                                              students[i]
                                                                  ['uniqueId'],
                                                              {
                                                                'hasReason':
                                                                    false,
                                                                'commentary':
                                                                    "",
                                                              },
                                                              true);
                                                    } else {
                                                      studentController
                                                          .setStudyDay(
                                                              students[i]['id'],
                                                              groupId,
                                                              students[i]
                                                                  ['uniqueId'],
                                                              {
                                                                'hasReason':
                                                                    false,
                                                                'commentary':
                                                                    "",
                                                              },
                                                              true);
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.green.withOpacity(checkStatus(
                                                                        students[i]
                                                                            [
                                                                            'studyDays'],
                                                                        studentController
                                                                            .selectedStudyDate
                                                                            .value) !=
                                                                    'true' ||
                                                                checkStatus(
                                                                        students[i]
                                                                            [
                                                                            'studyDays'],
                                                                        studentController
                                                                            .selectedStudyDate
                                                                            .value) ==
                                                                    'notGiven'
                                                            ? .3
                                                            : 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 16),
                                                    child: Text(
                                                      'Bor',
                                                      style: TextStyle(
                                                          color: checkStatus(
                                                                          students[i]
                                                                              [
                                                                              'studyDays'],
                                                                          studentController
                                                                              .selectedStudyDate
                                                                              .value) !=
                                                                      'true' ||
                                                                  checkStatus(
                                                                          students[i]
                                                                              [
                                                                              'studyDays'],
                                                                          studentController
                                                                              .selectedStudyDate
                                                                              .value) ==
                                                                      'notGiven'
                                                              ? Colors.green
                                                              : Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (checkStatus(
                                                            students[i]
                                                                ['studyDays'],
                                                            studentController
                                                                .selectedStudyDate
                                                                .value) ==
                                                        'false') {
                                                      studentController
                                                          .removeStudyDay(
                                                              students[i]['id'],
                                                              groupId,
                                                              students[i]
                                                                  ['uniqueId'],
                                                              {
                                                                'hasReason':
                                                                    false,
                                                                'commentary':
                                                                    "",
                                                              },
                                                              true);
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0)),
                                                            //this right here
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(16),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12)),
                                                              width: Get.width -
                                                                  64,
                                                              height:
                                                                  Get.height /
                                                                      3,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "Reason"),
                                                                  TextFormField(
                                                                    maxLines: 2,

                                                                    controller:
                                                                        studentController
                                                                            .reasonOfBeingAbsent,
                                                                    decoration:
                                                                        buildInputDecoratione(
                                                                            'Reason (Optional)'),
                                                                    // validator: (value) {
                                                                    //   if (value!.isEmpty) {
                                                                    //     return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                    //   }
                                                                    //   return null;
                                                                    // },
                                                                  ),
                                                                  Obx(() => Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              studentController.selectedAbsenseReason.value = "Sababli";
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: studentController.selectedAbsenseReason.value == "Sababli" ? Colors.red : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black)),
                                                                              child: Text(
                                                                                "Sababli",
                                                                                style: TextStyle(
                                                                                  color: studentController.selectedAbsenseReason.value == "Sababli" ? Colors.white : Colors.black,
                                                                                ),
                                                                              ),
                                                                              padding: EdgeInsets.all(8),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              studentController.selectedAbsenseReason.value = "Sababsiz";
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: studentController.selectedAbsenseReason.value == "Sababsiz" ? Colors.red : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black)),
                                                                              child: Text(
                                                                                "Sababsiz",
                                                                                style: TextStyle(
                                                                                  color: studentController.selectedAbsenseReason.value == "Sababsiz" ? Colors.white : Colors.black,
                                                                                ),
                                                                              ),
                                                                              padding: EdgeInsets.all(8),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (studentController
                                                                              .reasonOfBeingAbsent
                                                                              .text
                                                                              .isEmpty &&
                                                                          studentController
                                                                              .selectedAbsenseReason
                                                                              .value
                                                                              .isEmpty) {
                                                                        Get.back();
                                                                      } else {
                                                                        studentController.setStudyDay(
                                                                            students[i]['id'],
                                                                            groupId,
                                                                            students[i]['uniqueId'],
                                                                            {
                                                                              'hasReason': studentController.selectedAbsenseReason.value == "Sababli" ? true : false,
                                                                              'commentary': studentController.reasonOfBeingAbsent.text.isEmpty ? studentController.selectedAbsenseReason.value : studentController.reasonOfBeingAbsent.text,
                                                                            },
                                                                            false);

                                                                        Get.back();
                                                                      }
                                                                    },
                                                                    child: Obx(() => CustomButton(
                                                                        color: Colors
                                                                            .red,
                                                                        isLoading: studentController
                                                                            .isLoading
                                                                            .value,
                                                                        text: 'confirm'
                                                                            .tr
                                                                            .capitalizeFirst!)),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.red.withOpacity(checkStatus(
                                                                        students[i]
                                                                            [
                                                                            'studyDays'],
                                                                        studentController
                                                                            .selectedStudyDate
                                                                            .value) ==
                                                                    'notChecked' ||
                                                                checkStatus(
                                                                        students[i]
                                                                            [
                                                                            'studyDays'],
                                                                        studentController
                                                                            .selectedStudyDate
                                                                            .value) ==
                                                                    'true'
                                                            ? .3
                                                            : 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 16),
                                                    child: Text(
                                                      "Yo'q",
                                                      style: TextStyle(
                                                          color: checkStatus(
                                                                          students[i]
                                                                              [
                                                                              'studyDays'],
                                                                          studentController
                                                                              .selectedStudyDate
                                                                              .value) ==
                                                                      'notChecked' ||
                                                                  checkStatus(
                                                                          students[i]
                                                                              [
                                                                              'studyDays'],
                                                                          studentController
                                                                              .selectedStudyDate
                                                                              .value) ==
                                                                      'true'
                                                              ? Colors.red
                                                              : Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                  ),
                                                ),

                                                // TextButton(
                                                //   onPressed: () {
                                                //     studentController
                                                //         .setStudyDay(
                                                //             students[i].id,
                                                //             groupId,
                                                //             students[i]
                                                //
                                                //                 ['uniqueId'],
                                                //             {
                                                //           'hasReason': false,
                                                //           'commentary': ""
                                                //         });
                                                //   },
                                                //   child: Text(
                                                //     checkStatus(
                                                //       students[i]['items']
                                                //           ['studyDays'],
                                                //     )
                                                //         ? 'Present'
                                                //         : "Absent",
                                                //     style: TextStyle(
                                                //         fontSize: 12,
                                                //         fontWeight:
                                                //             FontWeight.w900,
                                                //         color: checkStatus(
                                                //           students[i]['items']
                                                //               ['studyDays'],
                                                //         )
                                                //             ? greenColor
                                                //             : Colors.red),
                                                //   ),
                                                // ),

                                                // Visibility(
                                                //   visible: hasDebt(students[i]['items']
                                                //   ['payments']),
                                                //   child: Container(
                                                //     padding: EdgeInsets.all(16),
                                                //     decoration: BoxDecoration(
                                                //         color: Colors.red,
                                                //         border: Border.all(color: Colors.red,width: 1),
                                                //         borderRadius: BorderRadius.circular(102)
                                                //     ),
                                                //     child: Text("Fee unpaid",style: appBarStyle.copyWith(color: Colors.white,fontSize: 16),),
                                                //   ),
                                                // ),
                                              ],
                                            ):NoAccessAttendanceButton()
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ))
                        : Container(
                            alignment: Alignment.center,
                            height: Get.height * .8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/empty.png',
                                  width: 150,
                                ),
                                Text(
                                  'This group has not any students ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
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
      bottomNavigationBar:checkAccess('attendance') == true? Container(
        height: 66,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () async {
                  if (selectedStudents.isEmpty) {
                    Get.snackbar(
                      'Error', // Title
                      'Students are not selected', // Message
                      snackPosition: SnackPosition.TOP,
                      // Position of the snackbar
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      borderRadius: 8,
                      margin: EdgeInsets.all(10),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          insetPadding: EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          //this right here
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            width: Get.width,
                            height: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Do you want to really send sms to numbers',
                                      style: appBarStyle.copyWith(),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        Get.back();
                                        messageLoader.value = true;
                                        for (int i = 0;
                                            i < selectedStudents.length;
                                            i++) {
                                          if (checkStatus(
                                                  selectedStudents[i]
                                                      ['studyDays'],
                                                  studentController
                                                      .selectedStudyDate
                                                      .value) ==
                                              'true') {
                                            if (await Permission
                                                    .sms.isGranted &&
                                                selectedStudents[i]['parentPhone']
                                                    .toString()
                                                    .isNotEmpty) {
                                              _smsService.sendSMS(
                                                  selectedStudents[i]['parentPhone'],
                                                  "Assalomu Aleykum ,"
                                                  "\nFarzandingiz ${selectedStudents[i]['surname'].toString().capitalizeFirst}  ${selectedStudents[i]['name'].toString().capitalizeFirst!}  bugungi    darsga keldi. "
                                                  "\nHurmat bilan AKHMEDOV SCHOOL");
                                            }
                                          } else if (checkStatus(
                                                  selectedStudents[i]
                                                      ['studyDays'],
                                                  studentController
                                                      .selectedStudyDate
                                                      .value) ==
                                              'false') {
                                            if (await Permission
                                                    .sms.isGranted &&
                                                selectedStudents[i]['parentPhone']
                                                    .toString()
                                                    .isNotEmpty) {
                                              var sabab = hasReason(
                                                      selectedStudents[i]
                                                          ['studyDays'],
                                                      studentController
                                                          .selectedStudyDate
                                                          .value)
                                                  ? "sababli"
                                                  : "sababsiz";

                                              _smsService.sendSMS(
                                                  selectedStudents[i]['parentPhone'],
                                                  ""
                                                  "Assalomu Aleykum ,"
                                                  "\nFarzandingiz ${selectedStudents[i]['surname'].toString().capitalizeFirst!}  ${selectedStudents[i]['name'].toString().capitalizeFirst!}  bugungi ingliz tili  darsiga $sabab kelmadi. "
                                                  "\nHurmat bilan AKHMEDOV SCHOOL");
                                            }
                                          } else {
                                            print('Sms yuborilmadi');
                                          }
                                          await Future.delayed(
                                              Duration(seconds: 1));
                                        }

                                        messageLoader.value = false;
                                        selectedStudents.clear();
                                        isStudentChoosen.value = false;

                                        Get.snackbar(
                                          'Message', // Title
                                          'Your message has been sent',
                                          // Message
                                          snackPosition: SnackPosition.BOTTOM,
                                          // Position of the snackbar
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          borderRadius: 8,
                                          margin: EdgeInsets.all(10),
                                        );
                                      },
                                      child: Text(
                                        'Confirm'.tr.capitalizeFirst!,
                                        style: appBarStyle.copyWith(
                                            color: Colors.green),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: Get.back,
                                        child: Text(
                                          'Cancel',
                                          style: appBarStyle.copyWith(
                                              color: Colors.red),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                child: Obx(() => CustomButton(
                      color: Colors.green,
                      text: messageLoader.value
                          ? "Sending ..."
                          : 'attendance'.tr.capitalizeFirst!,
                    )),
              )),
              box.read('isLogged') == '0094' || box.read('isLogged') == 'admin'
                  ? Expanded(
                      child: InkWell(
                      onTap: () async {
                        if (selectedStudents.isEmpty) {
                          Get.snackbar(
                            'Error', // Title
                            'Students are not selected', // Message
                            snackPosition: SnackPosition.TOP,
                            // Position of the snackbar
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            borderRadius: 8,
                            margin: EdgeInsets.all(10),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                insetPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                //this right here
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12)),
                                  width: Get.width,
                                  height: 180,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'Do you want to really send sms to numbers',
                                            style: appBarStyle.copyWith(),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              Get.back();
                                              messageLoader2.value = true;

                                  for (int i = 0; i < selectedStudents.length; i++) {
                           if (
                                    selectedStudents[i][  'isFreeOfcharge'] == false &&
                                    selectedStudents[i][  'parentPhone'] != null &&
                                        calculateUnpaidMonths(selectedStudents[i][  'studyDays'],selectedStudents[i][  'payments']).isNotEmpty
 ) {
                             if (await Permission  .sms.isGranted && selectedStudents[i]  ['parentPhone'] .toString() .isNotEmpty) {
                               List months = calculateUnpaidMonths(selectedStudents[i][  'studyDays'],selectedStudents[i][  'payments']);

                               _smsService.sendSMS(
                                   selectedStudents[i]['parentPhone'],
                                   "\nHurmatli ota ona ,\nFarzandingiz ${selectedStudents[i]['name'].toString().capitalizeFirst!} ${selectedStudents[i]['surname'].toString().capitalizeFirst!.removeAllWhitespace

                                   }ning " "${ translateMonthYearList(months ).join(',')} ${months.length >1 ?'oylari' :'oyi'} uchun oylik to'lovi kechikkanini ma'lum qilamiz.");

                               _smsService.sendSMS(
                                   selectedStudents[i]['parentPhone'],
                                   "\nIltimos, qarzni imkon qadar tezroq to'lang.\nHurmat bilan AKHMEDOV SCHOOL");


                                                  }
                                                }
                                              }

                                              messageLoader2.value = false;
                                              selectedStudents.clear();
                                              isStudentChoosen.value = false;

                                              Get.snackbar(
                                                'Message', // Title
                                                'Your message has been sent',
                                                // Message
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                // Position of the snackbar
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                                borderRadius: 8,
                                                margin: EdgeInsets.all(10),
                                              );
                                            },
                                            child: Text(
                                              'Confirm'.tr.capitalizeFirst!,
                                              style: appBarStyle.copyWith(
                                                  color: Colors.green),
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: Get.back,
                                              child: Text(
                                                'Cancel',
                                                style: appBarStyle.copyWith(
                                                    color: Colors.red),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Obx(() => Container(
                            margin: EdgeInsets.only(left: 4),
                            child: CustomButton(
                              color: Colors.red,
                              text: messageLoader2.value
                                  ? "Sending..."
                                  : 'Payment',
                            ),
                          )),
                    )


              )
                  : SizedBox(),
              box.read('isLogged') == '0094'
                  ? Expanded(
                      child: InkWell(
                      onTap: () async {
                        if (selectedStudents.isEmpty) {
                          Get.snackbar(
                            'Error', // Title
                            'Students are not selected', // Message
                            snackPosition: SnackPosition.TOP,
                            // Position of the snackbar
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            borderRadius: 8,
                            margin: EdgeInsets.all(10),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                insetPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                //this right here
                                child: Form(
                                  key: _formKey,
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    width: Get.width,
                                    height: Get.height / 2.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 16,
                                            ),
                                            TextFormField(
                                              maxLines: 5,
                                              controller: customMessage,
                                              maxLength: 80,
                                              keyboardType: TextInputType.text,
                                              decoration: buildInputDecoratione(
                                                  'Your message here'
                                                          .tr
                                                          .capitalizeFirst! ??
                                                      ''),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            messageLoader3.value = true;
                                            if (customMessage.text.isNotEmpty) {
                                              for (int i = 0;
                                                  i < selectedStudents.length;
                                                  i++) {
                                                if (await Permission
                                                        .sms.isGranted &&
                                                    selectedStudents[i]['parentPhone']
                                                        .toString()
                                                        .isNotEmpty) {
                                                  _smsService.sendSMS(
                                                      selectedStudents[i]
                                                          ['parentPhone'],
                                                      customMessage.text +
                                                          "\nHurmat bilan AKHMEDOV SCHOOL");
                                                }

                                                await Future.delayed(
                                                    Duration(seconds: 1));
                                              }
                                              messageLoader3.value = false;
                                              customMessage.clear();
                                              selectedStudents.clear();
                                              isStudentChoosen.value = false;

                                              Get.back();

                                              Get.snackbar(
                                                'Message', // Title
                                                'Your message has been sent',
                                                // Message
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                // Position of the snackbar
                                                backgroundColor: Colors.blue,
                                                colorText: Colors.white,
                                                borderRadius: 8,
                                                margin: EdgeInsets.all(10),
                                              );
                                            } else {
                                              Get.back();
                                            }
                                          },
                                          child: Obx(() => CustomButton(
                                              isLoading: studentController
                                                  .isLoading.value,
                                              text: messageLoader3.value
                                                  ? "Sending. . ."
                                                  : "Send"
                                                      .tr
                                                      .capitalizeFirst!)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 4),
                        child: CustomButton(
                          color: Colors.blue,
                          text: 'Custom',
                        ),
                      ),
                    ))
                  : SizedBox(),
            ],
          ),
        ),
      ):SizedBox(),
    );
  }
}
