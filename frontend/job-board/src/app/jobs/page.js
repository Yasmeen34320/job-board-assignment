"use client";
import { useEffect, useState } from "react";
import {
  getJobsFromLocalStorage,
  addJobToLocalStorage,
} from "@/utils/jobsUtils";
import { getCurrentUser } from "@/utils/getCurrentUser";
import { useRouter } from "next/navigation";

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
  });

  const user = getCurrentUser();

  useEffect(() => {
    setJobs(getJobsFromLocalStorage());
  }, []);

  const handleAddJob = () => {
    const newJob = {
      ...formData,
      id: Date.now(),
      postedAt: new Date().toISOString().split("T")[0],
      status: "open",
    };
    addJobToLocalStorage(newJob);
    setJobs([...jobs, newJob]);
    setFormData({
      title: "",
      company: "",
      location: "",
      salary: "",
      imageUrl: "",
      description: "",
      type: "",
    });
    setIsModalOpen(false);
  };
const router = useRouter();
  return (
    <div className="p-4 max-w-5xl mx-auto bg-gray-100">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">All Jobs</h1>
        {user?.role === "admin" && (
          <button
            onClick={() => setIsModalOpen(true)}
            className="bg-blue-700 hover:bg-blue-800 text-white px-4 py-2 rounded-md"
          >
            + Add Job
          </button>
        )}
      </div>

      <div className="space-y-4">
        {jobs.map((job) => (
          <div
          onClick={()=>router.push(`/jobs/${job.id}`)}
            key={job.id}
            className="bg-white rounded-lg p-4 shadow-xl flex gap-4 items-center "
          >
            <img
              src={job.imageUrl || "https://via.placeholder.com/50"}
              alt={job.title}
              className="w-15 h-15 rounded-md object-cover"
            />
            <div className="flex-1 text-left ml-2">
              <h2 className="text-base font-semibold">{job.title}</h2>
              <p className="text-blue-600 text-sm tracking-normal">{job.company}</p>
              <p className="text-gray-500 text-sm">{job.location}</p>
              <p className="text-green-600 text-sm">{job.salary} / {job.type}</p>
              <p className="text-xs text-gray-400 mt-1">Posted: {job.postedAt}</p>
            </div>
            <div className="text-right">
                {/* //bg-yellow-100 text-yellow-800 */}
              <span className={`inline-flex items-center px-2 py-1 text-xs font-medium rounded-full
                    ${job.status === 'open' ? 'bg-green-200 text-green-800' : 'bg-red-200 text-red-800'}

                `}>
                {job.status}
              </span>
            </div>
          </div>
        ))}
      </div>

      {/* Modal Dialog */}
      {isModalOpen && (
        <div className="fixed inset-0 tracking-[.1em] flex shadow-xl justify-center items-center z-50"
        // style={{boxShadow:}}
        >
          <div className="bg-gray-50 p-6 rounded-lg w-full max-w-md shadow-xl relative">
            <button
              onClick={() => setIsModalOpen(false)}
              className="absolute top-2 right-3 text-gray-600 text-xl"
            >
              ×
            </button>
            <h2 className="text-lg font-semibold mb-4">Add New Job</h2>
            <div className="space-y-3">
              {[
                { key: "title", placeholder: "Job Title" },
                { key: "company", placeholder: "Company" },
                { key: "location", placeholder: "Location" },
                { key: "salary", placeholder: "Salary" },
                { key: "type", placeholder: "Job Type (Full-time, Part-time...)" },
                { key: "imageUrl", placeholder: "Image URL" },
              ].map(({ key, placeholder }) => (
                <input
                  key={key}
                  type="text"
                  placeholder={placeholder}
                  value={formData[key]}
                  onChange={(e) =>
                    setFormData({ ...formData, [key]: e.target.value })
                  }
                  className="w-full shadow-2xl bg-white rounded-lg px-3 py-2 text-sm"
                />
              ))}

              <textarea
                placeholder="Job Description"
                value={formData.description}
                onChange={(e) =>
                  setFormData({ ...formData, description: e.target.value })
                }
                className="w-full bg-white shadow-2xl rounded px-3 py-2 text-sm"
              />

              <button
                onClick={handleAddJob}
                className="w-full bg-blue-600 hover:bg-blue-700 text-white py-2 rounded-md"
              >
                Add Job
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
