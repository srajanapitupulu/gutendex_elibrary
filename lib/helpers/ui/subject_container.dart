import 'package:flutter/material.dart';

class SubjectsList extends StatelessWidget {
  final List<String> subjects;

  const SubjectsList({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2.0,
      runSpacing: 2.0,
      children: subjects.map((subject) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              subject,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
