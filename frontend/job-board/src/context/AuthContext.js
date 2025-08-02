"use client";
import { createContext, useContext, useState, useEffect } from "react";
import { getCurrentUser, removeCurrentUser } from "@/utils/getCurrentUser"; // if you use utils

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  useEffect(() => {
    const user = getCurrentUser();
    if (user) setIsLoggedIn(true);
  }, []);

  const logout = () => {
    removeCurrentUser();
    setIsLoggedIn(false);
  };

  return (
    <AuthContext.Provider value={{ isLoggedIn, setIsLoggedIn, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
