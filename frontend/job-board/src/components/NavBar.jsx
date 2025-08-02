"use client";
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import React from 'react'
import { useEffect, useState } from 'react'; // Import useEffect and useState hooks from React
import { RiLogoutBoxRLine } from "react-icons/ri";
import { MdOutlineLogout } from "react-icons/md";
import { getCurrentUser, removeCurrentUser } from '@/utils/getCurrentUser'; // adjust path
import { useAuth } from '@/context/AuthContext';


export default function NavBar() {

  
 
const router = useRouter();
const { isLoggedIn, user, logout } = useAuth();



  // const handleLogout = () => {
  //   removeCurrentUser();
  //   setIsLoggedIn(false);
  //   router.push('/login');
  // };
  return (
 <nav
      className="text-base  px-6 shadow-lg bg-white  border-b border-gray-100 z-50"
      // style={{  boxShadow: '0 4px 10px rgba(0, 0, 0, 0.6)' }}
    >  
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div className="flex justify-between h-16 items-center">
      <div className="flex  items-center space-x-4 mr-20">
        <Link href="/" className="text-xl font-semibold text-blue-800 pr-20 tracking-[.2em] font-mono">JobSeeker</Link>
        <Link href="/" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">Home</Link>
        <Link href="/jobs" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">Jobs</Link>
        <Link href="/applications" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">Applications</Link>
        <Link href="/about" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">About</Link>
                {/* <a href="/ssrAbout" className="text-white hover:text-purple-950 tracking-[.2em]">ssr</a> */}
{user?.role=='admin'&&        <Link href="/users" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">Users</Link>
}

      </div>
      <div className="flex items-center space-x-4">
            {/* <Link href="/login" className="text-zinc-900 text-sm hover:text-blue-800">
                  Log In
                </Link>
                <Link href="/signup" className="bg-blue-800 text-sm text-white px-3 py-1 rounded hover:bg-blue-600">
                  Sign Up
                </Link> */}
                {isLoggedIn && user?.fullName && (
              <div className="flex items-center space-x-2">
                <div className="w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-medium">
                  {user.fullName.split(' ').map(word => word[0]).join('')}
                </div>
                <span className="text-sm text-gray-700">{user.fullName}</span>
              </div>
            )}
                 {isLoggedIn ? (
                  <MdOutlineLogout  onClick={logout} className='text-red-500 text-2xl'/>

              // <button
              //   onClick={handleLogout}
              //   className="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-500 text-sm"
              // >
              //   Logout
              // </button>
            ) : (
              <>
                <Link href="/login" className="text-zinc-900 text-sm hover:text-blue-800">
                  Log In
                </Link>
                <Link href="/signup" className="bg-blue-800 text-sm text-white px-3 py-1 rounded hover:bg-blue-600">
                  Sign Up
                </Link>
              </>
            )}
          </div>
    </div>
  </div>
</nav>
  )
}
