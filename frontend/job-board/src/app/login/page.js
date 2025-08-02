'use client';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { IoEye,IoEyeOff } from "react-icons/io5";
import { useRouter } from 'next/navigation';
import { getUsers, setCurrentUser } from '@/utils/getCurrentUser';
import { useAuth } from '@/context/AuthContext';

export default function Page() {
  const [role, setRole] = useState('jobseeker');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [users, setUsers] = useState([]);
  const [showPassword, setShowPassword] = useState(false);
const router = useRouter();
  const { isLoggedIn, logout,setIsLoggedIn,setUser } = useAuth();

//   useEffect(() => {
//     if (typeof window !== 'undefined') {
//       const storedUsers = localStorage.getItem('users');
//       if (storedUsers) {
//         setUsers(JSON.parse(storedUsers));
//       }
//     }
//   }, []);
const [fieldErrors, setFieldErrors] = useState({});

 const handleLogin = (e) => {
  e.preventDefault();

  const errors = {};

  // Simple email regex
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!email || !emailRegex.test(email)) {
    errors.email = 'Please enter a valid email address';
  }

  if (!password || password.length < 6) {
    errors.password = 'Password must be at least 6 characters';
  }

  setFieldErrors(errors);
console.log(errors)
  // Stop if there are validation errors
  if (Object.keys(errors).length > 0) {
    return;
  }

  const users = getUsers();
  const found = users.find(
    u => u.email === email && u.password === password && u.role === role
  );

  if (found) {
    setCurrentUser(found);
    setUser(found)
    setIsLoggedIn(true);
    
    router.push('/');
    setError('');
  } else {
    setError('Invalid credentials or role');
  }
};


  return (
    <div className="min-h-screen tracking-[.15em] flex items-center justify-center bg-blue-50 px-4">
      <div className="bg-white shadow-md rounded-lg p-8 w-full max-w-md">
        <h2 className="text-2xl font-semibold text-center">Welcome Back</h2>
        <p className="text-sm text-center text-gray-500 mb-6">
          Sign in to your account to continue
        </p>

        <div className="flex mb-4">
          <button
            onClick={() => setRole('jobseeker')}
            type="button"
            className={`w-1/2 py-2 text-sm  rounded-md ${
              role === 'jobseeker'
                ? 'bg-blue-600 text-white'
                : 'bg-gray-100 text-gray-600'
            }`}
          >
            Job Seeker
          </button>
          <button
            onClick={() => setRole('admin')}
            type="button"
            className={`w-1/2 py-2  text-sm rounded-md ${
              role === 'admin'
                ? 'bg-blue-600 text-white'
                : 'bg-gray-100 text-gray-600'
            }`}
          >
            Admin
          </button>
        </div>

        <form onSubmit={handleLogin} className="space-y-4">
          <div>
            <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2 text-left">
              Email
            </label>
            <input
              id="email"
              type="email"
              placeholder="Enter your email"
              className="w-full px-3 py-2 border border-gray-200 text-sm  rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400"
              value={email}
              onChange={e => setEmail(e.target.value)}
              
            />
            {fieldErrors.email && (
  <p className="text-red-500 text-xs mt-1 text-left">{fieldErrors.email}</p>
)}
          </div>

          <div className="relative">
            <label htmlFor="password" className="mb-2 text-left block text-sm font-medium text-gray-700">
              Password
            </label>
            <input
              id="password"
              type={showPassword ? 'text' : 'password'}
              placeholder="Enter your password"
              className="w-full px-3 py-2 border border-gray-200 text-sm rounded-md pr-10 focus:outline-none focus:ring-2 focus:ring-blue-400"
              value={password}
              onChange={e => setPassword(e.target.value)}
              
            />
            
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute top-9 right-3 text-gray-500 hover:text-gray-700"
              aria-label={showPassword ? 'Hide password' : 'Show password'}
            >
              {showPassword ? <IoEyeOff size={20} /> : <IoEye size={20} />}
            </button>
            {fieldErrors.password && (
  <p className="text-red-500 text-xs mt-1 text-left">{fieldErrors.password}</p>
)}
          </div>

          {/* <div className="flex justify-between items-center text-sm">
            <label className="flex items-center gap-2">
              <input type="checkbox" className="accent-blue-600" /> Remember me
            </label>
            <a href="#" className="text-blue-600 hover:underline">
              Forgot password?
            </a>
          </div> */}

          <button
            type="submit"
            className="w-full py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md"
          >
            Sign In
          </button>
        </form>

        {error && (
          <p className="text-red-500 text-sm mt-2 text-center">{error}</p>
        )}

        <p className="mt-6 text-sm text-center text-gray-500">
          Don't have an account?{' '}
          <Link href="/signup" className="text-blue-600 hover:underline">
            Sign up
          </Link>
        </p>
      </div>
    </div>
  );
}
