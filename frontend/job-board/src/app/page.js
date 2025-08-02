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
//    const mockJobs = [
//   {
//     id: "1",
//     title: "Frontend Developer",
//     company: "TechHive Inc.",
//     location: "Cairo, Egypt",
//     imageUrl: "https://i.pinimg.com/1200x/3c/4d/dc/3c4ddc369add7df5414171508f099c9a.jpg",
//     description: "We are looking for a skilled frontend developer with React.js experience.",
//     salary: "15,000 EGP/month",
//     type: "Full-time",
//     postedAt: "2025-07-30",
//   },
//   {
//     id: "2",
//     title: "Backend Developer",
//     company: "CodeWave",
//     location: "Remote",
//     imageUrl: "https://i.pinimg.com/1200x/db/bd/b5/dbbdb52017ffdce38af556366ae68793.jpg",
//     description: "Join our backend team working with Node.js and MongoDB.",
//     salary: "18,000 EGP/month",
//     type: "Remote",
//     postedAt: "2025-07-29",
//   },
//   {
//     id: "3",
//     title: "Mobile Developer",
//     company: "Ottopay",
//     location: "Alexandria, Egypt",
//     imageUrl: "https://i.pinimg.com/1200x/a5/9d/ac/a59dacd9d970f0e467a0bcad83e63041.jpg",
//     description: "Develop cross-platform apps using Flutter for our growing startup.",
//     salary: "12,000 EGP/month",
//     type: "Part-time",
//     postedAt: "2025-07-25",
//   },
//   // {
//   //   id: "4",
//   //   title: "UI/UX Designer",
//   //   company: "DesignPro",
//   //   location: "Giza, Egypt",
//   //   imageUrl: "/company-logos/designpro.png",
//   //   description: "Create intuitive UI designs and user experiences for web and mobile apps.",
//   //   salary: "10,000 EGP/month",
//   //   type: "Contract",
//   //   postedAt: "2025-07-20",
//   // },
//   // {
//   //   id: "5",
//   //   title: "DevOps Engineer",
//   //   company: "CloudScale",
//   //   location: "Remote",
//   //   imageUrl: "/company-logos/cloudscale.png",
//   //   description: "Automate infrastructure and CI/CD pipelines using Docker and Kubernetes.",
//   //   salary: "20,000 EGP/month",
//   //   type: "Full-time",
//   //   postedAt: "2025-07-18",
//   // }
// ];
const [mockJobs,setJobs]=useState([]);
// On first load:
useEffect(() => {
  // clearUsers()
  const stored = localStorage.getItem('users');
  if (!stored) {
    localStorage.setItem('users', JSON.stringify(mockUsers));
  }
  const jobs=getJobsFromLocalStorage().slice(0,3);
setJobs(jobs)
}, []);

  const { isLoggedIn } = useAuth();

  return (
    <>
     <section
      className="h-[90vh] bg-cover bg-center flex items-center justify-center text-center px-4"
      style={{
        backgroundImage: "url('/2.jpg')",
      }}
    >
      <div className=" p-8 rounded-lg shadow-lg tracking-[.1em]">
        <h1 className="text-4xl  text-white font-bold mb-4 ">Find Your Dream Job</h1>
        <p className=" text-white mb-6 font-semibold">
          Connect with top employers and advance your career with our comprehensive job platform
        </p>
        <div className="flex justify-center gap-4">
          <Link href={isLoggedIn ? '/' : '/signup'}>
            <button className="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700">Get Started</button>
          </Link>
          <Link href="/jobs">
            <button className=" text-white  bg-gray-400  px-6 py-2 rounded hover:bg-blue-500 hover:text-white">
              Browse Jobs
            </button>
          </Link>
        </div>
      </div>
    </section>
    {/**2 */}
      <div className="bg-white flex items-center justify-center tracking-[.1em]  p-4 gap-50 py-25">
        <div className="flex flex-col gap-4">
          <h3 className="text-blue-800 text-3xl font-semibold ">5000+</h3>
          <p>Active Jobs</p>
        </div>
        <div className="flex flex-col gap-4">
          <h3 className="text-blue-800 text-3xl font-semibold ">5000+</h3>
          <p>Job Seeker</p>
        </div>
        <div className="flex flex-col gap-4">
          <h3 className="text-blue-800 text-3xl font-semibold ">5000+</h3>
          <p>Companies</p>
        </div>
      </div>
      

      {/**3 */}
      <div className="tracking-[.2em] bg-gray-100 py-10">
        <h3 className="font-semibold text-2xl">Featured Opportunities</h3>
     
        <div className="flex gap-4 justify-center  mt-10 w-full mb-10">
          {mockJobs.map(element => (
        <div key={element.id} className="w-[30%] bg-white p-4 rounded-2xl tracking-[.1em]">
          <div className="flex justify-between">
 <img
                  src={`${element.imageUrl}`}
                  alt={element.title}
                  className="w-[20%] h-15 object-cover rounded-lg mb-4"
                />  
                {/* <div className="bg-blue-200 h-8 p-2 rounded-2xl flex items-center">
                <p className="text-blue-800 text-sm">{element.type}</p>      
                </div> */}
                <div
  className={`h-7 p-2 rounded-2xl flex items-center
    ${element.type === 'Full-time' ? 'bg-green-200 text-green-800' : ''}
    ${element.type === 'Remote' ? 'bg-blue-200 text-blue-800' : ''}
    ${element.type === 'Part-time' ? 'bg-yellow-200 text-yellow-800' : ''}
    ${element.type === 'Contract' ? 'bg-purple-200 text-purple-800' : ''}
  `}
>
  <p className="text-xs">{element.type}</p>
</div>
                  </div>
                  <div className="flex flex-col items-start tracking-[.15em]">
                  <h2 className=" font-semibold ">{element.title}</h2>
                  <p className="text-sm mt-4 font-semibold text-gray-500">{element.company}</p>
                  <p className="text-xs mt-2 font-semibold text-gray-400">{element.location}</p>
                  <p className="text-sm mt-2 font-semibold text-green-600">{element.salary}</p>
                 <div className="flex  w-full items-center justify-between">
                  <Link href={`/jobs/${element.id}`} className="bg-blue-700 text-white p-2 rounded-lg mt-4 px-4 text-sm">View Details</Link>
                  <div
  className={`h-7 p-2 rounded-2xl flex items-center tracking-[.em] mt-4
    ${element.status === 'open' ? 'bg-gray-100 text-green-800' : 'bg-gray-100 text-red-600'}
  
  `}
>
  <p className="text-xs">{element.status}</p>
</div>
                 </div>
                  </div>
        </div>

        
      ))}
        </div>
              
      <Link href="/jobs" className=" bg-blue-700 text-white p-2 rounded-lg mt-10 px-4 text-sm">View All Jobs</Link>

      </div>
      
      {/**4 */}
      <div className="bg-white tracking-[.1em]">
                <h3 className="font-semibold text-2xl py-10">How It Works</h3>
                <div className="flex gap-10 justify-center px-20">
                  
              {
                howItWorks.map(step=>(
                  <div key={step.id} className="flex flex-col gap-4 mb-20">
                    <div className="bg-blue-100 p-2 w-10 h-10 mx-auto flex items-center justify-center  rounded-full">
                      {step.icon}
                    </div>
                    <p className="font-semibold">{`${step.id}. ${step.title}`}</p>
                    <p className="text-xs text-gray-600">{step.desc}</p>
                  </div>
                ))
              }

                </div>
      </div>


    </>
    // <div className="font-sans grid grid-rows-[20px_1fr_20px] items-center justify-items-center min-h-screen p-8 pb-20 gap-16 sm:p-20">
     
       
    // </div>
  );
}
