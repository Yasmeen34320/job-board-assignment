"use client"; 

import React, { createContext, useContext, useEffect, useState } from 'react';
import { getCurrentUser, getUsers, removeCurrentUser } from '@/utils/getCurrentUser';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [user, setUser] = useState(null);

  useEffect(() => {
   const stored = localStorage.getItem('users');
     if (!stored) {
       localStorage.setItem('users', JSON.stringify(mockUsers));
     }
    const storedUser = getCurrentUser();
    if (storedUser) {
      setUser(storedUser);
      setIsLoggedIn(true);
    }
  }, []);

  const login = (userData) => {
    localStorage.setItem('currentUser', JSON.stringify(userData));
    setUser(userData);
    setIsLoggedIn(true);
  };

  const logout = () => {
    removeCurrentUser();
    setUser(null);
    setIsLoggedIn(false);
  };

  return (
    <AuthContext.Provider value={{ isLoggedIn, user, login,setIsLoggedIn, logout ,setUser}}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
