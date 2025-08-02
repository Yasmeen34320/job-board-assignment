"use client";
import React, { useEffect, useState } from 'react';
import { clearApplications, getApplicationsFromLocalStorage } from '@/utils/applicationUtils';
import { useAuth } from '@/context/AuthContext';
import { getCurrentUser, getUsers } from '@/utils/getCurrentUser';
import { IoLocationOutline } from "react-icons/io5";
import { RiMoneyDollarCircleLine } from "react-icons/ri";
import { MdOutlineWork } from "react-icons/md";
import { IoMdTime } from "react-icons/io";
import { FaCircleCheck } from "react-icons/fa6";
import Link from 'next/link';


export default function ApplicationsPage() {
  const [applications, setApplications] = useState([]);
  const [showResume, setShowResume] = useState({});
  const [showCoverLetter, setShowCoverLetter] = useState({});
  const { user } = useAuth();

  useEffect(() => {
    // clearApplications(); // Remove or comment out unless intentional
    const storedApps = getApplicationsFromLocalStorage();
    if (user?.role !== 'admin') {
      const userApps = storedApps.filter(app => app.userId === user?.id);
      setApplications(userApps);
    } else {
      setApplications(storedApps);
    }
  }, [user?.id, user?.role]);

  const getJobDetails = (jobId) => {
    const storedJobs = JSON.parse(localStorage.getItem('jobs') || '[]');
    return storedJobs.find(job => job.id === jobId) || { title: 'Unknown Job', company: 'Unknown Company' };
  };

  const toggleResume = (appId) => setShowResume(prev => ({ ...prev, [appId]: !prev[appId] }));
  const toggleCoverLetter = (appId) => setShowCoverLetter(prev => ({ ...prev, [appId]: !prev[appId] }));

  return (
    <div className="p-6 max-w-4xl mx-auto bg-gray-50 min-h-screen">
      <h1 className="text-3xl font-bold text-gray-900 mb-6 border-b-2 border-blue-200 pb-3">My Applications</h1>

      {applications.length === 0 ? (
        <p className="text-gray-500 text-lg">You haven’t submitted any applications yet.</p>
      ) : (
        <div className="grid gap-6 max-w-4xl">
          {applications.map((app) => {
            const job = getJobDetails(app.jobId);
            const users = getUsers();
const userDetails = users.find((u) => u.id === app.userId);
           console.log(users)
           console.log(userDetails)
           console.log(app.userId)
            return (
              <div key={job.id}             className="bg-white rounded-lg mt-4  p-4 shadow-xl  ">
              <div   

            className=" flex gap-4 "
          >
            <img
              src={job?.imageUrl || "https://via.placeholder.com/50"}
              alt={job?.title}
              className="w-15 h-15 rounded-md object-cover mt-2"
            />
            <div className="flex-1 text-left ml-2">
              {/* <div className='flex justify-between'> */}
              <h2 className="text-base font-semibold">{job?.title}</h2>
              {/* {user?.role=='admin'&&<p>{userDetails.fullName}</p>}
              </div> */}
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
<span className="text-xs text-gray-500">Submitted: {new Date(app.createdAt).toLocaleDateString()}</span>

                {/* Posted: {job?.postedAt} */}
             {user.role=='admin'?(  <> by <span className='text-blue-800 font-semibold'>{userDetails.fullName}</span></>):(<></>)}
                </p>
            </div>
                 <div className="text-right">
                {/* //bg-yellow-100 text-yellow-800 */}
              <span className={`inline-flex items-center px-2 py-1 text-xs font-medium rounded-full
                    ${app.status == 'pending' ?'bg-yellow-300 text-yellow-700': app.status=='accepted'? 'bg-green-200 text-green-800' : 'bg-red-200 text-red-800'}

                `}>
                {app.status??"pending"}
              </span>
            </div>
             
          </div>
           <div className="mt-2 flex flex-col">
            <div className='flex justify-between'>
                                {app.resumeData && (
 <button
                     onClick={() => {
    if (app.resumeData?.startsWith('data:application/pdf;base64,')) {
      const newWindow = window.open();
      if (newWindow) {
        newWindow.document.write(
          `<iframe width="100%" height="100%" src="${app.resumeData}" frameborder="0"></iframe>`
        );
        newWindow.document.title = "Resume";
      } else {
        alert("Popup blocked. Please allow popups for this site.");
      }
    } else {
      console.error("Invalid PDF data format");
    }
  }}
                    className="text-blue-600 cursor-pointer hover:text-blue-800 text-sm underline"
                  >
                  View Resume
                  </button>)}
                  {/* {showResume[app.id] && app.resumeData && (
                    <div className="p-3 bg-gray-100 rounded-md text-gray-700 text-sm">
                    <button

  className="text-blue-600 hover:text-blue-800 text-sm underline"
>
  Open Resume in New Tab
</button> */}

                      {!app.resumeData && <p>No resume file uploaded</p>}
                 {user.role!='admin'&&<Link href="" className='bg-red-400 text-white text-xs rounded-xl px-4 p-2'>WithDraw Application</Link>
} 
                 
                  {app.coverLetter && (
                    <div>
                      <button
                        onClick={() => toggleCoverLetter(app.id)}
                        className="text-blue-600 cursor-pointer hover:text-blue-800 text-sm underline"
                      >
                        {showCoverLetter[app.id] ? 'Hide Cover Letter' : 'View Cover Letter'}
                      </button>
                     
                    </div>
                    
                  )}
                  </div>
                   {showCoverLetter[app.id] && (
                        <div className="p-3 mt-4 bg-gray-100 rounded-md text-gray-700 text-sm">
                          Cover Letter: {app.coverLetter}
                        </div>
                      )}
                </div>
           </div>
//               <div
//                 key={app.id}
//                 className="bg-white p-6 rounded-lg shadow-md border border-gray-200 hover:shadow-lg transition-shadow duration-300"
//               >
//                 <div className="flex justify-between items-start mb-4">
//                   <div>
//                     <h2 className="text-xl font-semibold text-gray-800">{job.title}</h2>
//                     <p className="text-gray-600 text-sm">Company: {job.company}</p>
//                     <p className="text-gray-500 text-xs">Job ID: {app.jobId}</p>
//                   </div>
//                   <span className="text-sm text-gray-500">Submitted: {new Date(app.createdAt).toLocaleDateString()}</span>
//                 </div>
//                 <div className="space-y-4">
//                   <button
//                     onClick={() => toggleResume(app.id)}
//                     className="text-blue-600 hover:text-blue-800 text-sm underline"
//                   >
//                     {showResume[app.id] ? 'Hide Resume' : 'View Resume'}
//                   </button>
//                   {showResume[app.id] && app.resumeData && (
//                     <div className="p-3 bg-gray-100 rounded-md text-gray-700 text-sm">
//                     <button
//   onClick={() => {
//     if (app.resumeData?.startsWith('data:application/pdf;base64,')) {
//       const newWindow = window.open();
//       if (newWindow) {
//         newWindow.document.write(
//           `<iframe width="100%" height="100%" src="${app.resumeData}" frameborder="0"></iframe>`
//         );
//         newWindow.document.title = "Resume";
//       } else {
//         alert("Popup blocked. Please allow popups for this site.");
//       }
//     } else {
//       console.error("Invalid PDF data format");
//     }
//   }}
//   className="text-blue-600 hover:text-blue-800 text-sm underline"
// >
//   Open Resume in New Tab
// </button>

//                       {/* <a
//                         href={app.resumeData}
//                         target="_blank"
//                         rel="noopener noreferrer"
//                         className="text-blue-600 underline"
//                         onClick={(e) => {
//                           if (!app.resumeData.startsWith('data:application/pdf;base64,')) {
//                             e.preventDefault();
//                             console.error('Invalid PDF data format');
//                           }
//                         }}
//                       >
//                         Open Resume in New Tab
//                       </a> */}
//                       {!app.resumeData && <p>No resume file uploaded</p>}
//                     </div>
//                   )}

//                   {app.coverLetter && (
//                     <>
//                       <button
//                         onClick={() => toggleCoverLetter(app.id)}
//                         className="text-blue-600 hover:text-blue-800 text-sm underline"
//                       >
//                         {showCoverLetter[app.id] ? 'Hide Cover Letter' : 'View Cover Letter'}
//                       </button>
//                       {showCoverLetter[app.id] && (
//                         <div className="p-3 bg-gray-100 rounded-md text-gray-700 text-sm">
//                           Cover Letter: {app.coverLetter}
//                         </div>
//                       )}
//                     </>
//                   )}
//                 </div>
//                 <div className="mt-4 text-xs text-gray-500">
//                   Status: {app.status || 'Pending'}
//                 </div>
//               </div>
            );
          })}
        </div>
      )}
    </div>
  );
}