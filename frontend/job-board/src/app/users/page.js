'use client'

import { useAuth } from '@/context/AuthContext';
import { getApplicationsFromLocalStorage } from '@/utils/applicationUtils';
import { useEffect, useState, useRef } from 'react';
import { FaEye, FaEdit, FaTrash, FaUserPlus } from 'react-icons/fa';

export default function UserManagement() {
  const [users, setUsers] = useState([]);
  const [showDialog, setShowDialog] = useState(false);
  const [newAdmin, setNewAdmin] = useState({ fullName: '', email: '' });
  const dialogRef = useRef(null);
  const { user } = useAuth();

  useEffect(() => {
    const storedUsers = JSON.parse(localStorage.getItem('users') || '[]');
    setUsers(storedUsers);
  }, []);

  const deleteUser = (id) => {
    const updatedUsers = users.filter(user => user.id !== id);
    setUsers(updatedUsers);
    localStorage.setItem('users', JSON.stringify(updatedUsers));
  };

  const getApplicationCount = (userId) => {
    const apps = getApplicationsFromLocalStorage();
    console.log(apps)
    return apps.filter(app => app.userId === userId).length;
  };
const [errors, setErrors] = useState({ fullName: '', email: '', password: '' });

  // const handleAddAdmin = () => {
  //   const newUser = {
  //     id: Date.now().toString(),
  //     fullName: newAdmin.fullName,
  //     email: newAdmin.email,
  //     role: 'admin',
  //     createdAt: new Date().toLocaleDateString(),
  //   };
  //   const updatedUsers = [...users, newUser];
  //   setUsers(updatedUsers);
  //   localStorage.setItem('users', JSON.stringify(updatedUsers));
  //   setNewAdmin({ fullName: '', email: '' });
  //   setShowDialog(false);
  // };
const handleAddAdmin = () => {
  const { fullName, email, password } = newAdmin;
  const newErrors = { fullName: '', email: '', password: '' };
  let valid = true;

  // Validate Full Name
  if (!fullName.trim()) {
    newErrors.fullName = 'Full name is required';
    valid = false;
  } else if (fullName.trim().length < 3) {
    newErrors.fullName = 'Full name must be at least 3 characters';
    valid = false;
  }

  // Validate Email
  if (!email.trim()) {
    newErrors.email = 'Email is required';
    valid = false;
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    newErrors.email = 'Email is not valid';
    valid = false;
  } else if (users.some((u) => u.email.toLowerCase() === email.trim().toLowerCase())) {
    newErrors.email = 'Email already exists';
    valid = false;
  }

  // Validate Password
  if (!password.trim()) {
    newErrors.password = 'Password is required';
    valid = false;
  } else if (password.length < 6) {
    newErrors.password = 'Password must be at least 6 characters';
    valid = false;
  }

  setErrors(newErrors);

  if (!valid) return;

  const newUser = {
    id: Date.now().toString(),
    fullName,
    email,
    password,
    role: 'admin',
    createdAt: new Date().toLocaleDateString(),
  };

  const updatedUsers = [...users, newUser];
  setUsers(updatedUsers);
  localStorage.setItem('users', JSON.stringify(updatedUsers));
  setNewAdmin({ fullName: '', email: '', password: '' });
  setErrors({ fullName: '', email: '', password: '' });
  setShowDialog(false);
};

  return (
    <div className="p-8 md:px-20 text-left">
      <div className="flex justify-between items-center mb-4">
        <div>
           <div>
          <h1 className="text-xl sm:text-2xl font-bold mb-1">User Management</h1>
          <p className="text-xs sm:text-sm text-gray-500">Manage and track all users and admins on your platform</p>
        </div>   </div>
        <button
          onClick={() => setShowDialog(true)}
          className="flex text-xs sm:text-sm items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700"
        >
          <FaUserPlus /> Add Admin
        </button>
      </div>

    {showDialog && (
  <div className="fixed inset-0 z-50 flex items-center justify-center">
    <div className="bg-white border border-gray-300 p-6 rounded-xl w-full max-w-md shadow-xl">
      <h2 className="text-lg font-semibold mb-4 sm:text-sm">Add New Admin</h2>
      <div className="space-y-3">
       <input
  type="text"
  placeholder="Full Name"
  value={newAdmin.fullName}
  onChange={(e) => setNewAdmin({ ...newAdmin, fullName: e.target.value })}
  className={`w-full border px-3 py-2 rounded ${errors.fullName ? 'border-red-500' : 'border-gray-300'}`}
/>
{errors.fullName && <p className="text-sm text-red-500">{errors.fullName}</p>}

<input
  type="email"
  placeholder="Email"
  value={newAdmin.email}
  onChange={(e) => setNewAdmin({ ...newAdmin, email: e.target.value })}
  className={`w-full border px-3 py-2 rounded ${errors.email ? 'border-red-500' : 'border-gray-300'}`}
/>
{errors.email && <p className="text-sm text-red-500">{errors.email}</p>}

<input
  type="password"
  placeholder="Password"
  value={newAdmin.password}
  onChange={(e) => setNewAdmin({ ...newAdmin, password: e.target.value })}
  className={`w-full border px-3 py-2 rounded ${errors.password ? 'border-red-500' : 'border-gray-300'}`}
/>
{errors.password && <p className="text-sm text-red-500">{errors.password}</p>}

      </div>
      <div className="mt-6 flex justify-end gap-3">
        <button
          onClick={() => setShowDialog(false)}
          className="px-4 py-2 rounded bg-gray-200 hover:bg-gray-300 text-sm"
        >
          Cancel
        </button>
        <button
          onClick={handleAddAdmin}
          className="px-4 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white text-sm"
        >
          Add Admin
        </button>
      </div>
    </div>
  </div>
)}


      <div className="overflow-x-auto text-left tracking-[.2em] mt-4">
        <table className="min-w-full bg-white shadow-md rounded-lg">
          <thead>
            <tr className="bg-gray-100 text-xs sm:text-sm text-gray-700">
              <th className="p-3 text-left">User</th>
              <th className="p-3 text-left">Role</th>
              <th className="p-3 text-left">Applications</th>
              <th className="p-3 text-left">Join Date</th>
              <th className="p-3 text-center">Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map(mappedUser => (
              <tr key={mappedUser.id} className="border-b border-gray-200 hover:bg-gray-50">
                <td className="p-3">
                  <div className="font-semibold text-xs sm:text-sm">{mappedUser.fullName}</div>
                  <div className=" text-gray-500 text-xs">{mappedUser.email}</div>
                </td>
                <td className="p-2 sm:p-3">
                  <span className={`px-3 py-2 text-xs rounded-full text-center ${mappedUser.role === 'admin' ? 'bg-blue-100 text-blue-800' : 'bg-purple-100 text-purple-800'}`}>
                    {mappedUser.role}
                  </span>
                </td>
                <td className="p-3 text-xs sm:text-sm">
                  {mappedUser.role === 'jobseeker' ? `created ${getApplicationCount(mappedUser.id)}` : '0'}
                </td>
                <td className="p-3 text-xs sm:text-sm">{mappedUser.createdAt}</td>
                <td className="p-3 text-center space-x-3 text-xs sm:text-sm">
                  {mappedUser.id === user?.id ? (
                    <div className="bg-blue-200 text-blue-800 font-semibold text-xs sm:text-sm p-2 rounded-full">
                      You
                    </div>
                  ) : (
                    <button onClick={() => deleteUser(mappedUser.id)}>
                      <FaTrash className="inline text-red-500" />
                    </button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
