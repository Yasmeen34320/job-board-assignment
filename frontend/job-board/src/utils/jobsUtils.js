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
