import 'dart:io';
import 'package:hive/hive.dart';

part 'application_model.g.dart';

@HiveType(typeId: 2)
class ApplicationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String jobId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String resumePath; // Local PDF file path

  @HiveField(4)
  final String coverLetter;

  @HiveField(5)
  final String status; // submitted, reviewed, accepted, rejected

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.resumePath,
    required this.coverLetter,
    this.status = 'submitted',
  });
}
