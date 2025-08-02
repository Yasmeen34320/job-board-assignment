"use client"
import { useParams } from 'next/navigation';
import React, { useEffect, useState } from 'react'
import {
  getJobsFromLocalStorage,
  addJobToLocalStorage,
} from "@/utils/jobsUtils";
export default function page() {
      const { id } = useParams();

      const [job, setJob] = useState(null);

      useEffect((
      )=>{
         const jobs = getJobsFromLocalStorage() || [];
const selectedJob = jobs.find((job) => String(job.id) === id);
    //      console.log(`job ${job.id}   index ${id}`)
    //     return job.id === id;
    //   });
      setJob(selectedJob);
      },[id]);

  return (
<>
<div>
  <div
            className="bg-white rounded-lg p-4 shadow-xl flex gap-4 items-center "
          >
            <img
              src={job?.imageUrl || "https://via.placeholder.com/50"}
              alt={job?.title}
              className="w-15 h-15 rounded-md object-cover"
            />
            <div className="flex-1 text-left ml-2">
              <h2 className="text-base font-semibold">{job?.title}</h2>
              <p className="text-blue-600 text-sm tracking-normal">{job?.company}</p>
              <p className="text-gray-500 text-sm">{job?.location}</p>
              <p className="text-green-600 text-sm">{job?.salary} / {job?.type}</p>
              <p className="text-xs text-gray-400 mt-1">Posted: {job?.postedAt}</p>
            </div>
            <div className="text-right">
                {/* //bg-yellow-100 text-yellow-800 */}
              <span className={`inline-flex items-center px-2 py-1 text-xs font-medium rounded-full
                    ${job?.status === 'open' ? 'bg-green-200 text-green-800' : 'bg-red-200 text-red-800'}

                `}>
                {job?.status}
              </span>
            </div>
          </div>

</div>
</>

  )
}
