import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 35,

          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade500),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: DropdownButton<String>(
              value: value,
              underline: const SizedBox(),
              isDense: true,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
                letterSpacing: 2,
              ),
              items: items.map((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
