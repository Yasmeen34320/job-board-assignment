"use client";
import React, { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { saveApplicationToLocalStorage, generateUniqueId } from '@/utils/applicationUtils';
import { useAuth } from '@/context/AuthContext';

export default function ApplyPage() {
  const { id } = useParams();
  const router = useRouter();

  const [step, setStep] = useState(1);
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    phone: '',
    resumePath: '',
    resumeData: '', // Store base64 data
    coverLetter: '',
    yearsOfExperience: '',
    expectedSalary: '',
    availability: '',
  });
  const [errors, setErrors] = useState({});
  const { user } = useAuth();

  const validateStep = (stepNumber) => {
    const newErrors = {};
    if (stepNumber === 1) {
      if (!formData.fullName) newErrors.fullName = "Full Name is required.";
      if (!formData.email || !/^\S+@\S+\.\S+$/.test(formData.email)) newErrors.email = "Valid email required.";
      if (!formData.phone || !/^\+?[\d\s-]{10,}$/.test(formData.phone)) newErrors.phone = "Valid phone required.";
      if (!formData.resumePath) newErrors.resumePath = "Resume is required.";
    } else {
      if (!formData.coverLetter) newErrors.coverLetter = "Cover Letter required.";
      if (!formData.yearsOfExperience) newErrors.yearsOfExperience = "Select experience level.";
      if (!formData.expectedSalary) newErrors.expectedSalary = "Expected Salary is required.";
      if (!formData.availability) newErrors.availability = "Availability required.";
    }
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleNext = () => {
    if (validateStep(step)) {
      if (step === 1) setStep(2);
      else submitApplication();
    }
  };

  const submitApplication = () => {
    const application = {
      id: generateUniqueId(),
      jobId: id,
      userId: user?.id || "guest",
      ...formData,
      status:'pending',
      createdAt: new Date().toISOString(),
    };
    saveApplicationToLocalStorage(application);
    router.push("/applications");
  };

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onloadend = () => {
      setFormData({
        ...formData,
        resumePath: file.name,
        resumeData: reader.result, // Base64 data
      });
      setErrors(prev => ({ ...prev, resumePath: '' }));
    };
    reader.readAsDataURL(file); // Converts to base64
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center">
      <div className="bg-white max-w-lg w-full p-6 rounded-xl shadow-lg">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-semibold">Apply to Job</h2>
          <button onClick={() => router.push(`/jobs/${id}`)} className="text-gray-500 text-xl">&times;</button>
        </div>

        <div className="flex justify-between text-sm mb-6">
          <span className={`px-3 py-1 rounded-full ${step === 1 ? 'bg-blue-600 text-white' : 'text-gray-600 border'}`}>1. Personal Info</span>
          <span className={`px-3 py-1 rounded-full ${step === 2 ? 'bg-blue-600 text-white' : 'text-gray-600 border'}`}>2. Application</span>
        </div>

        {step === 1 && (
          <div className="space-y-4">
            <input
              type="text"
              placeholder="Full Name"
              className="w-full p-2 border rounded"
              value={formData.fullName}
              onChange={(e) => {
                setFormData({ ...formData, fullName: e.target.value });
                setErrors(prev => ({ ...prev, fullName: '' }));
              }}
            />
            {errors.fullName && <p className="text-red-500 text-sm">{errors.fullName}</p>}

            <input
              type="email"
              placeholder="Email"
              className="w-full p-2 border rounded"
              value={formData.email}
              onChange={(e) => {
                setFormData({ ...formData, email: e.target.value });
                setErrors(prev => ({ ...prev, email: '' }));
              }}
            />
            {errors.email && <p className="text-red-500 text-sm">{errors.email}</p>}

            <input
              type="tel"
              placeholder="Phone Number"
              className="w-full p-2 border rounded"
              value={formData.phone}
              onChange={(e) => {
                setFormData({ ...formData, phone: e.target.value });
                setErrors(prev => ({ ...prev, phone: '' }));
              }}
            />
            {errors.phone && <p className="text-red-500 text-sm">{errors.phone}</p>}

            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700">Resume/CV *</label>
              <div className="mt-1 border-2 border-dashed border-gray-300 rounded-md p-4 text-center">
                <input type="file" onChange={handleFileChange} className="hidden" id="resumeUpload" />
                <label htmlFor="resumeUpload" className="cursor-pointer text-blue-500 hover:text-blue-700">
                  Click to upload your resume
                </label>
                <p className="text-sm text-gray-500">PDF, DOC, or DOCX (max 10MB)</p>
                {formData.resumePath && <p className="text-sm text-gray-700">{formData.resumePath}</p>}
                {errors.resumePath && !formData.resumePath && <p className="text-red-500 text-sm">{errors.resumePath}</p>}
              </div>
            </div>
          </div>
        )}

        {step === 2 && (
          <div className="space-y-4">
            <textarea
              placeholder="Cover Letter (max 2000 chars)"
              className="w-full p-2 border rounded h-24"
              maxLength={2000}
              value={formData.coverLetter}
              onChange={(e) => setFormData({ ...formData, coverLetter: e.target.value })}
            />
            {errors.coverLetter && <p className="text-red-500 text-sm">{errors.coverLetter}</p>}

            <select
              className="w-full p-2 border rounded"
              value={formData.yearsOfExperience}
              onChange={(e) => setFormData({ ...formData, yearsOfExperience: e.target.value })}
            >
              <option value="">Years of Experience</option>
              <option value="0-2">0-2</option>
              <option value="3-5">3-5</option>
              <option value="6-10">6-10</option>
              <option value="10+">10+</option>
            </select>
            {errors.yearsOfExperience && <p className="text-red-500 text-sm">{errors.yearsOfExperience}</p>}

            <input
              type="text"
              placeholder="Expected Salary"
              className="w-full p-2 border rounded"
              value={formData.expectedSalary}
              onChange={(e) => setFormData({ ...formData, expectedSalary: e.target.value })}
            />
            {errors.expectedSalary && <p className="text-red-500 text-sm">{errors.expectedSalary}</p>}

            <input
              type="text"
              placeholder="Availability (e.g. Immediate)"
              className="w-full p-2 border rounded"
              value={formData.availability}
              onChange={(e) => setFormData({ ...formData, availability: e.target.value })}
            />
            {errors.availability && <p className="text-red-500 text-sm">{errors.availability}</p>}
          </div>
        )}

        <div className="flex justify-between mt-6">
          {step > 1 && <button onClick={() => setStep(step - 1)} className="text-gray-600 hover:text-black">← Back</button>}
          <button onClick={handleNext} className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
            {step === 1 ? "Continue" : "Submit"}
          </button>
        </div>
      </div>
    </div>
  );
}