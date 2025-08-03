export const getApplicationsFromLocalStorage = () => {
  const data = localStorage.getItem('applications');
  return data ? JSON.parse(data) : [];
};

export const saveApplicationToLocalStorage = (application) => {
  const applications = getApplicationsFromLocalStorage();
  applications.push(application);
  localStorage.setItem('applications', JSON.stringify(applications));
};

export const generateUniqueId = () => {
  return 'xxxx-xxxx-xxx-xxxx'.replace(/x/g, () => Math.floor(Math.random() * 16).toString(16));
};
export const clearApplications = () => {
  localStorage.removeItem("applications");
};

// utils/applicationsUtils.js
export function getUserApplications(userId) {
  const all = JSON.parse(localStorage.getItem("applications")) || [];
  return all.filter((app) => app.userId === userId);
}

export function hasUserApplied(jobId, userId) {
  const all = JSON.parse(localStorage.getItem("applications")) || [];
  return all.some((app) => app.jobId === jobId && app.userId === userId);
}
export const deleteApplicationById = (applicationId) => {
  const apps = JSON.parse(localStorage.getItem('applications') || '[]');
  const updated = apps.filter(app => app.id !== applicationId);
  localStorage.setItem('applications', JSON.stringify(updated));
};

export const updateApplicationStatus = (id, newStatus) => {
  const apps = JSON.parse(localStorage.getItem('applications') || '[]');
  const updatedApps = apps.map(app =>
    app.id === id ? { ...app, status: newStatus } : app
  );
  localStorage.setItem('applications', JSON.stringify(updatedApps));
};
