# Complete Module Flow Documentation

Generated on: 2026-04-20
Project: mess_management

## 1. Scope and Coverage

This document analyzes the complete runtime flow and module responsibilities for:
- Authentication module
- Admin module
- Student module
- Staff module
- Supporting models, services, routes, and bindings used by those modules

Scanned source scope:
- lib/app/modules/auth
- lib/app/modules/admin
- lib/app/modules/student
- lib/app/modules/staff
- lib/app/modules/user
- lib/app/data/models
- lib/app/data/services
- lib/app/routes
- lib/app/bindings

Approximate Dart files covered in this scope: 115

## 2. Architecture Overview

Application style:
- Flutter UI + GetX for state management, dependency injection, and route navigation
- Firebase Authentication for credentials/session
- Cloud Firestore for application data and business records

Main layering pattern:
- Pages and components
- Controllers (GetX)
- Services (Firebase and business operations)
- Models (Firestore serialization/deserialization)

Core dependency graph:
- Pages call controllers
- Controllers call services
- Services read/write Firestore and Firebase Auth
- Models define schema contracts used by services/controllers/pages

## 3. Bootstrapping and Dependency Injection

File: lib/app/bindings/initial_binding.dart

Registered in initial binding:
- AuthController
- UserController
- MenuService
- UserService

What this means:
- Auth and user session context are globally available early
- Menu and user data services are available to admin/student/staff controllers without manual wiring in each page

## 4. Routing and Navigation Model

### 4.1 Registered routes (actual GetPage entries)

Defined in lib/app/routes/app_pages.dart:
- /
- /login
- /landing
- /signup
- /password-reset
- /student
- /staff
- /admin

### 4.2 Route constants

Defined in lib/app/routes/app_routes.dart:
- Includes many legacy and extended constants such as /student/dashboard, /staff/dashboard, /admin/dashboard, and feature routes
- Important: Not all constants are registered in app_pages.dart

### 4.3 Internal dashboard navigation

Each role dashboard primarily uses internal tab/index switching (not separate named routes for each tab):
- Student dashboard: index-based page switching in EnhancedStudentDashboard
- Staff dashboard: index-based page switching in StaffDashboard
- Admin dashboard: index-based page switching in AdminDashboard

## 5. Authentication and Authorization Flow

## 5.1 Startup and session resolution

Entry page:
- lib/app/modules/auth/splash_screen.dart

Flow:
- Splash checks current session through AuthService and role/status data
- If no valid active user, navigate to login
- If valid active user, navigate to role dashboard

## 5.2 Student signup flow

UI:
- lib/app/modules/auth/signup_page.dart
- lib/app/modules/auth/controllers/auth_controller.dart

Service logic:
- lib/app/data/services/auth_service.dart

Current flow:
1. Signup form validates required fields and format
2. StudentSignupRequest is created in AuthController
3. AuthService.studentSignup validates duplicates (email, roll number)
4. AuthService creates a pending Firebase Auth user using the password entered by student
5. AuthService creates a student request record in student_requests with pendingAuthUid
6. Admin notifications and audit log are attempted
7. Pending auth user is signed out after request submission
8. User is informed request is pending approval

Important current behavior:
- Student password from signup is preserved for later login after approval
- Admin approval does not assign a replacement password

## 5.3 Admin approval and rejection flow

Controllers:
- lib/app/modules/admin/controllers/admin_overview_controller.dart (active in admin dashboard overview)
- lib/app/modules/auth/controllers/admin_approval_controller.dart (legacy/alternate approval flow controller)

Service logic:
- AuthService.approveStudentRequest
- AuthService.rejectStudentRequest

Approve flow:
1. Admin selects pending request
2. AuthService loads student request
3. Uses pendingAuthUid from request (created during signup)
4. Creates AppUser record in users collection with active student status
5. Creates StudentDetails record in students collection
6. Updates student request status to approved (processed metadata added)
7. Sends approval notification and audit log

Reject flow:
1. Admin provides rejection reason
2. student_requests status updated to rejected with reason and processed metadata
3. Rejection notification/email hook is triggered

Important note:
- Student request is status-updated, not deleted, in current implementation
- If old request does not have pendingAuthUid, approval fails with clear message to request re-signup

## 5.4 Login flow

UI:
- lib/app/modules/auth/enhanced_login_page.dart

Controller:
- lib/app/modules/auth/controllers/auth_controller.dart

Service:
- AuthService.staffAdminLogin
- AuthService.studentLogin

Flow:
1. User selects role and enters credentials
2. Role-based auth path executes
3. Status checks include suspended/deleted/inactive handling
4. On success, current user is set and user data synced
5. Navigation to role dashboard is triggered

Current nuance:
- AuthController uses route constants for dashboard navigation; ensure constants and app_pages registered routes stay aligned

## 5.5 Password reset flow

UI:
- lib/app/modules/auth/password_reset_page.dart

Controller/service:
- AuthController.resetPassword
- AuthService.sendPasswordResetEmail

Flow:
1. Email validation in UI + controller
2. AuthService calls Firebase sendPasswordResetEmail
3. Success toast and success callback UI state update

## 5.6 Logout flow

Controller method:
- AuthController.logout

Flow:
1. Prevents duplicate auth-state redirects with isLoggingOut flag
2. Signs out from Firebase
3. Clears UserController session data
4. Redirects to /login

## 6. Admin Module Deep Analysis

## 6.1 Container and top navigation

Files:
- lib/app/modules/admin/pages/admin_dashboard.dart
- lib/app/modules/admin/admin_controller.dart

Admin dashboard tabs (index based):
- 0 Dashboard overview
- 1 User Management
- 2 Menu Management
- 3 Feedback

Header stats source:
- AdminController.loadRealUserStats + pending approvals stream
- Uses UserService and AuthService

## 6.2 Overview page

Files:
- lib/app/modules/admin/pages/admin_overview_page/admin_overview_page.dart
- lib/app/modules/admin/controllers/admin_overview_controller.dart
- Component files in pages/admin_overview_page/components

Responsibilities:
- Load and stream pending student approvals
- Aggregate basic system counters
- Execute approve/reject actions
- Render quick actions and pending approvals cards

## 6.3 User management

Files:
- lib/app/modules/admin/pages/user_managemnt/admin_user_management_page.dart
- lib/app/modules/admin/controllers/user_management_controller.dart
- user_managemnt/components/*

Responsibilities:
- List student/staff users
- Filter by role/status/search
- Add user (student/staff) through managed create flow
- Edit selected user details
- Suspend/activate/soft-delete user status
- View detailed user info dialogs

Service dependencies:
- UserService (users, students, staff collections)

## 6.4 Menu management

Files:
- lib/app/modules/admin/pages/menu_management/admin_menu_management_page.dart
- lib/app/modules/admin/controllers/admin_menu_controller.dart
- menu_management/components/*

Responsibilities:
- CRUD menu items
- Manage categories and filters
- Manage nutrition analytics view
- Connect to template/rate/schedule service operations

Service dependencies:
- MenuService

## 6.5 Feedback management

File:
- lib/app/modules/admin/pages/feedback_management/admin_feedback_management_page.dart

Responsibilities:
- Load student feedback list through MenuService.getAllStudentFeedbacks
- Filter feedback by status
- Show rating/comment/student metadata
- Add/edit admin response
- Update feedback response + status through MenuService.respondToStudentFeedback

## 7. Student Module Deep Analysis

## 7.1 Container and navigation

Files:
- lib/app/modules/student/pages/enhanced_student_dashboard.dart
- lib/app/modules/student/student_controller.dart

Student dashboard tabs:
- 0 Home
- 1 Attendance
- 2 Billing
- 3 Menu
- 4 Feedback

Data source strategy in StudentController:
- Session user from UserController
- Firestore-backed menu/attendance/feedback/billing through services
- Fallback meal rates through DummyDataService when needed
- Month-level attendance cache to reduce repeated reads

## 7.2 Home page

Files:
- pages/student_home_page/student_home_page.dart
- student_home_page/components/*

Responsibilities:
- Show welcome, quick stats, today attendance/menu, activity, quick actions
- Uses StudentController derived live values

## 7.3 Attendance page

Files:
- pages/student_view_attendance/student_attendance_page.dart
- student_view_attendance/components/*

Responsibilities:
- Month navigation and calendar rendering
- Present/absent stats
- Per-day detail and meal cards
- Attendance load via StudentController month cache and service reads

## 7.4 Billing page

Files:
- pages/student_biling_page/student_billing_page.dart
- student_biling_page/components/*

Responsibilities:
- Current month bill summary
- Meal count and rate breakdown
- History view
- Bill PDF generation trigger

## 7.5 Menu page

Files:
- pages/student_view_menu/student_menu_page.dart
- student_view_menu/components/*

Responsibilities:
- Weekly menu display (breakfast/dinner)
- Week navigation
- Meal detail and nutrition display
- Attendance status integration on menu view

## 7.6 Feedback page

Files:
- pages/feedback_page/student_feedback_page.dart
- feedback_page/components/*

Responsibilities:
- Submit feedback form (category, rating, comment)
- View recent feedback submissions
- Display admin response when present

## 8. Staff Module Deep Analysis

## 8.1 Container and navigation

Files:
- lib/app/modules/staff/pages/staff_dashboard.dart
- lib/app/modules/staff/staff_controller.dart

Staff dashboard tabs:
- 0 Dashboard
- 1 Attendance
- 2 Students

Data strategy:
- Student list through StaffStudentController + UserService
- Attendance operations and cache in StaffController
- Menu/rates currently loaded from DummyDataService in StaffController

## 8.2 Overview

Files:
- pages/staff_overviewPage/staff_overview_page.dart
- staff_overviewPage/components/*

Responsibilities:
- Today metrics
- Welcome and quick action blocks
- Recent activity view

## 8.3 Mark attendance

Files:
- pages/staff_mark_attendance/staff_attendance_page.dart
- staff_mark_attendance/components/*

Responsibilities:
- Choose date and meal type
- Search/filter students
- Mark present/absent with cached immediate UI updates
- Persist via service methods

## 8.4 Student management/reporting

Files:
- pages/student_report/staff_student_management_page.dart
- student_report/components/*
- controllers/staff_student_controller.dart

Responsibilities:
- List/search/filter students for staff-side management/reporting
- Detail dialogs and stats blocks

## 9. Service Layer Responsibilities

## 9.1 AuthService

File:
- lib/app/data/services/auth_service.dart

Primary responsibilities:
- Session user resolution
- Student signup pending request workflow
- Student/staff/admin login methods
- Approve/reject student request workflow
- Password reset email trigger
- Notification/audit hooks

Main Firestore collections touched:
- users
- student_requests
- students
- staff
- admins
- notifications
- audit_logs

## 9.2 UserService

File:
- lib/app/data/services/user_service.dart

Primary responsibilities:
- Query all users by role
- Query student/staff detail records
- Update user status
- Soft delete users
- Create managed student/staff users with profile records
- Billing helpers (monthly bill records)

Main Firestore collections touched:
- users
- students
- staff
- student sub-doc billing/attendance helpers where used

## 9.3 MenuService

File:
- lib/app/data/services/menu_service.dart

Primary responsibilities:
- Menu item CRUD and duplicate checks
- Template CRUD
- Active schedule and rates
- Menu feedback and student feedback
- Attendance write/read helpers
- Analytics helpers

Main Firestore collections touched:
- menu_items
- menu_templates
- active_menu_schedule
- meal_rates
- meal_categories
- menu_feedback
- feedback

## 9.4 DummyDataService and UserTestDataService

Files:
- lib/app/data/services/dummy_data_service.dart
- lib/app/data/services/user_test_data_service.dart

Purpose:
- Development/demo fallback data and test data utilities

## 10. Model Layer Responsibilities

Key model files:
- lib/app/data/models/auth_models.dart
- lib/app/data/models/attendance.dart
- lib/app/data/models/menu.dart
- lib/app/data/models/feedback.dart
- lib/app/data/models/billing.dart
- lib/app/data/models/student.dart

High-level model map:
- auth_models.dart: users, roles/status, signup requests, student/staff/admin profile models, auth result contracts
- attendance.dart: attendance records and meal type semantics
- menu.dart: menu items, templates, meal rates, nutrition and schedule contracts
- feedback.dart: feedback entities and response/status fields
- billing.dart: monthly bill and line-item records
- student.dart: lightweight student DTO used in student module transformations

## 11. End-to-End Flow Summaries

## 11.1 Student onboarding to approved login

1. Student signs up
2. Pending Firebase auth account + student request created
3. Admin sees request in overview pending list
4. Admin approves request
5. AppUser and StudentDetails records created
6. Student logs in with original signup password

## 11.2 Attendance marking to student visibility

1. Staff marks attendance in staff attendance page
2. Attendance record persisted
3. Student attendance pages load/calculate from attendance records
4. Billing computations consume attendance + meal rates

## 11.3 Feedback loop

1. Student submits feedback from student feedback page
2. Feedback appears in admin feedback management page
3. Admin writes response and sets status
4. Student feedback card shows admin response

## 12. Notable Coupling and Constraints

Key coupling points:
- AuthController and UserController for session/user data synchronization
- StudentController depends on MenuService and UserService for most page data
- StaffController mixes service data with DummyDataService fallback/menu rate data
- Admin overview depends on pending request streams and user aggregation queries

Current constraints or checks to keep in mind:
- Route constant set is broader than registered GetPages; keep constants and route table aligned
- Some analytics and activity views still contain placeholder/static values
- Legacy admin approval controller exists in auth module while active approval flow is also in admin overview

## 13. Full File Inventory in Scope

## 13.1 Authentication module files

- lib/app/modules/auth/splash_screen.dart
- lib/app/modules/auth/signup_page.dart
- lib/app/modules/auth/password_reset_page.dart
- lib/app/modules/auth/login_controller.dart
- lib/app/modules/auth/landing_page.dart
- lib/app/modules/auth/enhanced_login_page.dart
- lib/app/modules/auth/controllers/auth_controller.dart
- lib/app/modules/auth/controllers/admin_approval_controller.dart
- lib/app/modules/auth/components/auth_widgets.dart
- lib/app/modules/auth/components/auth_helpers.dart
- lib/app/modules/auth/components/auth_dropdowns.dart

## 13.2 Admin module files

- lib/app/modules/admin/admin_controller.dart
- lib/app/modules/admin/controllers/user_management_controller.dart
- lib/app/modules/admin/controllers/admin_overview_controller.dart
- lib/app/modules/admin/controllers/admin_menu_controller.dart
- lib/app/modules/admin/pages/admin_dashboard.dart
- lib/app/modules/admin/pages/admin_overview_page/admin_overview_page.dart
- lib/app/modules/admin/pages/admin_overview_page/components/system_stats_grid.dart
- lib/app/modules/admin/pages/admin_overview_page/components/recent_activity_card.dart
- lib/app/modules/admin/pages/admin_overview_page/components/quick_actions_card.dart
- lib/app/modules/admin/pages/admin_overview_page/components/pending_approvals_card.dart
- lib/app/modules/admin/pages/feedback_management/admin_feedback_management_page.dart
- lib/app/modules/admin/pages/menu_management/admin_menu_management_page.dart
- lib/app/modules/admin/pages/menu_management/components/nutrition_analytics.dart
- lib/app/modules/admin/pages/menu_management/components/menu_tab_bar.dart
- lib/app/modules/admin/pages/menu_management/components/menu_item_dialog.dart
- lib/app/modules/admin/pages/menu_management/components/menu_item_card.dart
- lib/app/modules/admin/pages/menu_management/components/menu_header.dart
- lib/app/modules/admin/pages/menu_management/components/menu_filters.dart
- lib/app/modules/admin/pages/menu_management/components/category_card.dart
- lib/app/modules/admin/pages/user_managemnt/admin_user_management_page.dart
- lib/app/modules/admin/pages/user_managemnt/components/user_filters.dart
- lib/app/modules/admin/pages/user_managemnt/components/user_empty_state.dart
- lib/app/modules/admin/pages/user_managemnt/components/user_card.dart
- lib/app/modules/admin/pages/user_managemnt/components/users_list.dart
- lib/app/modules/admin/pages/user_managemnt/components/add_user_dialog.dart

## 13.3 Student module files

- lib/app/modules/student/student_controller.dart
- lib/app/modules/student/pages/enhanced_student_dashboard.dart
- lib/app/modules/student/pages/student_home_page/student_home_page.dart
- lib/app/modules/student/pages/student_home_page/components/welcome_card.dart
- lib/app/modules/student/pages/student_home_page/components/todays_menu_card.dart
- lib/app/modules/student/pages/student_home_page/components/todays_attendance_card.dart
- lib/app/modules/student/pages/student_home_page/components/recent_activity_card.dart
- lib/app/modules/student/pages/student_home_page/components/quick_stats_grid.dart
- lib/app/modules/student/pages/student_home_page/components/quick_actions_card.dart
- lib/app/modules/student/pages/student_view_attendance/student_attendance_page.dart
- lib/app/modules/student/pages/student_view_attendance/components/meal_attendance_card.dart
- lib/app/modules/student/pages/student_view_attendance/components/day_details_card.dart
- lib/app/modules/student/pages/student_view_attendance/components/attendance_stats_card.dart
- lib/app/modules/student/pages/student_view_attendance/components/attendance_calendar_card.dart
- lib/app/modules/student/pages/student_biling_page/student_billing_page.dart
- lib/app/modules/student/pages/student_biling_page/components/payment_history_card.dart
- lib/app/modules/student/pages/student_biling_page/components/meal_rates_card.dart
- lib/app/modules/student/pages/student_biling_page/components/meal_count_cards.dart
- lib/app/modules/student/pages/student_biling_page/components/current_bill_card.dart
- lib/app/modules/student/pages/student_view_menu/student_menu_page.dart
- lib/app/modules/student/pages/student_view_menu/components/week_navigator.dart
- lib/app/modules/student/pages/student_view_menu/components/nutritional_info_card.dart
- lib/app/modules/student/pages/student_view_menu/components/nutritional_card.dart
- lib/app/modules/student/pages/student_view_menu/components/menu_page_header.dart
- lib/app/modules/student/pages/student_view_menu/components/menu_content_card.dart
- lib/app/modules/student/pages/student_view_menu/components/meal_tab_content.dart
- lib/app/modules/student/pages/student_view_menu/components/meal_header.dart
- lib/app/modules/student/pages/student_view_menu/components/meal_details.dart
- lib/app/modules/student/pages/student_view_menu/components/attendance_status.dart
- lib/app/modules/student/pages/feedback_page/student_feedback_page.dart
- lib/app/modules/student/pages/feedback_page/components/recent_feedbacks.dart
- lib/app/modules/student/pages/feedback_page/components/feedback_form.dart
- lib/app/modules/student/pages/feedback_page/components/feedback_card.dart

## 13.4 Staff module files

- lib/app/modules/staff/staff_controller.dart
- lib/app/modules/staff/controllers/staff_student_controller.dart
- lib/app/modules/staff/pages/staff_dashboard.dart
- lib/app/modules/staff/pages/staff_overviewPage/staff_overview_page.dart
- lib/app/modules/staff/pages/staff_overviewPage/components/welcome_section.dart
- lib/app/modules/staff/pages/staff_overviewPage/components/today_stats_section.dart
- lib/app/modules/staff/pages/staff_overviewPage/components/stat_card.dart
- lib/app/modules/staff/pages/staff_overviewPage/components/recent_activity_section.dart
- lib/app/modules/staff/pages/staff_overviewPage/components/quick_actions_section.dart
- lib/app/modules/staff/pages/staff_overviewPage/components/activity_item.dart
- lib/app/modules/staff/pages/staff_overviewPage/components/action_card.dart
- lib/app/modules/staff/pages/staff_mark_attendance/staff_attendance_page.dart
- lib/app/modules/staff/pages/staff_mark_attendance/components/student_card.dart
- lib/app/modules/staff/pages/staff_mark_attendance/components/students_list_view.dart
- lib/app/modules/staff/pages/staff_mark_attendance/components/search_and_filter_row.dart
- lib/app/modules/staff/pages/staff_mark_attendance/components/quick_actions_row.dart
- lib/app/modules/staff/pages/staff_mark_attendance/components/meal_selector_card.dart
- lib/app/modules/staff/pages/staff_mark_attendance/components/calendar_view.dart
- lib/app/modules/staff/pages/staff_mark_attendance/components/attendance_marking_view.dart
- lib/app/modules/staff/pages/student_report/staff_student_management_page.dart
- lib/app/modules/staff/pages/student_report/components/student_stats_tab.dart
- lib/app/modules/staff/pages/student_report/components/student_list_tile.dart
- lib/app/modules/staff/pages/student_report/components/student_details_dialog.dart
- lib/app/modules/staff/pages/student_report/components/student_card.dart
- lib/app/modules/staff/pages/student_report/components/students_list_view.dart
- lib/app/modules/staff/pages/student_report/components/students_grid_view.dart
- lib/app/modules/staff/pages/student_report/components/stat_card.dart
- lib/app/modules/staff/pages/student_report/components/stats_cards_grid.dart
- lib/app/modules/staff/pages/student_report/components/recent_activities_list.dart
- lib/app/modules/staff/pages/student_report/components/management_tab_selector.dart
- lib/app/modules/staff/pages/student_report/components/active_students_tab.dart

## 13.5 User/session module files

- lib/app/modules/user/user_controller.dart

## 13.6 Models, services, routes, bindings

- lib/app/data/models/student.dart
- lib/app/data/models/menu.dart
- lib/app/data/models/feedback.dart
- lib/app/data/models/billing.dart
- lib/app/data/models/auth_models.dart
- lib/app/data/models/attendance.dart
- lib/app/data/services/user_test_data_service.dart
- lib/app/data/services/user_service.dart
- lib/app/data/services/menu_service.dart
- lib/app/data/services/dummy_data_service.dart
- lib/app/data/services/auth_service.dart
- lib/app/routes/app_routes.dart
- lib/app/routes/app_pages.dart
- lib/app/bindings/initial_binding.dart

## 14. Practical Documentation Use

This document can be used as:
- Developer onboarding map for role-based modules
- Refactoring impact guide (controller/service/model coupling)
- QA checklist base for auth and approval regression testing
- Product documentation source for module ownership and user flows

