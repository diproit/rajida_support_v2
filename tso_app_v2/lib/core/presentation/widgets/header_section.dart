import 'package:flutter/material.dart';
import 'package:tso_app_v2/core/theme/app_colores.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final Widget? child;
  const HeaderSection({super.key, required this.title, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 30,
            bottom: 40,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        if (child != null)
          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: child,
            ),
          ),
      ],
    );
  }
}
