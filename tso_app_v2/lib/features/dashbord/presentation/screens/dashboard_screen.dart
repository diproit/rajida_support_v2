import 'package:flutter/material.dart';
import 'package:tso_app_v2/core/presentation/widgets/header_section.dart';
import 'package:tso_app_v2/features/dashbord/presentation/widgets/clients_and_tasks_card.dart';
import 'package:tso_app_v2/features/dashbord/presentation/widgets/custom_form_textfield_with_icon.dart';
import 'package:tso_app_v2/features/dashbord/presentation/widgets/issues_card.dart';
import 'package:tso_app_v2/features/dashbord/presentation/widgets/payment_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HeaderSection(
            title: "Home",
            child: CustomFormTextfieldWithIcon(
              hintText: 'Select a Month',
              suffixIconPath: 'assets/icons/calendar_icon.png',
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 20,
              children: [
                ClientsAndTasksCard(),
                IssuesCard(),
                PaymentCard(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
