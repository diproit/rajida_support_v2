import 'package:flutter/material.dart';
import 'package:tso_app_v2/core/theme/app_colores.dart';

class CustomFormTextfieldWithIcon extends StatelessWidget {
  final String? hintText;
  final String? suffixIconPath;
  const CustomFormTextfieldWithIcon({
    super.key,
    this.hintText,
    this.suffixIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: TextFormField(
        decoration: InputDecoration(
          hint: Text(
            hintText ?? '',
            style: TextStyle(
              color: kSecondaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          fillColor: Colors.white,
          filled: true,
          border: InputBorder.none,

          suffixIconConstraints: suffixIconPath != null
              ? const BoxConstraints(minWidth: 50)
              : const BoxConstraints(minHeight: 10, minWidth: 50),
          suffixIcon: suffixIconPath != null
              ? Image.asset(
                  suffixIconPath!,
                  height: 24,
                  width: 24,
                  color: kPrimaryColor,
                )
              : null,
        ),
      ),
    );
  }
}
