## 🚀 Technologies Used

### Web Frontend (`/frontend`)
- **Next.js 14** (App Router)
- **Tailwind CSS**
- **Local Storage** (mocked backend data)

### Mobile App (`/mobile`)
- **Flutter**
- **Hive** (local storage as a mock API)
- **Cubit** (`flutter_bloc`) for state management
- **Clean Architecture** (simplified: Presentation + Data Layers)

---

## 👩‍💼 Features Implemented

### ✅ Common Functionality
- Role-based navigation (Admin vs. Job Seeker)
- Login/Register workflows
- Clean and responsive UI/UX

---

### 🧑‍💻 Web – Job Board (Next.js)

#### Job Seeker
- Register & Login
- View job listings
- View job details
- Apply to jobs (resume file + cover letter)
- See history of applications submitted

#### Admin
- Secure login
- Create, edit, delete jobs
- View job seekers
- View applications for all job seekers
- Clean component-based layout using Tailwind CSS

---

### 📱 Mobile – Job Board App (Flutter)

#### Job Seeker
- Register & Login
- View jobs
- View job details
- Apply with resume file and cover letter
- View submitted applications

#### Admin
- Login as admin
- Manage jobs (create, edit, delete)
- View job seekers
- View all job applications

---

## ⚙️ Setup Instructions

### 1. Web Frontend

```bash
cd frontend
npm install
npm run dev
```

### 2. Mobile App

```bash
cd mobile
flutter pub get
flutter run
