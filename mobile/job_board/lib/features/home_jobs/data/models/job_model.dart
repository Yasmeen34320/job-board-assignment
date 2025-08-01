import 'package:hive/hive.dart';

part 'job_model.g.dart';

@HiveType(typeId: 1)
class Job extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title; //

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String location; //

  @HiveField(4)
  final double salary;

  @HiveField(5)
  final String status; // 'open' or 'closed'

  @HiveField(6)
  final String createdBy;

  @HiveField(7)
  final String imageUrl; //

  @HiveField(8)
  final String companyName; //

  @HiveField(9)
  final List<String> requirements; // List of user IDs who applied for the job

  @HiveField(10)
  final DateTime createdAt; // Timestamp of job creation
  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.status,
    required this.createdBy,
    required this.imageUrl,
    required this.companyName,
    required this.requirements,
    required this.createdAt,
  });
}
