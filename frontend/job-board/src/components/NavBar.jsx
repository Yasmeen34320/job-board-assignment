"use client";
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import React, { useEffect, useState } from 'react';
import { MdOutlineLogout } from "react-icons/md";
import { HiMenu, HiX } from "react-icons/hi";
import { useAuth } from '@/context/AuthContext';

export default function NavBar() {
  const router = useRouter();
  const { isLoggedIn, user, logout } = useAuth();
  const [menuOpen, setMenuOpen] = useState(false);

  const toggleMenu = () => setMenuOpen(prev => !prev);

  return (
    <nav className="bg-white border-b border-gray-100 shadow-lg z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16 items-center">
          {/* Logo & Title */}
          <div className="flex items-center space-x-4">
            <Link href="/" className="text-xl font-semibold text-blue-800 tracking-[.2em] font-mono">
              JobSeeker
            </Link>
          </div>

          {/* Desktop Nav */}
          <div className="hidden md:flex space-x-6 items-center">
            <Link href="/" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">Home</Link>
            <Link href="/jobs" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">Jobs</Link>
            <Link href="/applications" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">Applications</Link>
            <Link href="/about" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">About</Link>
            {user?.role === 'admin' && (
              <Link href="/users" className="text-zinc-900 text-sm hover:text-blue-800 tracking-[.2em]">Users</Link>
            )}
          </div>

          {/* Right Section */}
          <div className="hidden md:flex items-center space-x-4">
            {isLoggedIn && user?.fullName && (
              <div className="flex items-center space-x-2">
                <div className="w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-medium">
                  {user?.fullName.split(' ').map(word => word[0]).join('')}
                </div>
                <span className="text-sm text-gray-700">{user?.fullName}</span>
              </div>
            )}
            {isLoggedIn ? (
              <MdOutlineLogout onClick={logout} className="text-red-500 text-2xl cursor-pointer" />
            ) : (
              <>
                <Link href="/login" className="text-zinc-900 text-sm hover:text-blue-800">Log In</Link>
                <Link href="/signup" className="bg-blue-800 text-sm text-white px-3 py-1 rounded hover:bg-blue-600">Sign Up</Link>
              </>
            )}
          </div>

          {/* Mobile Menu Button */}
          <div className=" md:hidden">
            
            <button onClick={toggleMenu} className="text-gray-800 text-3xl focus:outline-none">
              {menuOpen ? <HiX /> : <HiMenu />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu */}
      {menuOpen && (
        <div className="md:hidden bg-white px-4 pb-4 space-y-3">
          <Link href="/" className="block text-sm text-zinc-900 hover:text-blue-800">Home</Link>
          <Link href="/jobs" className="block text-sm text-zinc-900 hover:text-blue-800">Jobs</Link>
          <Link href="/applications" className="block text-sm text-zinc-900 hover:text-blue-800">Applications</Link>
          <Link href="/about" className="block text-sm text-zinc-900 hover:text-blue-800">About</Link>
          {user?.role === 'admin' && (
            <Link href="/users" className="block text-sm text-zinc-900 hover:text-blue-800">Users</Link>
          )}
          <div className="pt-2 border-t border-gray-200">
            {isLoggedIn && user?.fullName && (
              <div className="flex items-center space-x-2 mb-2">
                <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-medium">
                  {user?.fullName.split(' ').map(word => word[0]).join('')}
                </div>
                <span className="text-sm text-gray-700">{user?.fullName}</span>
              </div>
            )}
            {isLoggedIn ? (
              <div className="text-red-500 flex items-center space-x-2 text-sm cursor-pointer" onClick={logout}>
                <MdOutlineLogout className="text-xl" />
                <span>Logout</span>
              </div>
            ) : (
              <>
                <Link href="/login" className="block text-sm text-zinc-900 hover:text-blue-800">Log In</Link>
                <Link href="/signup" className="block bg-blue-800 text-white px-3 py-1 rounded text-sm hover:bg-blue-600">Sign Up</Link>
              </>
            )}
          </div>
        </div>
      )}
      {/* <p className="hidden lg:block">I should only show on large screens</p> */}

    </nav>
  );
}
