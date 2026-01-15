import 'package:akhmedov_school/screens/admin/admins/edit_admin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AdminCard extends StatelessWidget {
  final String name;
  final String surname;
  final String passcode;
  final String documentId;
  final attendance;
  final editPayment;
  final editStudent;
   final dltStudent;
  final cnEdtGr;
  final cnDltGr;

  const AdminCard({
    super.key,
    required this.name,
    required this.surname,
    required this.passcode,
    required this.documentId,
    required this.attendance,
    required this.editPayment,
    required this.editStudent,
     required this.dltStudent,
    required this.cnEdtGr,
    required this.cnDltGr,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2C2C2E)
              : const Color(0xFFE5E5EA),
          width: 0.6,
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF2C2C2E)
                : const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.admin_panel_settings_outlined,
            color: Color(0xFF007AFF), // iOS blue
            size: 24,
          ),
        ),
        title: Text(
          "$name $surname",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle:   Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            passcode,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8E8E93),
            ),
          ),
        ),
        trailing:  GestureDetector(
          onTap: () {
            Get.to(() => EditAdmin(
              documentId: documentId,
              name: name,
              surname: surname,
              passcode: passcode,
              attendance: attendance,
              editPayment: editPayment,
              editStudent: editStudent,
               dltStudent: dltStudent,
              cnEdtGr: cnEdtGr,
              cnDltGr: cnDltGr,
            ));
          },



          child: Icon(
            Icons.edit,
            size: 22,
            color: Color(0xFFAEAEB2),
          ),
        ),
      ),
    );
  }
}
