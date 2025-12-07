import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/feedback.dart';
import 'components/auth_helpers.dart';

class AuthController extends GetxController {
  // Observable state variables
  var isLoading = false.obs;
  var currentUser = Rxn<User>();
  var selectedRole = UserRole.student.obs;
  var rememberMe = false.obs;
  var acceptTerms = false.obs;

  // Form controllers
  var emailError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();
  var firstNameError = RxnString();
  var lastNameError = RxnString();
  var rollNoError = RxnString();
  var roomNumberError = RxnString();

  void login(UserRole role, String name) {
    isLoading.value = true;
    _clearErrors();

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      currentUser.value = User(
        id: '${role.name}_user',
        name: name,
        email: '${name.toLowerCase().replaceAll(' ', '.')}@university.edu',
        role: role,
      );

      isLoading.value = false;
      _navigateBasedOnRole(role);
      AuthErrorHandler.showSuccess('Welcome back, $name!');
    });
  }

  void loginWithCredentials({
    required String email,
    required String password,
    required UserRole role,
  }) {
    isLoading.value = true;
    _clearErrors();

    // Validate inputs
    final emailValidation = AuthValidator.validateEmail(email);
    final passwordValidation = AuthValidator.validatePassword(password);

    if (emailValidation != null) {
      emailError.value = emailValidation;
      isLoading.value = false;
      return;
    }

    if (passwordValidation != null) {
      passwordError.value = passwordValidation;
      isLoading.value = false;
      return;
    }

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      // Extract name from email
      String name = email
          .split('@')[0]
          .replaceAll('.', ' ')
          .split(' ')
          .map(
            (word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '',
          )
          .join(' ');

      currentUser.value = User(
        id: '${role.name}_user',
        name: name,
        email: email,
        role: role,
      );

      isLoading.value = false;
      _navigateBasedOnRole(role);
      AuthErrorHandler.showSuccess('Welcome back, $name!');
    });
  }

  void signUp({
    required String firstName,
    required String lastName,
    required String rollNo,
    required String email,
    required String password,
    required String confirmPassword,
    required String hostel,
    required String roomNumber,
  }) {
    isLoading.value = true;
    _clearErrors();

    // Validate all inputs
    if (!_validateSignUpForm(
      firstName,
      lastName,
      rollNo,
      email,
      password,
      confirmPassword,
      roomNumber,
    )) {
      isLoading.value = false;
      return;
    }

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      // Create user account (Student role by default for signup)
      currentUser.value = User(
        id: 'student_$rollNo',
        name: '$firstName $lastName',
        email: email,
        role: UserRole.student,
      );

      isLoading.value = false;
      _navigateBasedOnRole(UserRole.student);
      AuthErrorHandler.showSuccess(
        'Account created successfully! Welcome, $firstName!',
      );
    });
  }

  void resetPassword({required String email, required VoidCallback onSuccess}) {
    isLoading.value = true;
    _clearErrors();

    // Validate email
    final emailValidation = AuthValidator.validateEmail(email);
    if (emailValidation != null) {
      emailError.value = emailValidation;
      isLoading.value = false;
      return;
    }

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      onSuccess();
      AuthErrorHandler.showSuccess(
        'Password reset instructions sent to $email',
      );
    });
  }

  void logout() {
    currentUser.value = null;
    _clearState();
    Get.offAllNamed('/login');
    AuthErrorHandler.showInfo('You have been logged out successfully');
  }

  // Update methods for reactive UI
  void updateRole(UserRole role) {
    selectedRole.value = role;
  }

  void updateRememberMe(bool value) {
    rememberMe.value = value;
  }

  void updateAcceptTerms(bool value) {
    acceptTerms.value = value;
  }

  // Convenience login method that uses current form state
  void loginWithEmail(String email, String password) {
    loginWithCredentials(
      email: email,
      password: password,
      role: selectedRole.value,
    );
  }

  // Helper methods
  void _navigateBasedOnRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        Get.offAllNamed('/student');
        break;
      case UserRole.staff:
        Get.offAllNamed('/staff');
        break;
      case UserRole.admin:
        Get.offAllNamed('/admin');
        break;
    }
  }

  void _clearErrors() {
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    firstNameError.value = null;
    lastNameError.value = null;
    rollNoError.value = null;
    roomNumberError.value = null;
  }

  void _clearState() {
    selectedRole.value = UserRole.student;
    rememberMe.value = false;
    acceptTerms.value = false;
    _clearErrors();
  }

  bool _validateSignUpForm(
    String firstName,
    String lastName,
    String rollNo,
    String email,
    String password,
    String confirmPassword,
    String roomNumber,
  ) {
    bool isValid = true;

    final firstNameValidation = AuthValidator.validateName(
      firstName,
      'first name',
    );
    if (firstNameValidation != null) {
      firstNameError.value = firstNameValidation;
      isValid = false;
    }

    final lastNameValidation = AuthValidator.validateName(
      lastName,
      'last name',
    );
    if (lastNameValidation != null) {
      lastNameError.value = lastNameValidation;
      isValid = false;
    }

    final rollNoValidation = AuthValidator.validateRollNo(rollNo);
    if (rollNoValidation != null) {
      rollNoError.value = rollNoValidation;
      isValid = false;
    }

    final emailValidation = AuthValidator.validateEmail(email);
    if (emailValidation != null) {
      emailError.value = emailValidation;
      isValid = false;
    }

    final passwordValidation = AuthValidator.validatePassword(password);
    if (passwordValidation != null) {
      passwordError.value = passwordValidation;
      isValid = false;
    }

    final confirmPasswordValidation = AuthValidator.validateConfirmPassword(
      confirmPassword,
      password,
    );
    if (confirmPasswordValidation != null) {
      confirmPasswordError.value = confirmPasswordValidation;
      isValid = false;
    }

    final roomNumberValidation = AuthValidator.validateRoomNumber(roomNumber);
    if (roomNumberValidation != null) {
      roomNumberError.value = roomNumberValidation;
      isValid = false;
    }

    return isValid;
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
