import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../controllers/admin/create_admin_controller.dart';

class EditAdmin extends StatelessWidget {
  EditAdmin({
    super.key,
    required this.documentId,
    required this.name,
    required this.surname,
    required this.passcode,
    required this.attendance,
    required this.editPayment,
    required this.editStudent,
     required this.dltStudent,
    required this.cnEdtGr,
    required this.cnDltGr,
  });

  final String documentId;
  final String name;
  final String surname;
  final String passcode;
  final attendance;
  final editPayment;
  final editStudent;
   final dltStudent;
  final cnEdtGr;
  final cnDltGr;

  final CreateAdminController controller =  Get.put(CreateAdminController());

  @override
  Widget build(BuildContext context) {
    /// set values ONCE
    controller.setValues(name, surname, passcode,attendance,editStudent,editStudent,dltStudent,cnEdtGr,cnDltGr);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF3A7BD5),
        title: const Text("Edit Admin"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            // BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _field("Admin name", controller.nameCtrlEdit),
                      const SizedBox(height: 12),
                      _field("Admin surname", controller.surnameCtrlEdit),
                      const SizedBox(height: 18),
                      _field("Admin passcode", controller.passcodeEdit),
                      const SizedBox(height: 18),

                      const Text(
                        "Permissions",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      _toggle("Attendance", controller.attendanceEdit),
                      _toggle("Edit payment", controller.canEditPaymentEdit),
                      _toggle("Edit student", controller.canEditStudentEdit),
                      _toggle("Delete student", controller.canDeleteStudentEdit),
                      _toggle("Edit group", controller.canEditGroupEdit),
                      _toggle("Remove group", controller.canRemoveGroupEdit),
                    ],
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
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.editAdmin(documentId);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        backgroundColor: const Color(0xFF3A7BD5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ helpers ------------------

  Widget _field(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          decoration: buildInputDecoratione(label),
          validator: (v) =>
          v!.trim().isEmpty ? "Required field" : null,
        ),
      ],
    );
  }

  Widget _toggle(String title, RxBool value) {
    return Obx(
          () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14)),
            ),
            CupertinoSwitch(
              value: value.value,
              onChanged: (v) => value.value = v,
            ),
          ],
        ),
      ),
    );
  }
}
