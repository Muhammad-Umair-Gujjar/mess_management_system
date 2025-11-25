import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'auth_controller.dart';
import '../../data/models/feedback.dart';

class SimpleLoginPage extends StatelessWidget {
  const SimpleLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFF), Color(0xFFE0E7FF)],
          ),
        ),
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0061FF), Color(0xFF00C6FF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.utensils,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'MessMaster',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Smart Meal Attendance & Billing System',
                  style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Login Buttons
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Initialize AuthController and login
                      final authController = Get.put(AuthController());
                      authController.login(UserRole.student, 'Ali Ahmed');
                    },
                    icon: const Icon(FontAwesomeIcons.graduationCap),
                    label: const Text('Login as Student'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0061FF),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: Color(0xFF0061FF).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Initialize AuthController and login as staff
                      final authController = Get.put(AuthController());
                      authController.login(UserRole.staff, 'John Smith');
                    },
                    icon: const Icon(FontAwesomeIcons.userTie),
                    label: const Text('Login as Staff'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: Color(0xFF10B981).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Initialize AuthController and login as admin
                      final authController = Get.put(AuthController());
                      authController.login(UserRole.admin, 'Admin User');
                    },
                    icon: const Icon(FontAwesomeIcons.userShield),
                    label: const Text('Login as Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: Color(0xFFEF4444).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Demo notice
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.circleInfo,
                        color: Color(0xFF3B82F6),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'This is a demo application with dummy data',
                          style: TextStyle(
                            color: Color(0xFF3B82F6),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




