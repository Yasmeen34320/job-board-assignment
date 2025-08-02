export const mockUsers = [
  { email: 'admin@test.com', password: 'admin123',fullName:"Admin User", role: 'admin' },
  { email: 'user@test.com', password: 'user123', fullName : "User 1",role: 'jobseeker' }
];


// const users = JSON.parse(localStorage.getItem('users') || '[]');

// // Add user
// users.push(newUser);
// localStorage.setItem('users', JSON.stringify(users));

// // Delete user
// const filtered = users.filter(u => u.email !== targetEmail);
// localStorage.setItem('users', JSON.stringify(filtered));
