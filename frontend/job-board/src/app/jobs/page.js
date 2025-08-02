"use client";
import { useEffect, useState } from "react";
import {
  getJobsFromLocalStorage,
  addJobToLocalStorage,
  clearJobs,
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
    createdBy:"",
    requirements:""
  });
 

  
const exampleJobs = [
  {
    id: "1690101010101",
    title: "Frontend Developer",
    company: "TechCorp",
    location: "Cairo, Egypt",
    salary: "15,000 EGP/month",
    imageUrl: "https://i.pinimg.com/1200x/6c/dc/64/6cdc649e7b1ba49359d9e1484b841038.jpg",
    description: "We are looking for a skilled React developer to join our frontend team.",
    type: "Full-time",
    createdBy: "admin123",
    postedAt: "2025-08-01",
    status: "open",
    requirements: [
      "Must have experience with React and TypeScript.",
      "Proficiency in using Git for version control.",
      "Ability to consume and integrate REST APIs.",
      "Good understanding of responsive design and browser compatibility."
    ]
  },
  {
    id: "1690102020202",
    title: "Backend Developer",
    company: "CodeWorks",
    location: "Remote",
    salary: "$3000/month",
    imageUrl: "https://i.pinimg.com/1200x/85/f2/56/85f256a4ff66cc32bb0175eb43e1dc04.jpg",
    description: "Responsible for developing scalable backend services with Node.js.",
    type: "Full-time",
    createdBy: "admin456",
    postedAt: "2025-08-02",
    status: "open",
    requirements: [
      "Strong experience with Node.js and Express framework.",
      "Familiarity with MongoDB and Mongoose.",
      "Understanding of authentication methods like JWT.",
      "Experience with building RESTful APIs and error handling."
    ]
  },
  {
    id: "1690103030303",
    title: "UI/UX Designer",
    company: "DesignHub",
    location: "Alexandria, Egypt",
    salary: "12,000 EGP/month",
    imageUrl: "https://i.pinimg.com/736x/b5/6d/02/b56d02619bdd5a3ef333e5cc4259d165.jpg",
    description: "Create stunning user interfaces and seamless user experiences.",
    type: "Part-time",
    createdBy: "admin789",
    postedAt: "2025-07-30",
    status: "closed",
    requirements: [
      "Proficient in design tools like Figma and Adobe XD.",
      "Strong understanding of user-centered design principles.",
      "Ability to create wireframes, prototypes, and user flows.",
      "Conduct user research and usability testing."
    ]
  }
];
const {user}=useAuth()
const [appliedJobIds, setAppliedJobIds] = useState([]);

useEffect(() => {
  // const currentUser = getCurrentUser();
  // setUser(currentUser);
    const apps = JSON.parse(localStorage.getItem("applications")) || [];
  const userApps = apps.filter(app => app.userId === user.id); // make sure user.id exists
  const ids = userApps.map(app => String(app.jobId));
  setAppliedJobIds(ids);
    setJobs(getJobsFromLocalStorage());
    // setJobs(exampleJobs);
    // exampleJobs.forEach((job)=>addJobToLocalStorage(job))
  }, [user?.id]);
  const handleAddJob = () => {
    const newJob = {
      ...formData,
      id: Date.now(),
      postedAt: new Date().toISOString().split("T")[0],
      status: "open",
      createdBy:user.fullName,
       requirements: formData.requirements
      .split(',')
      .map((req) => req.trim())
      .filter((req) => req !== ""), 
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
      requirements:"",
      createdBy:""
    });
    setIsModalOpen(false);
  };
const router = useRouter();
  return (
    <div className="w-full bg-gray-100">
    <div className="p-4 max-w-5xl mx-auto">
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
            {appliedJobIds.includes(String(job.id)) && (
  <p className="text-sm text-yellow-600 font-semibold mt-2">✓ Already Applied</p>
)}
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
                  { key: "requirements", placeholder: "Requirements (comma-separated)" }, // NEW FIELD
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
    </div>
  );
}
