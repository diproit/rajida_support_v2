import 'package:flutter/material.dart';
import 'package:tso_app_v2/core/theme/app_colores.dart';
import 'package:tso_app_v2/features/dashbord/presentation/widgets/standard_progress_bar.dart';

class ClientsAndTasksCard extends StatelessWidget {
  const ClientsAndTasksCard({super.key});

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
            'Clients and tasks',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 15),

          buildTaskRow("Clients Assigned", "10"),

          const SizedBox(height: 15),

          buildTaskRow("Total Tasks", "20"),

          const SizedBox(height: 15),

          buildTaskRow("Tasks Done", "10 (50%)"),

          const SizedBox(height: 15),

          buildTaskRow("Tasks Pending", "10 (50%)"),

          const SizedBox(height: 15),

          StandardProgressBar(progress: 50),
        ],
      ),
    );
  }
}

Widget buildTaskRow(String label, String value) {
  return Row(
    children: [
      SizedBox(
        width: 200,
        child: Text(
          label,
          style: TextStyle(color: kSecondaryTextColor, fontSize: 14),
        ),
      ),

      Text(value, style: TextStyle(color: Colors.black, fontSize: 14)),
    ],
  );
}
