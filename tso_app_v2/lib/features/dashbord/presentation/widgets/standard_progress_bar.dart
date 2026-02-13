import 'package:flutter/material.dart';
import 'package:tso_app_v2/core/theme/app_colores.dart';

class StandardProgressBar extends StatelessWidget {
  final int progress; // Expects a value between 0.0 and 1.0

  const StandardProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$progress% Completed",
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 5),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress / 100,
            minHeight: 5,
            backgroundColor: Colors.grey.shade200,
            color: kLightGreenColor,
          ),
        ),
      ],
    );
  }
}
