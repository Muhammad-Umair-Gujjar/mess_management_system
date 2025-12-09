import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mess_management/app/modules/auth/controllers/auth_controller.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/services/auth_service.dart';

/// Controller for managing student approval requests in admin dashboard
class AdminApprovalController extends GetxController {
  static AdminApprovalController get instance => Get.find();

  final AuthService _authService = AuthService();

  // Observable variables
  final isLoading = false.obs;
  final pendingRequests = <StudentRequest>[].obs;
  final selectedRequest = Rxn<StudentRequest>();

  // Form controllers for rejection
  final rejectionReasonController = TextEditingController();
  final isProcessingRequest = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPendingRequests();
  }

  @override
  void onClose() {
    rejectionReasonController.dispose();
    super.onClose();
  }

  /// Load pending student requests
  void _loadPendingRequests() {
    _authService.getPendingStudentRequests().listen(
      (requests) {
        pendingRequests.value = requests;
        isLoading.value = false;
      },
      onError: (error) {
        Get.snackbar(
          'Error',
          'Failed to load requests: ${error.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
      },
    );
  }

  /// Show request details
  void viewRequestDetails(StudentRequest request) {
    selectedRequest.value = request;
    Get.dialog(_buildRequestDetailsDialog(request), barrierDismissible: true);
  }

  /// Approve student request
  Future<void> approveRequest(String requestId) async {
    if (isProcessingRequest.value) return;

    isProcessingRequest.value = true;

    try {
      final currentUser = AuthController.instance.currentUser.value;
      if (currentUser == null) {
        throw Exception('Admin not authenticated');
      }

      final success = await _authService.approveStudentRequest(
        requestId,
        currentUser.uid,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Student request approved successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Remove from pending list
        pendingRequests.removeWhere((req) => req.requestId == requestId);

        if (selectedRequest.value?.requestId == requestId) {
          Get.back(); // Close dialog if open
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to approve request: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessingRequest.value = false;
    }
  }

  /// Show rejection dialog
  void showRejectDialog(String requestId) {
    rejectionReasonController.clear();

    Get.dialog(
      AlertDialog(
        title: const Text('Reject Student Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: 16),
            TextField(
              controller: rejectionReasonController,
              decoration: const InputDecoration(
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              rejectionReasonController.clear();
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _rejectRequest(requestId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  /// Reject student request
  Future<void> _rejectRequest(String requestId) async {
    if (rejectionReasonController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please provide a reason for rejection',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (isProcessingRequest.value) return;

    isProcessingRequest.value = true;

    try {
      final currentUser = AuthController.instance.currentUser.value;
      if (currentUser == null) {
        throw Exception('Admin not authenticated');
      }

      final success = await _authService.rejectStudentRequest(
        requestId,
        currentUser.uid,
        rejectionReasonController.text.trim(),
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Student request rejected successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );

        // Remove from pending list
        pendingRequests.removeWhere((req) => req.requestId == requestId);

        rejectionReasonController.clear();
        Get.back(); // Close rejection dialog

        if (selectedRequest.value?.requestId == requestId) {
          Get.back(); // Close details dialog if open
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject request: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessingRequest.value = false;
    }
  }

  /// Refresh requests
  void refreshRequests() {
    isLoading.value = true;
    _loadPendingRequests();
  }

  /// Get request count
  int get pendingRequestCount => pendingRequests.length;

  /// Build request details dialog
  Widget _buildRequestDetailsDialog(StudentRequest request) {
    return AlertDialog(
      title: Text('Student Request - ${request.fullName}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Email', request.email),
            _buildDetailRow('Roll Number', request.rollNumber),
            _buildDetailRow('Department', request.department),
            _buildDetailRow('Semester', '${request.semester}'),
            _buildDetailRow('Hostel', request.hostel),
            _buildDetailRow('Room Number', request.roomNumber),
            _buildDetailRow('Phone', request.phoneNumber),
            _buildDetailRow(
              'Requested At',
              '${request.requestedAt.day}/${request.requestedAt.month}/${request.requestedAt.year}',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        TextButton(
          onPressed: () {
            Get.back();
            showRejectDialog(request.requestId);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Reject'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            approveRequest(request.requestId);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Approve'),
        ),
      ],
    );
  }

  /// Build detail row widget
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
