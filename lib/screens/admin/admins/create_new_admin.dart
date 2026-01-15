import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../controllers/admin/create_admin_controller.dart';

class CreateNewAdmin extends StatelessWidget {
  final controller = Get.put(CreateAdminController());

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _openDialog(),
      icon: Icon(Icons.admin_panel_settings, color: Colors.white),
      label: Text("Add Admin", style: TextStyle(color: Colors.white)),
    );
  }

  void _openDialog() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -4),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Drag Handle
              Container(
                height: 5,
                width: 60,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              // HEADER
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings, color: Colors.white),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Add Admin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: Colors.white),
                    )
                  ],
                ),
              ),

              SizedBox(height: 10),

              // BODY
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _field("Admin name", controller.nameCtrl),
                          SizedBox(height: 12),
                          _field("Admin surname", controller.surnameCtrl),
                          SizedBox(height: 18),
                          _field("Admin passcode", controller.passcode),
                          SizedBox(height: 18),

                          Text("Permissions",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),

                          _toggle("Attendance", controller.attendance),
                          _toggle("Edit payment", controller.canEditPayment),
                          _toggle("Edit student", controller.canEditStudent),
                          _toggle("Delete student", controller.canDeleteStudent),
                          _toggle("Edit group", controller.canEditGroup),
                          _toggle("Remove group", controller.canRemoveGroup),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // FOOTER BUTTONS
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: Get.back,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.addNewAdmin,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Color(0xFF3A7BD5),
                        ),
                        child: Text("Add",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // SHEET OPTIONS
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }


  Widget _field(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          decoration: buildInputDecoratione(label),
          validator: (v) => v!.trim().isEmpty ? "Required field" : null,
        )
      ],
    );
  }

  Widget _toggle(String title, RxBool value) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(fontSize: 14))),
          CupertinoSwitch(
            value: value.value,
            onChanged: (v) => value.value = v,
          )
        ],
      ),
    ));
  }
}
