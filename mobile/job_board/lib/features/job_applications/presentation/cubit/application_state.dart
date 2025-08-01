import 'package:job_board/features/job_applications/data/models/application_model.dart';

abstract class ApplicationState {}

class ApplicationInitial extends ApplicationState {}

class ApplicationSubmitting extends ApplicationState {}

class ApplicationSubmitted extends ApplicationState {}

class ApplicationsLoading extends ApplicationState {}

class ApplicationsLoaded extends ApplicationState {
  final List<ApplicationModel> applications;

  ApplicationsLoaded(this.applications);
}

class ApplicationError extends ApplicationState {
  final String message;

  ApplicationError(this.message);
}
