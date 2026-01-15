import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
 import '../../../constants/custom_widgets/DisabledButton.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../constants/utils.dart';
import '../../../controllers/admin/teachers_controller.dart';
import '../../../controllers/students/student_controller.dart';
import '../../../controllers/teacher_controller/teacher_controller.dart';

class TeachersHours extends StatelessWidget {

  final String name;
  final String docId;
   TeachersHours({required this.name, required this.docId});
   TeacherController teacherController = Get.put(TeacherController());
   TeachersController teachersController = Get.put(TeachersController());


   DateTime _selectedDate = DateTime.now();
   RxString selectedDate = '${DateFormat('MMMM, y').format(DateTime.now())}'.obs;

  void setNextMonth() {
       _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);

       selectedDate.value =DateFormat('MMMM, y').format(_selectedDate);
   }

  void setPreviousMonth() {
       _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
       selectedDate.value =DateFormat('MMMM, y').format(_selectedDate);

   }

   RxList classes = [].obs;
   RxList LateClasses = [].obs;
  StudentController studentController = Get.put(StudentController());

  RxString _selectedGroupId ="".obs;
  RxString _selectedGroupName ="".obs;



  RxBool isLate = false.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePagebg,
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
          padding: const EdgeInsets.all(1.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('AkhmedovTeachers')
                  .doc(docId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  var documentData =  snapshot.data!.data() as Map<String, dynamic>;
                  List data = documentData['items']['classHours'] ?? [];
                  classes.clear();
                  LateClasses.clear();
                  for(var item in data){
                    if(DateFormat('MMMM, y').format(_selectedDate).toString() ==convertDateToMonthYear((item['Date'])).toString()){
                      classes.add(item);
                      if(item['isLate']){
                        LateClasses.add(item);
                      }
                    }
                  }
                  

                  
                  
                  
                   return
                       Obx(()=>  SingleChildScrollView(
                         child: Column(children: [
                           Obx(()=>

                               Row(
                                 children: [
                                   SizedBox(width: 16,),
                                   Container(child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                   IconButton(onPressed: (){
                                     setPreviousMonth();
                                     classes.clear();
                                     LateClasses.clear();
                                     for(var item in data){
                                       if(DateFormat('MMMM, y').format(_selectedDate).toString() ==convertDateToMonthYear((item['Date'])).toString()){
                                         classes.add(item);
                                         if(item['isLate']){
                                           LateClasses.add(item);
                                         }
                                       }
                                     }
                                   }, icon: Icon(Icons.arrow_back_ios)),
                                   Text("${selectedDate.value}"),
                                   IconButton(onPressed: (){
                                     setNextMonth();
                                     classes.clear();
                                     LateClasses.clear();
                                     for(var item in data){
                                       if(DateFormat('MMMM, y').format(_selectedDate).toString() ==convertDateToMonthYear((item['Date'])).toString()){
                                         classes.add(item);
                                         if(item['isLate']){
                                           LateClasses.add(item);
                                         }
                                       }
                                     }


                                   }, icon: Icon(Icons.arrow_forward_ios_rounded))
                                                                ],),),
                                   Container(
                                     padding: EdgeInsets.all(16),
                                     margin: EdgeInsets.all(4),
                                     decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(12),
                                     
                                   ),
                                   child: Row(children: [
                                     Container(

                                       
                                       child: Text("${classes.length - LateClasses.length}",style: TextStyle(
                                         
                                         color: Colors.white
                                       ),),
                                     padding: EdgeInsets.all(4),
                                     alignment: Alignment.center,
                                     width: 32,
                                     height: 32,
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(21),
                                       color: Colors.green,
                                     ),
                                     ),
                                     SizedBox(width: 16,),
                                     Container(


                                       child: Text("${LateClasses.length}",style: TextStyle(

                                           color: Colors.white
                                       ),),
                                       padding: EdgeInsets.all(4),
                                       alignment: Alignment.center,
                                       width: 32,
                                       height: 32,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(21),
                                         color: Colors.red,
                                       ),
                                     ),
                                     
                                   ],),
                                   )
                                 ],
                               ),
                           ),
                           for(var item in classes)
                             classHour(isPaid: item['isPaid'], date: item['Date'], docId: docId,uniqueId: item['id'], teacherController: teacherController, isLate: item['isLate'], group: item['groupName'],),

                         ],),
                       )
                       );
                }
                // If no data available

                else {
                  return Text('No data'); // No data available
                }
              })),










      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () async {

              teachersController.teacherGroupsEdit.clear();
              teachersController. teacherGroupIdsEdit.clear();
              _selectedGroupName.value="";
              _selectedGroupId.value ="";
              isLate.value  =false
              ;
             await studentController.fetchGroups();
              Get.bottomSheet(
                  backgroundColor: Colors.transparent,
                  isDismissible: true,
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height:4,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                )
                              ],),
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
                                          _selectedGroupId.value = studentController.AkhmedovGroups[i]['group_id'];
                                          _selectedGroupName.value = studentController.AkhmedovGroups[i]['group_name'];



                                        },
                                        child: Container(
                                          padding: EdgeInsets
                                              .symmetric(
                                              horizontal: 18,
                                              vertical: 8),
                                          margin:
                                          EdgeInsets.all(8),
                                          decoration:  _selectedGroupId.value != studentController.AkhmedovGroups[i]['group_id']
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
                                                color:  _selectedGroupId.value != studentController.AkhmedovGroups[i]['group_id']
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
                            Text('Addtinional cases:'),
                            Obx(()=>    Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Late'),
                                IconButton(onPressed: (){
                                  isLate.value = !isLate.value;
                                }, icon: isLate.value ? Icon(Icons.check_box,color: Colors.green,): Icon(Icons.check_box_outline_blank))
                              ],))







                          ],
                        ),
                        Column(
                          children: [
                            Obx(()=>     _selectedGroupId.value.isNotEmpty ?         GestureDetector(
                              onTap: () {
                                teacherController.addTeacherClassHour(docId,_selectedGroupId.value,_selectedGroupName.value,isLate.value);
                              Get.back();





                              },
                              child: CustomButton(
                                  isLoading:false,
                                  text: 'confirm'.tr.capitalizeFirst!),
                            ):DisabledButton(text: 'Confirm'),),

                            SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: CustomButton(
                                  text: 'Cancel'.tr.capitalizeFirst!,
                                  color: Colors.red,
                                ))
                          ],
                        )
                      ],
                    ),
                  ));
            },
            child: CustomButton(text: "Qo'shish")),
      ),
    );
    
  }
}

class classHour extends StatelessWidget {
  final bool isPaid;
  final bool isLate;
  final String date;
  final String docId;
  final String group;
  final String uniqueId;
  final TeacherController teacherController;

  const classHour({required this.isPaid, required this.date, required this.docId, required this.uniqueId, required this.teacherController, required this.isLate, required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: isLate ? Colors.red:Colors.white,width: 2),
        borderRadius: BorderRadius.circular(12),
      color: Colors.white
    ),
    child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text("O'tildi"),
        Text("2 soat",style: appBarStyle.copyWith(fontSize: 12),),
      ],),
      SizedBox(height: 8,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Sana"),
          Text("$date".toString(),style: appBarStyle.copyWith(fontSize: 12,color: Colors.green),),
        ],),
      SizedBox(height: 8,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("To'lov"),
          Text(isPaid ? "To'langan ":"To'lanmagan",style: appBarStyle.copyWith(fontSize: 12,color: isPaid ? Colors.green :Colors.red),),
        ],),
       SizedBox(height: 8,),
    isLate ?  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Kechikish"),
          Text("Mavjud",style: appBarStyle.copyWith(fontSize: 12,color:Colors.red),),
        ],):SizedBox(),
      SizedBox(height: 8,),
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Guruh"),
          Text(group,style: appBarStyle.copyWith(fontSize: 12,color: Colors.black),),
        ],),
      SizedBox(height: 8,),

      InkWell(
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete Item"),
                content: Text("Are you sure you want to delete this item?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      // Perform the delete action here
                      
                       teacherController.deleteClassHours(docId, uniqueId);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        },

          child: CustomButton(text: 'Bekor qilish',color: Colors.red,))
    ],),
    );
  }
}
