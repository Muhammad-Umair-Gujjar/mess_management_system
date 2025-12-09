import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/auth_models.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import 'components/auth_helpers.dart';
import '../../../core/utils/toast_message.dart';
import '../user/user_controller.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final AuthService _authService = AuthService();

  // Form keys
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>(
    debugLabel: 'loginForm',
  );
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(
    debugLabel: 'signupForm',
  );

  // Text controllers - Initialize in constructor to avoid null issues
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController rollNumberController;
  late final TextEditingController hostelController;
  late final TextEditingController roomNumberController;

  // Constructor to initialize controllers
  AuthController() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    rollNumberController = TextEditingController();
    hostelController = TextEditingController();
    roomNumberController = TextEditingController();
  }

  // Observable state variables
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final currentUser = Rxn<AppUser>();
  final isAuthenticated = false.obs;
  final selectedUserRole = UserRole.student.obs;
  final selectedRole = UserRole.student.obs; // For backward compatibility
  final rememberMe = false.obs;
  final selectedDepartment = 'Computer Science'.obs;
  final selectedSemester = 1.obs;
  final selectedHostel = 'Hostel 1'.obs;
  final isLoggingOut =
      false.obs; // Flag to prevent auth state navigation during logout

  // Form validation errors
  final emailError = RxnString();
  final passwordError = RxnString();
  final confirmPasswordError = RxnString();
  final firstNameError = RxnString();
  final lastNameError = RxnString();
  final rollNumberError = RxnString();
  final roomNumberError = RxnString();

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
    _setupDefaultAccounts();
  }

  @override
  void onClose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    rollNumberController.dispose();
    hostelController.dispose();
    roomNumberController.dispose();
    super.onClose();
  }

  /// Setup default admin and staff accounts
  Future<void> _setupDefaultAccounts() async {
    try {
      print('🔵 DEBUG: Setting up default accounts...');

      // Setup default admin account
      await _authService.createDefaultStaffAccount(
        email: 'gujjar@gmail.com',
        password: '12345678',
        firstName: 'Admin',
        lastName: 'User',
        role: UserRole.admin,
        department: 'Administration',
      );

      // Setup default staff account
      await _authService.createDefaultStaffAccount(
        email: 'staff@gmail.com',
        password: '12345678',
        firstName: 'Staff',
        lastName: 'User',
        role: UserRole.staff,
        department: 'Kitchen',
      );

      print('✅ DEBUG: Default accounts setup completed');
    } catch (e) {
      print('⚠️ DEBUG: Default accounts setup error (might already exist): $e');
    }
  }

  /// Check authentication state on app start
  void _checkAuthState() {
    _authService.authStateChanges.listen((firebaseUser) async {
      // Ignore auth state changes during logout
      if (isLoggingOut.value) {
        return;
      }

      // Only handle auth state changes if we're not already authenticated
      // This prevents double navigation on login
      if (firebaseUser != null && !isAuthenticated.value) {
        final user = await _authService.currentUser;
        if (user != null && user.isActive) {
          currentUser.value = user;
          isAuthenticated.value = true;
          // Don't navigate here as _navigateBasedOnRole will handle it
        } else {
          currentUser.value = null;
          isAuthenticated.value = false;
        }
      } else if (firebaseUser == null) {
        currentUser.value = null;
        isAuthenticated.value = false;
      }
    });
  }

  /// Student Signup
  Future<void> studentSignup() async {
    print('🔵 DEBUG: studentSignup() called');

    // Skip form validation for now, do manual validation
    print('🔵 DEBUG: Doing manual validation instead of form validation');

    print('✅ DEBUG: Form validation passed');
    _clearErrors();
    isLoading.value = true;
    print('🔵 DEBUG: isLoading set to true');

    try {
      // Null safety checks
      final email = emailController.text.trim();
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final rollNumber = rollNumberController.text.trim();
      final roomNumber = roomNumberController.text.trim();

      print('🔵 DEBUG: Form data collected:');
      print('  Email: $email');
      print('  First Name: $firstName');
      print('  Last Name: $lastName');
      print('  Roll Number: $rollNumber');
      print('  Room Number: $roomNumber');
      print('  Hostel: ${selectedHostel.value}');
      print('  Department: ${selectedDepartment.value}');
      print('  Semester: ${selectedSemester.value}');

      if (email.isEmpty ||
          firstName.isEmpty ||
          lastName.isEmpty ||
          rollNumber.isEmpty) {
        print('❌ DEBUG: Required fields are empty');
        throw Exception('All required fields must be filled');
      }

      // Validate email format
      final emailValidation = AuthValidator.validateEmail(email);
      if (emailValidation != null) {
        print('❌ DEBUG: Email validation failed: $emailValidation');
        throw Exception(emailValidation);
      }

      // Validate password
      final password = passwordController.text.trim();
      final passwordValidation = AuthValidator.validatePassword(password);
      if (passwordValidation != null) {
        print('❌ DEBUG: Password validation failed: $passwordValidation');
        throw Exception(passwordValidation);
      }

      // Validate names
      final firstNameValidation = AuthValidator.validateName(
        firstName,
        'First name',
      );
      if (firstNameValidation != null) {
        print('❌ DEBUG: First name validation failed: $firstNameValidation');
        throw Exception(firstNameValidation);
      }

      final lastNameValidation = AuthValidator.validateName(
        lastName,
        'Last name',
      );
      if (lastNameValidation != null) {
        print('❌ DEBUG: Last name validation failed: $lastNameValidation');
        throw Exception(lastNameValidation);
      }

      // Validate roll number
      final rollNumberValidation = AuthValidator.validateRollNumber(rollNumber);
      if (rollNumberValidation != null) {
        print('❌ DEBUG: Roll number validation failed: $rollNumberValidation');
        throw Exception(rollNumberValidation);
      }

      print('🔵 DEBUG: Creating StudentSignupRequest...');
      final request = StudentSignupRequest(
        email: email,
        firstName: firstName,
        lastName: lastName,
        rollNumber: rollNumber,
        hostel: selectedHostel.value,
        roomNumber: roomNumberController.text.trim(),
        phoneNumber: '', // Not required anymore
        department: selectedDepartment.value,
        semester: selectedSemester.value,
      );

      print('✅ DEBUG: StudentSignupRequest created successfully');
      print('🔵 DEBUG: Calling _authService.studentSignup...');

      final result = await _authService.studentSignup(request);

      print('🔵 DEBUG: _authService.studentSignup completed');
      print('  Result success: ${result.success}');
      print('  Result type: ${result.type}');
      print('  Result message: ${result.errorMessage}');
      print('  Result user: ${result.user}');

      if (result.success) {
        ToastMessage.success(
          'Signup request submitted successfully! Wait for admin approval.',
        );
        _clearForm();
        Get.offAllNamed(AppRoutes.LOGIN);
      } else if (result.type == AuthResultType.pending) {
        // Handle pending as success for user experience
        ToastMessage.success(
          result.errorMessage ??
              'Your signup request has been submitted and is pending approval.',
        );
        _clearForm();
        Get.offAllNamed(AppRoutes.LOGIN);
      } else {
        ToastMessage.error(result.errorMessage ?? 'Signup failed');
      }
    } on Exception catch (e) {
      print('❌ DEBUG: Exception in studentSignup: ${e.toString()}');
      ToastMessage.error(e.toString().replaceAll('Exception: ', ''));
    } catch (e) {
      print('❌ DEBUG: General error in studentSignup: ${e.toString()}');
      ToastMessage.error('Signup failed: ${e.toString()}');
    } finally {
      print(
        '🔵 DEBUG: studentSignup finally block - setting isLoading to false',
      );
      isLoading.value = false;
    }
  }

  /// Login (handles all roles)
  Future<void> login() async {
    // Skip form validation for now, do manual validation
    _clearErrors();
    isLoading.value = true;

    try {
      AuthResult result;
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      print('🔵 DEBUG: Login data:');
      print('  Email: $email');
      print('  Password: ${password.isNotEmpty ? "[PROVIDED]" : "[EMPTY]"}');
      print('  Selected Role: ${selectedUserRole.value}');

      if (email.isEmpty || password.isEmpty) {
        print('❌ DEBUG: Email or password is empty');
        throw Exception('Email and password are required');
      }

      // Validate email format
      final emailValidation = AuthValidator.validateEmail(email);
      if (emailValidation != null) {
        print('❌ DEBUG: Email validation failed: $emailValidation');
        throw Exception(emailValidation);
      }

      // Validate password
      final passwordValidation = AuthValidator.validatePassword(password);
      if (passwordValidation != null) {
        print('❌ DEBUG: Password validation failed: $passwordValidation');
        throw Exception(passwordValidation);
      }

      print('🔵 DEBUG: Determining login type...');
      if (selectedUserRole.value == UserRole.student) {
        print('🔵 DEBUG: Calling studentLogin...');
        result = await _authService.studentLogin(email, password);
      } else {
        print('🔵 DEBUG: Calling staffAdminLogin...');
        result = await _authService.staffAdminLogin(
          email,
          password,
          selectedUserRole.value,
        );
      }

      print('🔵 DEBUG: Login service call completed');
      print('  Result success: ${result.success}');
      print('  Result type: ${result.type}');
      print('  Result message: ${result.errorMessage}');
      print('  Result user: ${result.user}');

      if (result.success && result.user != null) {
        currentUser.value = result.user;
        isAuthenticated.value = true;

        // Initialize UserController and set user data for global access
        final userController = Get.put(UserController());
        await userController.setUserData(result.user!);

        ToastMessage.success('Login successful! Welcome back.');

        _clearForm();
        _navigateBasedOnRole(result.user!.role);
      } else {
        String errorMessage = result.errorMessage ?? 'Login failed';

        if (result.type == AuthResultType.pending) {
          ToastMessage.warning(
            'Your account is pending admin approval. Please wait.',
          );
        } else {
          ToastMessage.error(errorMessage);
        }
      }
    } on Exception catch (e) {
      ToastMessage.error(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      isLoggingOut.value = true; // Set flag to prevent auth state navigation

      await _authService.signOut();
      currentUser.value = null;
      isAuthenticated.value = false;

      // Clear UserController data
      if (Get.isRegistered<UserController>()) {
        Get.find<UserController>().clearUserData();
      }

      _clearForm();

      // Reset the flag after a short delay and then navigate
      Future.delayed(const Duration(milliseconds: 100), () {
        isLoggingOut.value = false;
        // Navigate directly to login page, skipping splash screen
        Get.offAllNamed('/login');
      });
    } catch (e) {
      isLoggingOut.value = false;
      ToastMessage.error('Logout failed: ${e.toString()}');
    }
  }

  /// Send password reset email
  Future<void> resetPassword({
    required String email,
    required VoidCallback onSuccess,
  }) async {
    if (email.trim().isEmpty) {
      ToastMessage.error('Please enter your email');
      return;
    }

    if (!AuthValidator.isValidEmail(email.trim())) {
      ToastMessage.error('Please enter a valid email');
      return;
    }

    isLoading.value = true;

    try {
      await _authService.sendPasswordResetEmail(email.trim());
      ToastMessage.success('Password reset email sent successfully!');
      onSuccess(); // Call the success callback
    } catch (e) {
      ToastMessage.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate based on user role
  void _navigateBasedOnRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        Get.offAllNamed(AppRoutes.STUDENT_DASHBOARD);
        break;
      case UserRole.staff:
        Get.offAllNamed(AppRoutes.STAFF_DASHBOARD);
        break;
      case UserRole.admin:
        Get.offAllNamed(AppRoutes.ADMIN_DASHBOARD);
        break;
    }
  }

  /// Clear form fields
  void _clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    rollNumberController.clear();
    hostelController.clear();
    roomNumberController.clear();
    _clearErrors();
  }

  /// Clear validation errors
  void _clearErrors() {
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    firstNameError.value = null;
    lastNameError.value = null;
    rollNumberError.value = null;
    roomNumberError.value = null;
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  /// Validate individual fields
  String? validateEmail(String? value) {
    final error = AuthValidator.validateEmail(value);
    emailError.value = error;
    return error;
  }

  String? validatePassword(String? value) {
    final error = AuthValidator.validatePassword(value);
    passwordError.value = error;
    return error;
  }

  String? validateConfirmPassword(String? value) {
    final error = AuthValidator.validateConfirmPassword(
      value,
      passwordController.text,
    );
    confirmPasswordError.value = error;
    return error;
  }

  String? validateFirstName(String? value) {
    final error = AuthValidator.validateName(value, 'First name');
    firstNameError.value = error;
    return error;
  }

  String? validateLastName(String? value) {
    final error = AuthValidator.validateName(value, 'Last name');
    lastNameError.value = error;
    return error;
  }

  String? validateRollNumber(String? value) {
    final error = AuthValidator.validateRollNumber(value);
    rollNumberError.value = error;
    return error;
  }

  String? validateRoomNumber(String? value) {
    final error = AuthValidator.validateRoomNumber(value);
    roomNumberError.value = error;
    return error;
  }

  // Update selection methods
  void updateUserRole(UserRole role) {
    selectedUserRole.value = role;
  }

  void updateDepartment(String department) {
    selectedDepartment.value = department;
  }

  void updateSemester(int semester) {
    selectedSemester.value = semester;
  }

  void updateHostel(String hostel) {
    selectedHostel.value = hostel;
  }

  // Backward compatibility methods
  void updateRole(UserRole role) {
    selectedRole.value = role;
    selectedUserRole.value = role;
  }

  void updateRememberMe(bool value) {
    rememberMe.value = value;
  }

  // Login method with credentials for enhanced_login_page compatibility
  Future<void> loginWithCredentials({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    emailController.text = email;
    passwordController.text = password;
    selectedUserRole.value = role;
    selectedRole.value = role;

    await login();
  }

  // SignUp method for signup_page compatibility
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String rollNo,
    required String email,
    required String password,
    required String confirmPassword,
    required String hostel,
    required String roomNumber,
  }) async {
    print('🔵 DEBUG: signUp() wrapper called');
    print('  First Name: $firstName');
    print('  Last Name: $lastName');
    print('  Roll No: $rollNo');
    print('  Email: $email');
    print('  Password: ${password.isNotEmpty ? "[PROVIDED]" : "[EMPTY]"}');
    print(
      '  Confirm Password: ${confirmPassword.isNotEmpty ? "[PROVIDED]" : "[EMPTY]"}',
    );
    print('  Hostel: $hostel');
    print('  Room Number: $roomNumber');

    firstNameController.text = firstName;
    lastNameController.text = lastName;
    rollNumberController.text = rollNo;
    emailController.text = email;
    passwordController.text = password;
    confirmPasswordController.text = confirmPassword;
    selectedHostel.value = hostel;
    roomNumberController.text = roomNumber;

    print('🔵 DEBUG: Controllers set, calling studentSignup()...');
    await studentSignup();
  }
}
