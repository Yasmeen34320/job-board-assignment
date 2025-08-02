"use client"
import React, { useState, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { getAboutFromLocalStorage, saveAboutToLocalStorage } from '@/utils/aboutUtils';
import Link from 'next/link';
import { useAuth } from '@/context/AuthContext';
import { getCurrentUser, setCurrentUser } from '@/utils/getCurrentUser';

export default function AboutPage() {
  const { role } = useParams(); // 'jobseeker' or 'admin'
  const router = useRouter();
  const [isEditing, setIsEditing] = useState(false);
  const [aboutContent, setAboutContent] = useState({
    title: 'About Us',
    description: 'Welcome to our job platform! We connect talented individuals with exciting career opportunities. Our mission is to empower job seekers and support companies in finding the right talent. Founded in 2023, we have grown to serve thousands of users worldwide.',
  });
  const {isLoggedIn , user} = useAuth(); // Simulated login status
  // hconst [user, setUser] = useState(null);

useEffect(() => {

    const savedAbout = getAboutFromLocalStorage();
    if (savedAbout) {
      setAboutContent(savedAbout);
    }
  }, []);

  const handleSave = () => {
    saveAboutToLocalStorage(aboutContent);
    setIsEditing(false);
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setAboutContent((prev) => ({ ...prev, [name]: value }));
  };

  return (
    <div className="w-full bg-gray-100 min-h-screen p-6">
      <div className="max-w-4xl mx-auto bg-white rounded-lg shadow-lg p-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-8 border-b-2 border-gray-200 pb-4">About Us</h1>
        {role === 'admin' && (
          <div className="mb-6">
            <button
              onClick={() => setIsEditing(!isEditing)}
              className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 mr-3"
            >
              {isEditing ? 'Cancel' : 'Edit'}
            </button>
            {isEditing && (
              <button
                onClick={handleSave}
                className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700"
              >
                Save
              </button>
            )}
          </div>
        )}

        {isEditing ? (
          <div className="space-y-6">
            <div>
              <label className="block text-sm font-medium text-gray-700">Title</label>
              <input
                type="text"
                name="title"
                value={aboutContent.title}
                onChange={handleChange}
                className="mt-1 block w-full border-gray-300 rounded-md shadow-sm p-3 focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700">Description</label>
              <textarea
                name="description"
                value={aboutContent.description}
                onChange={handleChange}
                className="mt-1 block w-full border-gray-300 rounded-md shadow-sm p-3 h-40 focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>
        ) : (
          <div className="text-gray-700 space-y-6">
            <h2 className="text-2xl font-semibold">{aboutContent.title}</h2>
            <p className="text-lg leading-relaxed">{aboutContent.description}</p>
          </div>
        )}

        {/* Action Section */}
        <div className="mt-10 pt-6 border-t-2 border-gray-200 mx-auto">
          <h3 className="text-xl font-semibold text-gray-900 mb-4">Take the Next Step</h3>
          {isLoggedIn ? (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 ">
              <Link href="/jobs" className="bg-blue-600 w-[80%] mx-auto text-white p-4 rounded-lg text-center hover:bg-blue-700 transition duration-300">
                Browse Jobs
              </Link>
              {/* <Link href="/applications" className="bg-green-600 text-white p-4 rounded-lg text-center hover:bg-green-700 transition duration-300">
                Go to Your Applications
              </Link> */}
              {user?.role=='admin'?<Link href="/applications" className="bg-yellow-600 w-[80%] mx-auto text-white p-4 rounded-lg text-center hover:bg-yellow-700 transition duration-300">
                Track The Applications
              </Link>:<Link href="/applications" className="bg-yellow-600 w-[80%] mx-auto text-white p-4 rounded-lg text-center hover:bg-yellow-700 transition duration-300">
                Track Your Application
              </Link>}
            </div>
          ) : (
            <div className="text-center">
              <p className="text-gray-600 mb-4">Please log in to access job opportunities and manage your applications.</p>
              <button
                onClick={() => router.push('/login')}
                className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition duration-300"
              >
                Get Started by Login
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}