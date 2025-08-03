"use client";
import { useEffect, useState } from "react";
import {
  getJobsFromLocalStorage,
  addJobToLocalStorage,
  clearJobs,
  updateJobStatus,
} from "@/utils/jobsUtils";
import { getCurrentUser } from "@/utils/getCurrentUser";
import { useRouter } from "next/navigation";
import { useAuth } from "@/context/AuthContext";

export default function JobsPage() {
  const [jobs, setJobs] = useState([]);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [formData, setFormData] = useState({
    title: "",
    company: "",
    location: "",
    salary: "",
    imageUrl: "",
    description: "",
    type: "",
    createdBy: "",
    requirements: "",
  });
  const { user } = useAuth();
  const [appliedJobIds, setAppliedJobIds] = useState([]);
  const [selectedJobId, setSelectedJobId] = useState(null);
  const [errors, setErrors] = useState({
    title: "",
    company: "",
    location: "",
    salary: "",
    imageUrl: "",
    description: "",
    type: "",
    requirements: "",
  });

  useEffect(() => {
    const apps = JSON.parse(localStorage.getItem("applications")) || [];
    const userApps = apps.filter((app) => app.userId === user?.id);
    const ids = userApps.map((app) => String(app.jobId));
    setAppliedJobIds(ids);
    setJobs(getJobsFromLocalStorage());
  }, [user?.id]);

  const isValidImageUrl = (url) => /\.(jpg|jpeg|png|webp)$/i.test(url.trim());

  const handleAddOrUpdateJob = () => {
    const newErrors = {
      title: formData.title.trim() ? "" : "Title is required",
      company: formData.company.trim() ? "" : "Company is required",
      location: formData.location.trim() ? "" : "Location is required",
      salary: formData.salary.trim() ? "" : "Salary is required",
      imageUrl: !formData.imageUrl.trim()
        ? "Image URL is required"
        : !isValidImageUrl(formData.imageUrl)
        ? "Must end with .jpg, .jpeg, .png, or .webp"
        : "",
      description: formData.description.trim() ? "" : "Description is required",
      type: formData.type.trim() ? "" : "Job type is required",
      requirements: formData.requirements.trim() ? "" : "Requirements are required",
    };

    setErrors(newErrors);

    const hasErrors = Object.values(newErrors).some((e) => e !== "");
    if (hasErrors) return;

    const updatedJob = {
      ...formData,
      requirements: formData.requirements
        .split(",")
        .map((req) => req.trim())
        .filter((req) => req !== ""),
    };

    if (selectedJobId) {
      const updatedJobs = jobs.map((job) =>
        job.id === selectedJobId ? { ...job, ...updatedJob } : job
      );
      setJobs(updatedJobs);
      localStorage.setItem("jobs", JSON.stringify(updatedJobs));
    } else {
      const newJob = {
        ...updatedJob,
        id: Date.now(),
        postedAt: new Date().toISOString().split("T")[0],
        status: "open",
        createdBy: user?.fullName,
      };
      addJobToLocalStorage(newJob);
      setJobs([...jobs, newJob]);
    }

    setFormData({
      title: "",
      company: "",
      location: "",
      salary: "",
      imageUrl: "",
      description: "",
      type: "",
      requirements: "",
      createdBy: "",
    });
    setIsModalOpen(false);
    setSelectedJobId(null);
  };

  const handleStatusChange = (id, newStatus) => {
    const updatedJobs = jobs.map((job) =>
      job.id === id ? { ...job, status: newStatus } : job
    );
    setJobs(updatedJobs);
    updateJobStatus(id, newStatus);
  };

  const router = useRouter();

  return (
    <div className="w-full bg-gray-100 min-h-screen">
      <div className="p-4 sm:p-6 md:p-8 max-w-5xl mx-auto">
        <div className="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
          <h1 className="text-xl sm:text-2xl font-bold">All Jobs</h1>
          {user?.role === "admin" && (
            <button
              onClick={() => setIsModalOpen(true)}
              className="bg-blue-700 hover:bg-blue-800 text-white px-4 py-2 rounded-md text-sm sm:text-base"
            >
              + Add Job
            </button>
          )}
        </div>

        <div className="space-y-4">
          {jobs.map((job) => (
            <div
              onClick={() => router.push(`/jobs/${job.id}`)}
              key={job.id}
              className="bg-white rounded-lg p-4 shadow-xl flex flex-col sm:flex-row gap-4 items-start sm:items-center cursor-pointer"
            >
              <img
                src={job.imageUrl || "https://via.placeholder.com/50"}
                alt={job.title}
                className="w-12 h-12 sm:w-15 sm:h-15 rounded-md object-cover"
              />
              <div className="flex-1 text-left">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center">
                  <h2 className="text-sm sm:text-base font-semibold">{job.title}</h2>
                  {user?.role === "admin" && (
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        setSelectedJobId(job.id);
                        setFormData({
                          ...job,
                          requirements: (job.requirements || []).join(", "),
                        });
                        setIsModalOpen(true);
                      }}
                      className="text-xs sm:text-sm mt-2 sm:mt-0 cursor-pointer text-blue-700 underline"
                    >
                      Edit
                    </button>
                  )}
                </div>
                <p className="text-blue-600 text-xs sm:text-sm tracking-normal">{job.company}</p>
                <p className="text-gray-500 text-xs sm:text-sm">{job.location}</p>
                <p className="text-green-600 text-xs sm:text-sm">{job.salary}, {job.type}</p>
                <p className="text-xs text-gray-400 mt-1">Posted: {job.postedAt}</p>
                {appliedJobIds.includes(String(job.id)) && (
                  <p className="text-xs sm:text-sm text-yellow-600 font-semibold mt-2">
                    ✓ Already Applied
                  </p>
                )}
              </div>
              <div className="text-right self-end sm:self-center">
                {user?.role === "admin" ? (
                  <select
                    value={job.status || "open"}
                    onClick={(e) => e.stopPropagation()}
                    onChange={(e) => {
                      e.stopPropagation();
                      handleStatusChange(job.id, e.target.value);
                    }}
                    className="text-xs sm:text-sm p-1 rounded-md border"
                  >
                    <option value="open">Open</option>
                    <option value="closed">Closed</option>
                  </select>
                ) : (
                  <span
                    className={`inline-flex items-center px-2 py-1 text-xs sm:text-sm font-medium rounded-full ${
                      job.status === "open" ? "bg-green-200 text-green-800" : "bg-red-200 text-red-800"
                    }`}
                  >
                    {job.status}
                  </span>
                )}
              </div>
            </div>
          ))}
        </div>

        {/* Modal Dialog */}
        {isModalOpen && (
          <div className="fixed inset-0 flex justify-center items-center z-50 bg-black bg-opacity-50">
            <div className="bg-gray-50 p-4 sm:p-6 rounded-lg w-full max-w-md sm:max-w-lg shadow-xl relative">
              <button
                onClick={() => setIsModalOpen(false)}
                className="absolute top-2 right-3 text-gray-600 text-lg sm:text-xl"
              >
                ×
              </button>
              <h2 className="text-lg sm:text-xl font-semibold mb-4">
                {selectedJobId ? "Edit Job" : "Add New Job"}
              </h2>
              <div className="space-y-3">
                {[
                  { key: "title", placeholder: "Job Title" },
                  { key: "company", placeholder: "Company" },
                  { key: "location", placeholder: "Location" },
                  { key: "salary", placeholder: "Salary" },
                  { key: "type", placeholder: "Job Type (Full-time, Part-time...)" },
                  { key: "imageUrl", placeholder: "Image URL" },
                  { key: "requirements", placeholder: "Requirements (comma-separated)" },
                ].map(({ key, placeholder }) => (
                  <div key={key}>
                    <input
                      type="text"
                      placeholder={placeholder}
                      value={formData[key]}
                      onChange={(e) =>
                        setFormData({ ...formData, [key]: e.target.value })
                      }
                      className="w-full bg-white rounded-lg px-3 py-2 text-xs sm:text-sm shadow-md"
                    />
                    {errors[key] && (
                      <p className="text-red-500 text-xs mt-1">{errors[key]}</p>
                    )}
                  </div>
                ))}
                <textarea
                  placeholder="Job Description"
                  value={formData.description}
                  onChange={(e) =>
                    setFormData({ ...formData, description: e.target.value })
                  }
                  className="w-full bg-white rounded-lg px-3 py-2 text-xs sm:text-sm shadow-md min-h-[100px]"
                />
                <button
                  onClick={handleAddOrUpdateJob}
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 rounded-md text-sm sm:text-base"
                >
                  {selectedJobId ? "Update Job" : "Add Job"}
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}