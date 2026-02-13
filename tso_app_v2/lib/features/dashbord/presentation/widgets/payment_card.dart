import 'package:flutter/material.dart';
import 'package:tso_app_v2/core/theme/app_colores.dart';
import 'package:tso_app_v2/features/dashbord/presentation/widgets/standard_progress_bar.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issues',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 15),

          buildTaskRow("Total Service Charges Due :", "Rs. 10000000.00"),

          const SizedBox(height: 15),

          buildTaskRow("Service Charges Due for Month : ", "Rs. 10000000.00 "),

          const SizedBox(height: 15),

          buildTaskRow("Service Charges Collected : ", "Rs. 10000000.00 (80%)"),

          const SizedBox(height: 15),

          StandardProgressBar(progress: 80),
        ],
      ),
    );
  }
}

Widget buildTaskRow(String label, String value) {
  return Column(
    spacing: 5,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,

            style: TextStyle(color: kSecondaryTextColor, fontSize: 14),
          ),
        ],
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(value, style: TextStyle(color: Colors.black, fontSize: 14)),
        ],
      ),
    ],
  );
}
