// Add a new job
export const addJobToLocalStorage = (job) => {
  const existing = JSON.parse(localStorage.getItem("jobs") || "[]");
  localStorage.setItem("jobs", JSON.stringify([...existing, job]));
};

// Get all jobs
export const getJobsFromLocalStorage = () => {
  return JSON.parse(localStorage.getItem("jobs") || "[]");
};

// Clear all jobs (optional utility)
export const clearJobs = () => {
  localStorage.removeItem("jobs");
};
export const updateJobStatus = (id, newStatus) => {
  const jobs = JSON.parse(localStorage.getItem('jobs') || '[]');
  const updatedJobs = jobs.map(job =>
    job.id === id ? { ...job, status: newStatus } : job
  );
  localStorage.setItem('jobs', JSON.stringify(updatedJobs));
};