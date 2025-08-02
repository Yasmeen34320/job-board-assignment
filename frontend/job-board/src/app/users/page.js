'use client'

import { getApplicationsFromLocalStorage } from '@/utils/applicationUtils';
import { useEffect, useState } from 'react';
import { FaEye, FaEdit, FaTrash } from 'react-icons/fa';

const initialUsers = [
  {
    id: 1,
    name: 'Sarah Johnson',
    email: 'sarah.johnson@email.com',
    role: 'Job Seeker',
    lastLogin: '2024-12-20',
    joinDate: '2024-01-15',
    location: 'New York, NY',
  },
  {
    id: 2,
    name: 'Michael Chen',
    email: 'michael.chen@email.com',
    role: 'Admin',
    lastLogin: '2024-12-21',
    joinDate: '2024-01-10',
    location: 'San Francisco, CA',
  },
  {
    id: 3,
    name: 'Emily Rodriguez',
    email: 'emily.rodriguez@email.com',
    role: 'Job Seeker',
    lastLogin: '2024-12-19',
    joinDate: '2024-02-01',
    location: 'Austin, TX',
  },
  {
    id: 4,
    name: 'David Wilson',
    email: 'david.wilson@email.com',
    role: 'Job Seeker',
    lastLogin: '2024-11-30',
    joinDate: '2024-03-15',
    location: 'Chicago, IL',
  },
];

const mockApplications = [
  { userId: 1 }, { userId: 1 }, { userId: 1 },
  { userId: 3 }, { userId: 3 },
  { userId: 4 },
];

export default function UserManagement() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    const storedUsers = JSON.parse(localStorage.getItem('users') || '[]');
    if (storedUsers.length === 0) {
      localStorage.setItem('users', JSON.stringify(initialUsers));
      setUsers(initialUsers);
    } else {
      setUsers(storedUsers);
    }
  }, []);

  const deleteUser = (id) => {
    const updatedUsers = users.filter(user => user.id !== id);
    setUsers(updatedUsers);
    localStorage.setItem('users', JSON.stringify(updatedUsers));
  };

  const getApplicationCount = (userId) => {
    const apps =getApplicationsFromLocalStorage();
    return apps.filter(app => app.userId === userId).length;
  };

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-2">User Management</h1>
      <p className="text-sm text-gray-500 mb-6">Manage and track all users and admins on your platform</p>

      <div className="overflow-x-auto">
        <table className="min-w-full bg-white shadow-md rounded-lg">
          <thead>
            <tr className="bg-gray-100 text-sm text-gray-700">
              <th className="p-3 text-left">User</th>
              <th className="p-3 text-left">Role</th>
              <th className="p-3 text-left">Applications</th>
              <th className="p-3 text-left">Join Date</th>
              <th className="p-3 text-center">Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map(user => (
              <tr key={user.id} className="border-b hover:bg-gray-50">
                <td className="p-3">
                  <div className="font-semibold">{user.name}</div>
                  <div className="text-sm text-gray-500">{user.email}</div>
                  <div className="text-xs text-gray-400">{user.location}</div>
                </td>
                <td className="p-3">
                  <span className={`px-2 py-1 text-xs rounded-full ${user.role === 'Admin' ? 'bg-blue-100 text-blue-800' : 'bg-purple-100 text-purple-800'}`}>{user.role}</span>
                </td>
                <td className="p-3 text-sm">
                  {user.role === 'Job Seeker' ? `${getApplicationCount(user.id)} applications` : '-'}
                  <br />
                  <span className="text-xs text-gray-400">Last login: {user.lastLogin}</span>
                </td>
                <td className="p-3 text-sm">{user.joinDate}</td>
                <td className="p-3 text-center space-x-3">
                  <button><FaEye className="inline text-blue-500" /></button>
                  <button><FaEdit className="inline text-green-500" /></button>
                  <button onClick={() => deleteUser(user.id)}><FaTrash className="inline text-red-500" /></button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
