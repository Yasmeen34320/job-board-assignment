"use client"

import Image from "next/image";
import Link from "next/link";
import { RiUserAddLine } from "react-icons/ri";
import { CiSearch } from "react-icons/ci";
import { RiSendPlaneLine } from "react-icons/ri";
import { mockUsers } from '@/data/mockUsers';
import { useEffect, useState } from "react";
import { useAuth } from "@/context/AuthContext";
import { getJobsFromLocalStorage } from "@/utils/jobsUtils";
import { clearUsers } from "@/utils/getCurrentUser";


export default function Home() {
  const howItWorks=[
    {
      id:"1",
      icon:<RiUserAddLine className="text-blue-700" />,
      title:'Create Profile',
      desc:"Sign up and create your professional profile with your skills, experience, and preferences."
    },
     {
      id:"2",
      icon:<CiSearch className="text-blue-700"/>,
      title:'Browse Jobs',
      desc:"Search and filter through thousands of job opportunities that match your criteria."
    },
     {
      id:"3",
      icon:<RiSendPlaneLine className="text-blue-700"/>,
      title:'Apply & Connect',
      desc:"Submit applications with your resume and connect directly with hiring managers."
    },
  ]

const [mockJobs,setJobs]=useState([]);
const [stats, setStats] = useState({
  openJobs: 0,
  companies: 0,
  jobSeekers: 0,
});
// On first load:
useEffect(() => {
  // clearUsers()
const stored = JSON.parse(localStorage.getItem('users') || '[]');
  if (!stored) {
    localStorage.setItem('users', JSON.stringify(mockUsers));
  }
  const jobs = getJobsFromLocalStorage();

  const openJobs = jobs.filter(job => job.status === "open").length;
  const companies = new Set(jobs.map(job => job.company)).size;
  const jobSeekers = stored.filter(user => user.role === "jobseeker").length;

  setJobs(jobs.slice(0, 3));
  setStats({
    openJobs,
    companies,
    jobSeekers,
  });
}, []);

  const { isLoggedIn } = useAuth();
return (
  <>
    {/* Hero Section */}
    <section
      className="min-h-[80vh] bg-cover bg-center flex items-center justify-center text-center px-4"
      style={{ backgroundImage: "url('/2.jpg')" }}
    >
      <div className="p-6 sm:p-8 rounded-lg shadow-lg tracking-wider max-w-xl">
        <h1 className="text-3xl sm:text-4xl text-white font-bold mb-4">Find Your Dream Job</h1>
        <p className="text-white mb-6 font-semibold text-sm sm:text-base">
          Connect with top employers and advance your career with our comprehensive job platform
        </p>
        <div className="flex flex-col sm:flex-row justify-center gap-4">
          <Link href={isLoggedIn ? '/' : '/signup'}>
            <button className="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 w-full sm:w-auto">
              Get Started
            </button>
          </Link>
          <Link href="/jobs">
            <button className="text-white bg-gray-400 px-6 py-2 rounded hover:bg-blue-500 hover:text-white w-full sm:w-auto">
              Browse Jobs
            </button>
          </Link>
        </div>
      </div>
    </section>

    {/* Stats Section */}
    <div className="bg-white flex flex-col sm:flex-row items-center justify-around tracking-wider p-6 sm:p-8 gap-8">
      <div className="flex flex-col gap-2 items-center">
        <h3 className="text-blue-800 text-3xl font-semibold">{stats.openJobs}+</h3>
        <p>Active Jobs</p>
      </div>
      <div className="flex flex-col gap-2 items-center">
        <h3 className="text-blue-800 text-3xl font-semibold">{stats.jobSeekers}+</h3>
        <p>Job Seekers</p>
      </div>
      <div className="flex flex-col gap-2 items-center">
        <h3 className="text-blue-800 text-3xl font-semibold">{stats.companies}+</h3>
        <p>Companies</p>
      </div>
    </div>

    {/* Featured Jobs Section */}
    <div className="bg-gray-100 py-10 px-4 tracking-wider">
      <h3 className="font-semibold text-2xl text-center">Featured Opportunities</h3>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mt-10 mb-10">
        {mockJobs.map((element) => (
          <div key={element.id} className="bg-white p-4 rounded-2xl">
            <div className="flex justify-between items-start">
              <img
                src={`${element.imageUrl}`}
                alt={element.title}
                className="w-12 h-12 object-cover rounded-lg"
              />
              <div
                className={`h-7 px-3 rounded-2xl flex items-center text-xs font-medium
                  ${element.type === 'Full-time' && 'bg-green-200 text-green-800'}
                  ${element.type === 'Remote' && 'bg-blue-200 text-blue-800'}
                  ${element.type === 'Part-time' && 'bg-yellow-200 text-yellow-800'}
                  ${element.type === 'Contract' && 'bg-purple-200 text-purple-800'}
                `}
              >
                {element.type}
              </div>
            </div>
            <div className="mt-4 text-left">
              <h2 className="font-semibold text-base">{element.title}</h2>
              <p className="text-sm mt-2 text-gray-500">{element.company}</p>
              <p className="text-xs mt-1 text-gray-400">{element.location}</p>
              <p className="text-sm mt-1 text-green-600">{element.salary}</p>
              <div className="flex justify-between items-center mt-4">
                <Link
                  href={`/jobs/${element.id}`}
                  className="bg-blue-700 text-white px-4 py-1 rounded-lg text-sm"
                >
                  View Details
                </Link>
                <div
                  className={`text-xs px-3 py-1 rounded-full font-medium
                    ${element.status === 'open'
                      ? 'bg-gray-100 text-green-700'
                      : 'bg-gray-100 text-red-600'}
                  `}
                >
                  {element.status}
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="text-center">
        <Link href="/jobs">
          <button className="bg-blue-700 text-white px-6 py-2 rounded-lg text-sm">
            View All Jobs
          </button>
        </Link>
      </div>
    </div>

    {/* How It Works Section */}
    <div className="bg-white px-4 py-10 tracking-wider">
      <h3 className="font-semibold text-2xl text-center mb-10">How It Works</h3>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-10 max-w-5xl mx-auto">
        {howItWorks.map((step) => (
          <div key={step.id} className="flex flex-col items-center text-center gap-4">
            <div className="bg-blue-100 p-3 w-12 h-12 flex items-center justify-center rounded-full">
              {step.icon}
            </div>
            <p className="font-semibold">{`${step.id}. ${step.title}`}</p>
            <p className="text-sm text-gray-600">{step.desc}</p>
          </div>
        ))}
      </div>
    </div>
  </>
);

}
