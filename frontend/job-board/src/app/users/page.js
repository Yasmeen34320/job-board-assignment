'use client';

import { clearUsers, getCurrentUser, getUsers } from '@/utils/getCurrentUser';
import React, { useEffect, useState } from 'react';

export default function UsersPage() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    // clearUsers()
    var localUsers =getUsers()
    // const user = getCurrentUser()
    // localUsers.push(user)
    setUsers(localUsers);

  }, []);

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-4">All Users</h1>
      {users.length === 0 ? (
        <p>No users found.</p>
      ) : (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {users.map((user) => (
            <div key={user.id} className="border rounded-lg p-4 shadow">
              <h2 className="text-lg font-semibold">{user.fullName}</h2>
              <p><strong>Email:</strong> {user.email}</p>
              <p><strong>Role:</strong> {user.role}</p>
              <p><strong>ID:</strong> {user.id}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
