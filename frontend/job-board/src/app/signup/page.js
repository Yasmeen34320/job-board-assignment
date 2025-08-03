'use client';
import { useAuth } from '@/context/AuthContext';
import { setCurrentUser } from '@/utils/getCurrentUser';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useState, useEffect } from 'react';
import { IoEye,IoEyeOff } from "react-icons/io5";

export default function Page() {
  const [role, setRole] = useState('jobseeker');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [fullName,setFullName]=useState('');
  const [users, setUsers] = useState([]);
  const [showPassword, setShowPassword] = useState(false);
const router = useRouter();
  const { setIsLoggedIn, logout ,setUser} = useAuth();

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const storedUsers = localStorage.getItem('users');
      if (storedUsers) {
        setUsers(JSON.parse(storedUsers));
      }
    }
  }, []);

  const handleSignup = (e) => {
  e.preventDefault();
const generateUniqueId = () => Date.now().toString(); // Simple unique ID

  if (!fullName || !email || !password) {
    setError('Please fill in all fields');
    return;
  }

  const exists = users.find(u => u.email === email);
  if (exists) {
    setError('User already exists');
    return;
  }

  const newUser = {
  id: generateUniqueId(), // ← Add this line
  fullName,
  email,
  password,
  role,
  createdAt:new Date().toLocaleDateString()
};

    

  const updatedUsers = [...users, newUser];
  localStorage.setItem('users', JSON.stringify(updatedUsers));
//  setCurrentUser(newUser);
// setUser(newUser)
 setCurrentUser(newUser);
    setUser(newUser)
  // localStorage.setItem('currentUser', JSON.stringify(newUser));
  setUsers(updatedUsers);
setIsLoggedIn(true);
  alert('Signup successful! You are now logged in.');
  router.push('/');
  setError('');
};


  return (
    <div className="min-h-screen tracking-[.15em] flex items-center justify-center bg-blue-50 px-4">
      <div className="bg-white shadow-md rounded-lg p-8 w-full max-w-md">
        <h2 className="text-2xl font-semibold text-center mb-2">Welcome back</h2>
        <p className="text-sm text-center text-gray-500 mb-6">
        Make an account to discover & apply for jobs
        </p>

        <div className="flex mb-4 justify-center">
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
          {/* <button
            onClick={() => setRole('admin')}
            type="button"
            className={`w-1/2 py-2  text-sm rounded-md ${
              role === 'admin'
                ? 'bg-blue-600 text-white'
                : 'bg-gray-100 text-gray-600'
            }`}
          >
            Admin
          </button> */}
        </div>

        <form onSubmit={handleSignup} className="space-y-4">
           <div>
            <label htmlFor="fullname" className="block text-sm font-medium text-gray-700 mb-2 text-left">
              Full Name
            </label>
            <input
              id="fullname"
              type="text"
              placeholder="Enter your full name"
              className="w-full px-3 py-2 border border-gray-200 text-sm  rounded-md focus:outline-none focus:ring-2 focus:ring-blue-400"
              value={fullName}
              onChange={e => setFullName(e.target.value)}
              required
            />
          </div>
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
              required
            />
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
              required
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute top-9 right-3 text-gray-500 hover:text-gray-700"
              aria-label={showPassword ? 'Hide password' : 'Show password'}
            >
              {showPassword ? <IoEyeOff size={20} /> : <IoEye size={20} />}
            </button>
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
            Sign Up
          </button>
        </form>

        {error && (
          <p className="text-red-500 text-sm mt-2 text-center">{error}</p>
        )}

        <p className="mt-6 text-sm text-center text-gray-500">
           have an account?{' '}
          <Link href="/login" className="text-blue-600 hover:underline">
            Sign In
          </Link>
        </p>
      </div>
    </div>
  );
}
