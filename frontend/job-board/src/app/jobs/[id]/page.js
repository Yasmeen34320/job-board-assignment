"use client"
import { useParams } from 'next/navigation';
import React, { useEffect, useState } from 'react'
import { IoLocationOutline } from "react-icons/io5";
import { RiMoneyDollarCircleLine } from "react-icons/ri";
import { MdOutlineWork } from "react-icons/md";
import { IoMdTime } from "react-icons/io";
import { FaCircleCheck } from "react-icons/fa6";

import {
  getJobsFromLocalStorage,
  addJobToLocalStorage,
} from "@/utils/jobsUtils";
import Link from 'next/link';
import { getCurrentUser } from '@/utils/getCurrentUser';
import { useAuth } from '@/context/AuthContext';
import { getApplicationsFromLocalStorage } from '@/utils/applicationUtils';
export default function page() {
      const { id } = useParams();

      const [job, setJob] = useState(null);

const {user}=useAuth()
const [alreadyApplied, setAlreadyApplied] = useState(false);

useEffect(() => {
 
         const jobs = getJobsFromLocalStorage() || [];
const selectedJob = jobs.find((job) => String(job.id) === String(id));
    //      console.log(`job ${job.id}   index ${id}`)
    //     return job.id === id;
    //   });
      setJob(selectedJob);
        const apps = getApplicationsFromLocalStorage();
  const applied = apps.some(
    (app) => app.jobId === String(id) && app.userId === user?.id
  );
  setAlreadyApplied(applied);
      },[id,user?.id]);

  return (
<>
<div className='w-full bg-gray-100 p-4'>
  <div
            className="bg-white max-w-4xl mx-auto rounded-lg mt-4  p-4 shadow-xl flex gap-4 "
          >
            <img
              src={job?.imageUrl || "https://via.placeholder.com/50"}
              alt={job?.title}
              className="w-15 h-15 rounded-md object-cover mt-2"
            />
            <div className="flex-1 text-left ml-2">
              <h2 className="text-base font-semibold">{job?.title}</h2>
              <p className="text-blue-600 text-sm tracking-normal">{job?.company}</p>
              <div className="text-gray-500 text-sm flex gap-2 items-center">
                <IoLocationOutline />

                {job?.location}
             <p className="text-gray-500 ml-4 text-sm flex gap-2 items-center">
              <MdOutlineWork />

               {job?.type}</p>

                <p className="text-green-600 ml-4 text-sm flex gap-2 items-center">
                  <RiMoneyDollarCircleLine />

                  {job?.salary} </p>

                
                </div>
              <p className="text-xs text-gray-400 mt-1 flex gap-2 items-center">
                <IoMdTime className='text-sm' />

                Posted: {job?.postedAt}</p>
            </div>
            <div className="text-right">
                {/* //bg-yellow-100 text-yellow-800 */}

              {/* <span className={`inline-flex items-center px-2 py-1 text-xs font-medium rounded-full
                    ${job?.status === 'open' ? 'bg-green-200 text-green-800' : 'bg-red-200 text-red-800'}

                `}>
                {job?.status}
              </span> */}
{/* {user?.role!='admin'?
             (
              job?.status=='open'?(
                <Link href={`/jobs/${job.id}/apply`} className='bg-blue-600 mt-2 text-white text-sm p-2 px-4 tracking-[.1em] rounded mr-2'>Apply Now</Link>
              ):(
                            <p className='bg-gray-500 mt-2 text-white p-2 px-4 tracking-[.1em] rounded mr-2'>Closed</p>

              )):(<></>)
            } */}
            {user?.role !== "admin" && (
  <>
    {job?.status !== "open" ? (
      <p className="bg-gray-500 mt-2 text-white p-2 px-4 tracking-[.1em] rounded mr-2">Closed</p>
    ) : alreadyApplied ? (
      <p className="bg-green-600 mt-2 text-white p-2 px-4 tracking-[.1em] rounded mr-2">Already Applied</p>
    ) : (
      <Link
        href={`/jobs/${job.id}/apply`}
        className="bg-blue-600 mt-2 text-white text-sm p-2 px-4 tracking-[.1em] rounded mr-2"
      >
        Apply Now
      </Link>
    )}
  </>
)}

            </div>
          </div>
{/**descreption */}
<div className='flex gap-4 mt-6 max-w-4xl mx-auto'>
  {/* /**left */}
    <div className='w-2/3'>
      <div className='bg-white p-6 rounded text-left'>
        <h3 className='font-semibold tracking-[.1em] text-xl mb-4'>Job Description</h3>
        <p className='text-sm text-zinc-700 tracking-normal'>
          {job?.description}
                    We are looking for a motivated professional who is passionate about their work and eager to contribute to a dynamic team. The ideal candidate should possess strong problem-solving skills, excellent communication abilities, and a willingness to learn and adapt in a fast-paced environment.
        </p>
       
      </div>

 <div className='bg-white p-6 rounded text-left mt-10'>
        <h3 className='font-semibold tracking-[.1em] text-xl mb-4'>Requirements</h3>
        <div className='text-zinc-700 tracking-normal'>
          {job?.requirements?.map((requirment,idx)=>(
<div className='flex gap-3 items-center mb-1' key={idx}>
            <FaCircleCheck className='text-green-600 text-sm  '/>
<p className='text-sm'>{requirment}</p>


</div>          ))} 
</div>  
      </div>
    </div>
    {/**right */}
  <div className='w-1/3'>

<div className='bg-white p-6 rounded text-left'>
   <h3 className='font-semibold tracking-[.1em] text-lg mb-4'>About {job?.company}</h3>
         <div className='text-zinc-700 text-sm tracking-normal' >
          {job?.company} is a leading technology company specializing in innovative web applications and digital solutions. Founded in 2015, we serve over 10,000 clients worldwide and are committed to creating cutting-edge technology that makes a difference.
          </div>


</div>
<div className='bg-white p-6 rounded text-left mt-10'>
   <h3 className='font-semibold tracking-[.1em] text-lg mb-4'>Quick Actions</h3>
   <div className='flex flex-col gap-4 text-center mx-auto'>
   {/* {user?.role!='admin'? (job?.status=='open'?  <Link href="/applyPage" className='bg-blue-600 mt-2 w-[80%] text-white text-sm p-2 px-4 tracking-[.1em] rounded mr-2'>Apply Now</Link>
:  <p className='bg-gray-500 mt-2 text-white p-2 px-4 w-[80%] tracking-[.1em] text-sm rounded mr-2'>Closed</p>

    ):(<></>)} */}
{user?.role !== "admin" && (
  <>
    {job?.status !== "open" ? (
      <p className=" w-[80%] bg-gray-500 mt-2 text-white p-2 px-4 tracking-[.1em] rounded mr-2">Closed</p>
    ) : alreadyApplied ? (
      <p className="w-[80%] bg-green-600 mt-2 text-white p-2 px-4 tracking-[.1em] rounded mr-2">Already Applied</p>
    ) : (
      <Link
        href={`/jobs/${job.id}/apply`}
        className="w-[80%] bg-blue-600 mt-2 text-white text-sm p-2 px-4 tracking-[.1em] rounded mr-2"
      >
        Apply Now
      </Link>
    )}
  </>
)}

  <Link href="/jobs" className='bg-yellow-600 mt-2  w-[80%] text-white text-sm p-2 px-4 tracking-[.1em] rounded mr-2'>browse other jobs</Link>
</div>
   </div>
  </div>
</div>
</div>
</>

  )
}
