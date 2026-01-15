import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoAccessAttendanceButton extends StatelessWidget {
  const NoAccessAttendanceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      borderRadius: BorderRadius.circular(10),
      color: Colors.red, // colorful
      onPressed: () {
        // Show a snackbar for no access
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(CupertinoIcons.lock_slash, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  "No Access",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(CupertinoIcons.lock_slash, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            "No Access",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
