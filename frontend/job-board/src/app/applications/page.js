"use client";
import React, { useEffect, useState } from 'react';
import { clearApplications, deleteApplicationById, getApplicationsFromLocalStorage, updateApplicationStatus } from '@/utils/applicationUtils';
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
  const [showCoverLetter, setShowCoverLetter] = useState({});
  const { user } = useAuth();
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  const handleDeleteApplication = (id) => {
    const confirmed = window.confirm("Are you sure you want to withdraw this application?");
    if (confirmed) {
      deleteApplicationById(id);
      const updated = applications.filter(app => app.id !== id);
      setApplications(updated);
    }
  };

  const handleStatusChange = (id, newStatus) => {
    const updatedApps = applications.map(app => app.id === id ? { ...app, status: newStatus } : app);
    setApplications(updatedApps);
    updateApplicationStatus(id, newStatus);
  };

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

  const getFilteredApplications = () => {
    const users = getUsers();
    return applications.filter(app => {
      const userDetails = users.find(u => u.id === app.userId);
      if (!userDetails) return false;

      const matchesSearch = userDetails.fullName.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesStatus = statusFilter === 'all' || app.status === statusFilter;

      return matchesSearch && matchesStatus;
    });
  };

  const filteredApps = getFilteredApplications();

  const toggleCoverLetter = (appId) => setShowCoverLetter(prev => ({ ...prev, [appId]: !prev[appId] }));

  var count = 0;

  return (
    <div className="p-6 max-w-4xl mx-auto bg-gray-50 min-h-screen">
      <h1 className="text-3xl font-bold text-gray-900 mb-6 border-b-2 border-blue-200 pb-3">
        {user?.role == 'admin' ? 'All ' : 'My '}Applications
      </h1>
      {user?.role === 'admin' && (
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
          <input
            type="text"
            placeholder="Search by full name"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="p-2 border border-gray-300 rounded-md w-full sm:w-1/2 text-sm sm:text-base"
          />
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="p-2 border border-gray-300 rounded-md w-full sm:w-1/4 text-sm sm:text-base"
          >
            <option value="all">All Statuses</option>
            <option value="pending">Pending</option>
            <option value="accepted">Accepted</option>
            <option value="rejected">Rejected</option>
          </select>
        </div>
      )}

      {filteredApps.length === 0 ? (
        <p className="text-gray-500 text-lg text-center">
          {user?.role == 'admin' ? 'There is no applications yet' : 'You haven’t submitted any applications yet.'}
        </p>
      ) : (
        <div className="grid gap-6 max-w-4xl">
          {filteredApps.map((app) => {
            const job = getJobDetails(app.jobId);
            const users = getUsers();
            const userDetails = users.find((u) => u.id === app.userId);
            console.log(users);
            console.log(userDetails);
            console.log(app.userId);
            if (!userDetails) return null;
            count++;
            return (
              <div key={job.id} className="bg-white rounded-lg mt-4 p-4 shadow-xl">
                <div className="flex flex-col sm:flex-row gap-4">
                  <img
                    src={job?.imageUrl || "https://via.placeholder.com/50"}
                    alt={job?.title}
                    className="w-15 h-15 rounded-md object-cover mt-2 sm:mt-0"
                  />
                  <div className="flex-1 text-left ml-2">
                    <h2 className="text-base font-semibold">{job?.title}</h2>
                    <p className="text-blue-600 text-sm tracking-normal">{job?.company}</p>
                    <div className="text-gray-500 text-sm flex flex-col sm:flex-row gap-2 sm:gap-4 items-start sm:items-center">
                      <p className="flex gap-2 items-center">
                        <IoLocationOutline />
                        {job?.location}
                      </p>
                      <p className="text-gray-500 text-sm flex gap-2 items-center">
                        <MdOutlineWork />
                        {job?.type}
                      </p>
                      <p className="text-green-600 text-sm flex gap-2 items-center">
                        <RiMoneyDollarCircleLine />
                        {job?.salary}
                      </p>
                    </div>
                    <p className="text-xs text-gray-400 mt-1 flex gap-2 items-center">
                      <IoMdTime className="text-sm" />
                      <span className="text-xs text-gray-500">
                        Submitted: {new Date(app.createdAt).toLocaleDateString()}
                      </span>
                      {user?.role == 'admin' ? (
                        <>
                          by <span className="text-blue-800 font-semibold">{userDetails?.fullName}</span>
                        </>
                      ) : (
                        <></>
                      )}
                    </p>
                  </div>
                  <div className="text-right self-end sm:self-center">
                    {user?.role === 'admin' ? (
                      <select
                        value={app.status || 'pending'}
                        onChange={(e) => handleStatusChange(app.id, e.target.value)}
                        className="text-sm p-1 rounded-md border"
                      >
                        <option value="pending">Pending</option>
                        <option value="accepted">Accepted</option>
                        <option value="rejected">Rejected</option>
                      </select>
                    ) : (
                      <span
                        className={`text-xs px-2 py-1 rounded-full font-medium ${
                          app.status == 'pending'
                            ? 'bg-yellow-100 text-yellow-700'
                            : app.status == 'accepted'
                            ? 'bg-green-100 text-green-800'
                            : 'bg-red-100 text-red-800'
                        }`}
                      >
                        {app.status}
                      </span>
                    )}
                  </div>
                </div>
                <div className="mt-2 flex flex-col">
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-2">
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
                      </button>
                    )}
                    {!app.resumeData && <p>No resume file uploaded</p>}
                    <button
                      onClick={() => handleDeleteApplication(app.id)}
                      className="bg-red-500 hover:bg-red-600 text-white text-xs rounded-xl px-4 p-2"
                    >
                      Withdraw Application
                    </button>
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
            );
          })}
          {count == 0 && (
            <p className="text-gray-500 text-lg text-center">
              {user?.role == 'admin' ? 'There is no applications yet' : 'You haven’t submitted any applications yet.'}
            </p>
          )}
        </div>
      )}
    </div>
  );
}