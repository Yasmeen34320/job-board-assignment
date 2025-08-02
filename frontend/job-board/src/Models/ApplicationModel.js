export class ApplicationModel {
  constructor({
    id,
    jobId,
    userId,
    resumePath,
    coverLetter,
    status = 'pending',
    createdAt,
  }) {
    this.id = id;
    this.jobId = jobId;
    this.userId = userId;
    this.resumePath = resumePath;
    this.coverLetter = coverLetter;
    this.status = status;
    this.createdAt = createdAt || new Date().toISOString();
  }
}