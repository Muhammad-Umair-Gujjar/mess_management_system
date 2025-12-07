class AppRoutes {
  static const String INITIAL = '/';
  static const String LOGIN = '/login';
  static const String SIGNUP = '/signup';
  static const String PASSWORD_RESET = '/password-reset';

  // Student routes
  static const String STUDENT_DASHBOARD = '/student/dashboard';
  static const String STUDENT_PROFILE = '/student/profile';
  static const String STUDENT_MESS = '/student/mess';
  static const String STUDENT_FEEDBACK = '/student/feedback';
  static const String STUDENT_HOME = '/student/home';
  static const String STUDENT_ATTENDANCE = '/student/attendance';
  static const String STUDENT_BILLING = '/student/billing';
  static const String STUDENT_MENU = '/student/menu';

  // Staff routes
  static const String STAFF_DASHBOARD = '/staff/dashboard';
  static const String STAFF_PROFILE = '/staff/profile';
  static const String STAFF_MESS = '/staff/mess';
  static const String STAFF_REPORTS = '/staff/reports';
  static const String STAFF_HOME = '/staff/home';
  static const String STAFF_ATTENDANCE = '/staff/attendance';

  // Admin routes
  static const String ADMIN_DASHBOARD = '/admin/dashboard';
  static const String ADMIN_PROFILE = '/admin/profile';
  static const String ADMIN_USER_MANAGEMENT = '/admin/users';
  static const String ADMIN_STUDENT_APPROVAL = '/admin/student-approval';
  static const String ADMIN_REPORTS = '/admin/reports';
  static const String ADMIN_SETTINGS = '/admin/settings';
  static const String ADMIN_HOME = '/admin/home';
  static const String ADMIN_OVERVIEW = '/admin/overview';
  static const String ADMIN_RATES = '/admin/rates';
  static const String ADMIN_MENU = '/admin/menu';
  static const String ADMIN_APPROVALS = '/admin/approvals';
  static const String ADMIN_ANALYTICS = '/admin/analytics';

  // Common routes
  static const String SETTINGS = '/settings';
  static const String NOTIFICATIONS = '/notifications';

  // Legacy routes for backward compatibility
  static const String splash = INITIAL;
  static const String login = LOGIN;
  static const String studentDashboard = STUDENT_DASHBOARD;
  static const String staffDashboard = STAFF_DASHBOARD;
  static const String adminDashboard = ADMIN_DASHBOARD;
  static const String studentHome = STUDENT_HOME;
  static const String studentAttendance = STUDENT_ATTENDANCE;
  static const String studentBilling = STUDENT_BILLING;
  static const String studentMenu = STUDENT_MENU;
  static const String studentFeedback = STUDENT_FEEDBACK;
  static const String staffHome = STAFF_HOME;
  static const String staffAttendance = STAFF_ATTENDANCE;
  static const String staffReports = STAFF_REPORTS;
  static const String adminHome = ADMIN_HOME;
  static const String adminOverview = ADMIN_OVERVIEW;
  static const String adminRates = ADMIN_RATES;
  static const String adminMenu = ADMIN_MENU;
  static const String adminApprovals = ADMIN_APPROVALS;
  static const String adminAnalytics = ADMIN_ANALYTICS;
}
