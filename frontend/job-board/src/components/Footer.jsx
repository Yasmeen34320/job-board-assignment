'use client'
import { useAuth } from "@/context/AuthContext";
import { FaLinkedin, FaGithub, FaFacebook } from "react-icons/fa";

export default function Footer() {
  const {user}=useAuth();
  return (
    <footer className="bg-[#0F172A] text-white py-10 px-4 md:px-20 border-t border-slate-700">
      <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
        {/* Branding */}
        <div>
          <h2 className="flex items-center text-xl font-semibold mb-2">
            <span className="bg-blue-600 p-1 rounded-full mr-2">
              <svg className="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                <path d="M2.5 5A2.5 2.5 0 015 2.5h10A2.5 2.5 0 0117.5 5v10a2.5 2.5 0 01-2.5 2.5H5A2.5 2.5 0 012.5 15V5z" />
              </svg>
            </span>
            JobSeeker
          </h2>
          <p className="text-sm text-gray-400">
            Your gateway to career success. Connect with top employers and find your dream job.
          </p>
          <div className="flex space-x-3 mt-4">
            <a href="/" className="bg-slate-800 hover:bg-slate-700 p-2 rounded-full text-white"><FaGithub /></a>
            <a href="/" className="bg-slate-800 hover:bg-slate-700 p-2 rounded-full text-white"><FaLinkedin /></a>
            <a href="/" className="bg-slate-800 hover:bg-slate-700 p-2 rounded-full text-white"><FaFacebook /></a>
          </div>
        </div>

        {/* For Job Seekers */}
        <div className="ml-10">
          <h3 className="text-white font-semibold mb-2 text-left ">For Job Seekers</h3>
          <ul className="text-gray-400 space-y-1 text-sm text-left">
            <li><a href="/jobs">Browse Jobs</a></li>
            
            <li><a href=".applications">My Applications</a></li>
          </ul>
        </div>

        {/* For Employers */}
        <div className="ml-10">
          <h3 className="text-white font-semibold mb-2 text-left">For Employers</h3>
          <ul className="text-gray-400 space-y-1 text-sm text-left">
            <li><a href="'/">Admin Dashboard</a></li>
            <li><a href="/jobs">Post Jobs</a></li>
            <li><a href="/applications">Manage Applications</a></li>
            {}<li><a href={user?.role=='admin'?'/users':'/'}>User Management</a></li>
          </ul>
        </div>

        {/* Support */}
        <div className="ml-10">
          <h3 className="text-white font-semibold mb-2 text-left">Support</h3>
          <ul className="text-gray-400 space-y-1 text-sm text-left">
            <li><a href="#">Help Center</a></li>
            <li><a href="#">Contact Us</a></li>
            <li><a href="#">Privacy Policy</a></li>
            <li><a href="#">Terms of Service</a></li>
          </ul>
        </div>
      </div>

      {/* Bottom Bar */}
      <div className="mt-8 border-t border-slate-700 pt-4 text-center text-sm text-gray-500">
        © 2025 JobSeeker. All rights reserved. Built with Yasmeen.Alaa
      </div>
    </footer>
  );
}
