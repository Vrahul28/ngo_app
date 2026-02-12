import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomPopupMenu<T> extends PopupMenuItem<T> {
  CustomPopupMenu({
    super.key,
    required T value,
    required IconData icon,
    required String title,
    Color? color,
  }) : super(
    value: value,
    height: 42,
    child: Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: color ?? Colors.black,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
