# Advanced Firebase Authentication Implementation with Student Approval System

## 📋 Authentication Flow Overview

### **Three-Tier Authentication System:**

1. **STUDENTS** 🎓
   - Sign up with detailed information
   - Request goes to admin for approval
   - Cannot login until admin approves
   - Status tracking: `pending` → `approved` → `active`

2. **STAFF** 👨‍💼
   - Pre-created accounts by admin
   - Direct login with email/password
   - No signup process required

3. **ADMIN** 👑
   - Pre-created superuser accounts
   - Direct login with email/password
   - Can approve/reject student requests
   - Manage staff accounts

## 🗃️ Professional Database Structure

### **Firestore Collections:**

```
🔥 FIRESTORE DATABASE STRUCTURE

📁 users/ (Main user collection)
  └── {uid}/
      ├── uid: string
      ├── email: string
      ├── firstName: string
      ├── lastName: string
      ├── role: 'student' | 'staff' | 'admin'
      ├── status: 'pending' | 'approved' | 'active' | 'suspended'
      ├── profileImageUrl?: string
      ├── createdAt: timestamp
      ├── lastLoginAt?: timestamp
      ├── isEmailVerified: boolean
      └── createdBy: string (admin uid who approved)

📁 student_requests/ (Pending student signups)
  └── {requestId}/
      ├── requestId: string (auto-generated)
      ├── email: string
      ├── firstName: string
      ├── lastName: string
      ├── rollNumber: string
      ├── hostel: string
      ├── roomNumber: string
      ├── phoneNumber: string
      ├── department: string
      ├── semester: number
      ├── status: 'pending' | 'approved' | 'rejected'
      ├── requestedAt: timestamp
      ├── processedAt?: timestamp
      ├── processedBy?: string (admin uid)
      ├── rejectionReason?: string
      └── documents: {
          ├── idCardUrl?: string
          └── feeReceiptUrl?: string
      }

📁 students/ (Approved students only)
  └── {uid}/
      ├── uid: string
      ├── rollNumber: string
      ├── department: string
      ├── semester: number
      ├── hostel: string
      ├── roomNumber: string
      ├── phoneNumber: string
      ├── batch: number
      ├── parentContact?: string
      ├── address?: string
      ├── approvedAt: timestamp
      ├── approvedBy: string
      └── academicInfo: {
          ├── cgpa?: number
          ├── attendance?: number
          └── fees: {
              ├── total: number
              ├── paid: number
              └── pending: number
          }
      }

📁 staff/ (Staff members)
  └── {uid}/
      ├── uid: string
      ├── employeeId: string
      ├── department: string
      ├── position: string
      ├── joiningDate: timestamp
      ├── salary?: number
      ├── phoneNumber: string
      └── permissions: string[]

📁 admins/ (System administrators)
  └── {uid}/
      ├── uid: string
      ├── adminLevel: 'super' | 'standard'
      ├── permissions: string[]
      ├── canApproveStudents: boolean
      ├── canManageStaff: boolean
      └── lastActivity: timestamp

📁 notifications/ (System notifications)
  └── {notificationId}/
      ├── type: 'student_request' | 'approval' | 'rejection'
      ├── targetUserId: string
      ├── title: string
      ├── message: string
      ├── isRead: boolean
      ├── createdAt: timestamp
      └── data: object

📁 audit_logs/ (System activity tracking)
  └── {logId}/
      ├── action: string
      ├── performedBy: string
      ├── targetUser?: string
      ├── details: object
      ├── timestamp: timestamp
      └── ipAddress?: string
```

## 🏗️ Enhanced Model Classes

### Create: `lib/app/data/models/auth_models.dart`