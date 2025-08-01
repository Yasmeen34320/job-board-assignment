import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_board/features/job_applications/data/models/application_model.dart';

class ContainerComponent extends StatelessWidget {
  List<ApplicationModel> applications;
  Color backgroundColor;
  Icon icon;
  String status;
  ContainerComponent({
    super.key,
    required this.applications,
    required this.backgroundColor,
    required this.icon,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: backgroundColor, // Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: icon,
                // Icon(Icons.mail, size: 30, color: Colors.blue),
              ),
            ),
            SizedBox(height: 5),
            Text(
              status, // 'Total',
              style: GoogleFonts.poppins(
                letterSpacing: 2,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              status == 'Total'
                  ? '${applications.length}'
                  : '${applications.where((app) => app.status == status).length}',
              style: GoogleFonts.poppins(
                letterSpacing: 2,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
