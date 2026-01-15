
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

class Teachers extends StatefulWidget {
  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  final _formKey = GlobalKey<FormState>();

  TeachersController teachersController = Get.put(TeachersController());
  StudentController studentController = Get.put(StudentController());

  String _searchText = '';

  RxList scores = [

    "6.5",
    "7",
    "7.5",
    "8",
    "8.5",
    "9",
    "B2",
    "C1",
    "C2",
    "No certificate",

  ].obs;
  RxList experience = [

    "without experience",
    "less than 6 month",
    "6 month + ",
    "1 year",
    "2 year",
    "3 year",
    "4 year",
    "5 year",
    "5 year + ",
    "10 year + ",


  ].obs;

  bool shouldImproveScore(String ?  score){
      if(score == '6.5' || score == 'No certificate' || score == '7' || score == '7.5' || score == null){
        return true ;
      }
      return false;
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe8e8e8),
        appBar: AppBar(
          backgroundColor: dashBoardColor,
          toolbarHeight: 64,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: TextButton.icon(
                style: ButtonStyle(

                ),
                  onPressed: () {
                    studentController.fetchGroups();
                    teachersController.teacherGroups.clear();
                    teachersController.teacherGroupIds.clear();
                    teachersController.TeacherSurname.clear();
                    teachersController.TeacherName.clear();
                    teachersController.teacherExperience.value='';
                    teachersController.teacherScore.value='';

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          insetPadding: EdgeInsets.symmetric(horizontal: 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          //this right here
                          child: Form(
                            key: _formKey,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              width: Get.width,
                              height: Get.height  ,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  SizedBox(),
                                                  Text(
                                                    "Add Teacher",
                                                    style: appBarStyle.copyWith(
                                                        fontSize: 14),
                                                  ),
                                                  IconButton(
                                                      onPressed: Get.back,
                                                      icon: Icon(
                                                        Icons.close,
                                                        color:
                                                        CupertinoColors.black,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        TextFormField(
                                            controller:
                                            teachersController.TeacherName,
                                            keyboardType: TextInputType.text,
                                            decoration: buildInputDecoratione(
                                                'Teacher name'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Maydonlar bo'sh bo'lmasligi kerak";
                                              }
                                              return null;
                                            }),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        TextFormField(
                                            controller:
                                            teachersController.TeacherSurname,
                                            keyboardType: TextInputType.text,
                                            decoration: buildInputDecoratione(
                                                'Teacher surname'),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Maydonlar bo'sh bo'lmasligi kerak";
                                              }
                                              return null;
                                            }),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Append group(s)',
                                            style:
                                            appBarStyle.copyWith(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.grey),
                                          ),
                                        ),
                                        Obx(() => Container(
                                           alignment: Alignment.topLeft,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                for (int i = 0;
                                                i <
                                                    studentController
                                                        .AkhmedovGroups
                                                        .length;
                                                i++)
                                                  GestureDetector(
                                                    onTap: () {
                                
                                                      if (teachersController.teacherGroupIds.contains(studentController.AkhmedovGroups[i]['group_id'])) {
                                                        teachersController .teacherGroupIds.remove(studentController.AkhmedovGroups[i]['group_id']);
                                                        teachersController.teacherGroups.removeWhere((el)=> el['group_id']== studentController.AkhmedovGroups[i]['group_id']);
                                                        print('Teacher groups ${ teachersController.teacherGroups}');
                                                      } else {
                                                        teachersController.teacherGroups.add(studentController.AkhmedovGroups[i]);
                                                        teachersController.teacherGroupIds.add(studentController.AkhmedovGroups[i]['group_id']);
                                                        print('Teacher groups ${ teachersController.teacherGroups}');
                                
                                                      }
                                
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 18,
                                                          vertical: 8),
                                                      margin:
                                                      EdgeInsets.all(2),
                                                      decoration: !teachersController
                                                          .teacherGroupIds
                                                          .contains(studentController
                                                          .AkhmedovGroups[i][
                                                      'group_id'])
                                                          ? BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              112),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black,
                                                              width: 1))
                                                          : BoxDecoration(
                                                          color: Colors
                                                              .green,
                                                          borderRadius:
                                                          BorderRadius.circular(112),
                                                          border: Border.all(color: Colors.green, width: 1)),
                                                      child: Text(
                                                        "${studentController.AkhmedovGroups[i]['group_name']}",
                                                        style: TextStyle(
                                                            color: !teachersController
                                                                .teacherGroupIds
                                                                .contains(
                                                                studentController.AkhmedovGroups[i]
                                                                [
                                                                'group_id'])
                                                                ? Colors.black
                                                                : CupertinoColors
                                                                .white),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Teacher personal score',
                                            style:
                                            appBarStyle.copyWith(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.grey),
                                          ),
                                        ),
                                
                                        Obx(()=>Container(child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(children: [
                                            for(int i = 0 ; i < scores.length ; i++)
                                              GestureDetector(
                                                onTap: (){
                                                  teachersController.teacherScore.value = scores[i];
                                
                                                },
                                                child: Container(
                                
                                                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                                  decoration: BoxDecoration(
                                                      color:    teachersController.teacherScore.value == scores[i] ? Colors.green:Colors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                          color:    teachersController.teacherScore.value == scores[i] ? Colors.white:Colors.black
                                                      )
                                                  ),
                                                  child: Text(scores[i],style: TextStyle(
                                                      color:    teachersController.teacherScore.value == scores[i] ? Colors.white:Colors.black
                                                  ),),
                                                ),
                                              )
                                
                                          ],),),)),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Teacher personal experience',
                                            style:
                                            appBarStyle.copyWith(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.grey),
                                          ),
                                        ),
                                
                                        Obx(()=>Container(child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(children: [
                                            for(int i = 0 ; i < experience.length ; i++)
                                              GestureDetector(
                                                onTap: (){
                                                  teachersController.teacherExperience.value = experience[i];
                                
                                                },
                                                child: Container(
                                
                                                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                                  decoration: BoxDecoration(
                                                      color:    teachersController.teacherExperience.value == experience[i] ? Colors.green:Colors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                          color:    teachersController.teacherExperience.value == experience[i] ? Colors.white:Colors.black
                                                      )
                                                  ),
                                                  child: Text(experience[i],style: TextStyle(
                                                      color:    teachersController.teacherExperience.value == experience[i] ? Colors.white:Colors.black
                                                  ),),
                                                ),
                                              )
                                
                                          ],),),)),
                                      ],
                                    ),
                                    SizedBox(height: Get.height/3.3,),
                                    InkWell(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          teachersController.addNewTeacher();
                                        }
                                      },
                                      child: Obx(() => CustomButton(
                                          isLoading:
                                          teachersController.isLoading.value,
                                          text: "Add")),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add,color: Colors.white,),

                  label: Text("Add Teacher",style: TextStyle(color: Colors.white),)),
            ),
            //Admin qo'shish



          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all( 0),
            child: Column(
              children: [
                // TextField(
                //   decoration: buildInputDecoratione('Search teachers'),
                //   onChanged: (value) {
                //     setState(() {
                //       _searchText = value.toLowerCase();
                //     });
                //   },
                // ),
                // SizedBox(height: 8,),
                StreamBuilder(
                    stream: _searchText.isEmpty
                        ? FirebaseFirestore.instance
                        .collection('AkhmedovTeachers')
                        .snapshots()
                        : FirebaseFirestore.instance
                        .collection('AkhmedovTeachers')
                        .where('items.name',
                        isGreaterThanOrEqualTo: _searchText)
                        .where('items.name',
                        isLessThanOrEqualTo: _searchText + '\uf8ff')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.hasData) {
                        var teachers = snapshot.data!.docs;

                        return teachers.length != 0
                            ? Column(
                          children: [
                            for (int i = 0; i < teachers.length; i++)
                              InkWell(
                                onTap: () {
                                  Get.to(Teacherinfo(
                                    documentId: teachers[i].id,
                                  ));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(.4),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(

                                      color: CupertinoColors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            alignment: Alignment.center,
                                            decoration: shouldImproveScore(teachers[i]['items']['score'])  == false ?

                                            BoxDecoration(
                                              borderRadius: BorderRadius.circular(122),
                                              gradient: LinearGradient(
                                                colors: [Colors.greenAccent, Colors.green],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),

                                            ):BoxDecoration(
                                              border: Border.all(
                                                width: 2.2,
                                                color:   Colors.red
                                              ),
                                               borderRadius: BorderRadius.circular(122),
                                              gradient: LinearGradient(
                                                colors: [Colors.greenAccent, Colors.green],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: Text("${teachers[i]['items']['score'] == "No certificate" || teachers[i]['items']['score'] == null ? "*":teachers[i]['items']['score']}",
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                            teachers[i]['items']['name']
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            teachers[i]['items']
                                            ['surname']
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          SizedBox(width: 4,),

                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 16,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                teachersController.teacherGroupsEdit.clear();
                                                teachersController. teacherGroupIdsEdit.clear();
                                                studentController.fetchGroups();
                                                teachersController.teacherExperience.value='';
                                                teachersController.teacherScore.value='';

                                                teachersController.teacherExperience.value= '';
                                                teachersController.teacherScore.value= '';


                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                  context) {
                                                    teachersController
                                                        .setValues(
                                                        teachers[i][
                                                        'items']
                                                        ['name'],
                                                        teachers[i]
                                                        [
                                                        'items']
                                                        [
                                                        'surname']);
                                                    teachersController.teacherGroupIdsEdit.addAll(teachers[i]['items'] ['groupIds']);
                                                    teachersController.teacherGroupsEdit.addAll(teachers[i]['items'] ['groups']);

                                                    teachersController.teacherExperience.value=teachers[i]['items'] ['experience'] ??'';
                                                    teachersController.teacherScore.value=teachers[i]['items'] ['score']??'';

                                                    return Dialog(
                                                      backgroundColor:
                                                      Colors.white,
                                                      insetPadding:
                                                      EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                          0),

                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                             0)),
                                                      //this right here
                                                      child: Form(
                                                        key: _formKey,
                                                        child: Container(
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                              16),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white,
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  12)),
                                                          width:
                                                          Get.width,
                                                          height:
                                                          Get.height ,
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        SizedBox(),
                                                                        Text(
                                                                          "Edit",
                                                                          style: appBarStyle,
                                                                        ),
                                                                        IconButton(onPressed: Get.back, icon: Icon(Icons.clear))
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                      16,
                                                                    ),
                                                                    TextFormField(
                                                                        decoration:
                                                                        buildInputDecoratione(''),
                                                                        controller: teachersController.TeacherNameEdit,
                                                                        keyboardType: TextInputType.text,
                                                                        validator: (value) {
                                                                          if (value!.isEmpty) {
                                                                            return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                          }
                                                                          return null;
                                                                        }),
                                                                    SizedBox(
                                                                      height:
                                                                      16,
                                                                    ),
                                                                    TextFormField(
                                                                        decoration:
                                                                        buildInputDecoratione(''),
                                                                        controller: teachersController.TeacherSurnameEdit,
                                                                        keyboardType: TextInputType.text,
                                                                        validator: (value) {
                                                                          if (value!.isEmpty) {
                                                                            return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                          }
                                                                          return null;
                                                                        }),
                                                                    SizedBox(
                                                                      height:
                                                                      16,
                                                                    ),
                                                                    Text(
                                                                      'Edit Group(s)',
                                                                      style:
                                                                      appBarStyle.copyWith(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.grey),
                                                                    ),
                                                                    Obx(() =>
                                                                    studentController.loadGroups.value == false ?    Container(
                                                                       alignment: Alignment.topLeft,
                                                                      child: SingleChildScrollView(
                                                                        scrollDirection: Axis.horizontal,
                                                                        child: Row(
                                                                          children: [
                                                                            for (int i = 0; i < studentController.AkhmedovGroups.length; i++)
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  if (teachersController.teacherGroupIdsEdit.contains(studentController.AkhmedovGroups[i]['group_id'])) {
                                                                                    teachersController.teacherGroupIdsEdit.remove(studentController.AkhmedovGroups[i]['group_id']);
                                                                                    teachersController.teacherGroupsEdit.removeWhere((el)=> el['group_id'] == studentController.AkhmedovGroups[i]['group_id']);
                                                                                    print("Edited groups ${teachersController.teacherGroupsEdit}");

                                                                                  } else {
                                                                                    teachersController.teacherGroupIdsEdit.add(studentController.AkhmedovGroups[i]['group_id']);
                                                                                    teachersController.teacherGroupsEdit.add(studentController.AkhmedovGroups[i]);
                                                                                    print("Edited groups ${teachersController.teacherGroupsEdit}");

                                                                                  }

                                                                                },
                                                                                child: Container(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                                                                  margin: EdgeInsets.all(8),
                                                                                  decoration: !teachersController.teacherGroupIdsEdit.contains(studentController.AkhmedovGroups[i]['group_id']) ? BoxDecoration(borderRadius: BorderRadius.circular(112), border: Border.all(color: Colors.black, width: 1)) : BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(112), border: Border.all(color: Colors.green, width: 1)),
                                                                                  child: Text(
                                                                                    "${studentController.AkhmedovGroups[i]['group_name']}",
                                                                                    style: TextStyle(color: !teachersController.teacherGroupIdsEdit.contains(studentController.AkhmedovGroups[i]['group_id']) ? Colors.black : CupertinoColors.white),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ) : Container(

                                                                        padding: EdgeInsets.all(16),
                                                                        alignment: Alignment.center,
                                                                        child: Text("Loading groups . ")) ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        'Teacher personal score',
                                                                        style:
                                                                        appBarStyle.copyWith(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.grey),
                                                                      ),
                                                                    ),

                                                                    Obx(()=>Container(child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Row(children: [
                                                                        for(int i = 0 ; i < scores.length ; i++)
                                                                          GestureDetector(
                                                                            onTap: (){
                                                                              teachersController.teacherScore.value = scores[i];

                                                                            },
                                                                            child: Container(

                                                                              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                                                              decoration: BoxDecoration(
                                                                                  color:    teachersController.teacherScore.value == scores[i] ? Colors.green:Colors.white,
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                  border: Border.all(
                                                                                      color:    teachersController.teacherScore.value == scores[i] ? Colors.white:Colors.black
                                                                                  )
                                                                              ),
                                                                              child: Text(scores[i],style: TextStyle(
                                                                                  color:    teachersController.teacherScore.value == scores[i] ? Colors.white:Colors.black
                                                                              ),),
                                                                            ),
                                                                          )

                                                                      ],),),)),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        'Teacher personal experience',
                                                                        style:
                                                                        appBarStyle.copyWith(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.grey),
                                                                      ),
                                                                    ),

                                                                    Obx(()=>Container(child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Row(children: [
                                                                        for(int i = 0 ; i < experience.length ; i++)
                                                                          GestureDetector(
                                                                            onTap: (){
                                                                              teachersController.teacherExperience.value = experience[i];

                                                                            },
                                                                            child: Container(

                                                                              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                                                              decoration: BoxDecoration(
                                                                                  color:    teachersController.teacherExperience.value == experience[i] ? Colors.green:Colors.white,
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                  border: Border.all(
                                                                                      color:    teachersController.teacherExperience.value == experience[i] ? Colors.white:Colors.black
                                                                                  )
                                                                              ),
                                                                              child: Text(experience[i],style: TextStyle(
                                                                                  color:    teachersController.teacherExperience.value == experience[i] ? Colors.white:Colors.black
                                                                              ),),
                                                                            ),
                                                                          )

                                                                      ],),),)),







                                                                  ],
                                                                ),
                                                                SizedBox(height: Get.height/3.3,),
                                                                InkWell(
                                                                  onTap:
                                                                      ()   {

                                                                    if (_formKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      teachersController.editTeacher(teachers[i]
                                                                          .id
                                                                          .toString());
                                                                    }
                                                                  },
                                                                  child: Obx(() => CustomButton(
                                                                      isLoading: teachersController
                                                                          .isLoading
                                                                          .value,
                                                                      text:
                                                                      "Edit")),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                  context) {
                                                    return CustomAlertDialog(
                                                      title:
                                                      "Delete Teacher",
                                                      description:
                                                      "Are you sure you want to delete this teacher ?",
                                                      onConfirm:
                                                          () async {
                                                        // Perform delete action here
                                                        teachersController
                                                            .deleteTeacher(
                                                            teachers[
                                                            i]
                                                                .id);
                                                      },
                                                      img:
                                                      'assets/delete.png',
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],
                        )
                            : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/empty.png',
                                width: 222,
                              ),
                              Text(
                                'Our center has not any teachers ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 33),
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
