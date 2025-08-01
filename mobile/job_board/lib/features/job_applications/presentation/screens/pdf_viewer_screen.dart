import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';

class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  const PDFViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    print('PDF size: ${File(filePath).lengthSync()} bytes');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resume',
          style: GoogleFonts.poppins(letterSpacing: 2, color: Colors.white),
        ),
      ),
      body: PDFView(filePath: filePath),
    );
  }
}
