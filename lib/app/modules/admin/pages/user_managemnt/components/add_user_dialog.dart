import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_decorations.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../../../widgets/common/reusable_text_field.dart';

class AddEditUserView extends StatefulWidget {
  final bool isEditMode;
  final Map<String, dynamic>? initialUser;
  final Future<bool> Function(Map<String, dynamic>) onSubmit;
  final VoidCallback onBack;

  const AddEditUserView({
    Key? key,
    required this.isEditMode,
    this.initialUser,
    required this.onSubmit,
    required this.onBack,
  }) : super(key: key);

  @override
  State<AddEditUserView> createState() => _AddEditUserViewState();
}

class _AddEditUserViewState extends State<AddEditUserView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();
  final _hostelController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _semesterController = TextEditingController(text: '1');
  final _employeeIdController = TextEditingController();
  final _positionController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedRole = 'Student';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _seedInitialData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _hostelController.dispose();
    _roomNumberController.dispose();
    _rollNumberController.dispose();
    _semesterController.dispose();
    _employeeIdController.dispose();
    _positionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _seedInitialData() {
    final user = widget.initialUser;
    if (user == null) {
      return;
    }

    final fullName = (user['name'] ?? '').toString().trim();
    final nameParts = fullName.split(' ');
    _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
    _lastNameController.text = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';

    _emailController.text = (user['email'] ?? '').toString();
    _selectedRole = _normalizeRole((user['role'] ?? 'Student').toString());
    _departmentController.text = (user['department'] ?? '').toString();
    _rollNumberController.text = (user['rollNumber'] ?? '').toString();
    _employeeIdController.text = (user['employeeId'] ?? '').toString();
    _positionController.text = (user['position'] ?? '').toString();

    final semesterRaw = (user['semester'] ?? '').toString();
    final semesterDigits = semesterRaw.replaceAll(RegExp(r'[^0-9]'), '');
    if (semesterDigits.isNotEmpty) {
      _semesterController.text = semesterDigits;
    }

    final roomRaw = (user['roomNumber'] ?? '').toString();
    if (roomRaw.contains('-')) {
      final splitIndex = roomRaw.indexOf('-');
      _hostelController.text = roomRaw.substring(0, splitIndex).trim();
      _roomNumberController.text = roomRaw.substring(splitIndex + 1).trim();
    } else {
      _roomNumberController.text = roomRaw;
    }
  }

  String _normalizeRole(String role) {
    final lower = role.toLowerCase();
    if (lower.contains('staff')) return 'Staff';
    return 'Student';
  }

  bool get _isStudent => _selectedRole == 'Student';

  Future<void> _handleSubmit() async {
    if (_isSubmitting) {
      return;
    }

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      _showMessage('Please fill all required basic fields.');
      return;
    }

    if (_isStudent) {
      if (_rollNumberController.text.trim().isEmpty ||
          _hostelController.text.trim().isEmpty ||
          _roomNumberController.text.trim().isEmpty ||
          _departmentController.text.trim().isEmpty) {
        _showMessage('Please fill all required student fields.');
        return;
      }
    } else {
      if (_employeeIdController.text.trim().isEmpty ||
          _departmentController.text.trim().isEmpty ||
          _positionController.text.trim().isEmpty) {
        _showMessage('Please fill all required staff fields.');
        return;
      }
    }

    final payload = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': _selectedRole,
      'department': _departmentController.text.trim(),
      'phoneNumber': _phoneController.text.trim(),
      'hostel': _hostelController.text.trim(),
      'roomNumber': _roomNumberController.text.trim(),
      'rollNumber': _rollNumberController.text.trim(),
      'semester': int.tryParse(_semesterController.text.trim()) ?? 1,
      'employeeId': _employeeIdController.text.trim(),
      'position': _positionController.text.trim(),
    };

    if (widget.isEditMode && widget.initialUser != null) {
      payload['id'] = widget.initialUser!['id'];
    }

    setState(() => _isSubmitting = true);
    final success = await widget.onSubmit(payload);
    if (!mounted) {
      return;
    }

    if (!success) {
      setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.floatingCard(),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context, 'large')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Go Back',
              ),
              Text(
                widget.isEditMode ? 'Edit User' : 'Add New User',
                style: AppTextStyles.heading5,
              ),
              const Spacer(),
              if (!widget.isEditMode)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getSpacing(context, 'small'),
                    vertical: ResponsiveHelper.getSpacing(context, 'xs'),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(context, 'small'),
                    ),
                  ),
                  child: Text(
                    'Default Password: 12345678',
                    style: AppTextStyles.caption.copyWith(color: AppColors.info),
                  ),
                ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ReusableTextField(
                          label: 'First Name',
                          hintText: 'Enter first name',
                          controller: _firstNameController,
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
                      Expanded(
                        child: ReusableTextField(
                          label: 'Last Name',
                          hintText: 'Enter last name',
                          controller: _lastNameController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ReusableTextField(
                          label: 'Email',
                          hintText: 'Enter email',
                          type: TextFieldType.email,
                          readOnly: widget.isEditMode,
                          controller: _emailController,
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Role',
                              style: AppTextStyles.body2.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getSpacing(
                                context,
                                'xsmall',
                              ),
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedRole,
                              decoration: const InputDecoration(
                                hintText: 'Select role',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Student',
                                  child: Text('Student'),
                                ),
                                DropdownMenuItem(
                                  value: 'Staff',
                                  child: Text('Staff'),
                                ),
                              ],
                              onChanged: widget.isEditMode
                                  ? null
                                  : (value) {
                                      if (value == null) return;
                                      setState(() => _selectedRole = value);
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
                  ReusableTextField(
                    label: 'Phone Number (Optional)',
                    hintText: 'Enter phone number',
                    type: TextFieldType.phone,
                    controller: _phoneController,
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
                  if (_isStudent) ...[
                    ReusableTextField(
                      label: 'Roll Number',
                      hintText: 'Enter roll number',
                      controller: _rollNumberController,
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
                    Row(
                      children: [
                        Expanded(
                          child: ReusableTextField(
                            label: 'Hostel',
                            hintText: 'e.g., Hostel 1',
                            controller: _hostelController,
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
                        Expanded(
                          child: ReusableTextField(
                            label: 'Room Number',
                            hintText: 'e.g., A-201',
                            controller: _roomNumberController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
                    Row(
                      children: [
                        Expanded(
                          child: ReusableTextField(
                            label: 'Department',
                            hintText: 'e.g., Computer Science',
                            controller: _departmentController,
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
                        Expanded(
                          child: ReusableTextField(
                            label: 'Semester',
                            hintText: 'e.g., 1',
                            type: TextFieldType.number,
                            controller: _semesterController,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    ReusableTextField(
                      label: 'Employee ID',
                      hintText: 'Enter employee id',
                      controller: _employeeIdController,
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
                    ReusableTextField(
                      label: 'Department',
                      hintText: 'e.g., Kitchen',
                      controller: _departmentController,
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
                    ReusableTextField(
                      label: 'Position',
                      hintText: 'e.g., Mess Manager',
                      controller: _positionController,
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          Row(
            children: [
              Expanded(
                child: ReusableButton(
                  text: 'Back',
                  type: ButtonType.outline,
                  size: ButtonSize.medium,
                  onPressed: widget.onBack,
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context, 'small')),
              Expanded(
                child: ReusableButton(
                  text: widget.isEditMode ? 'Save Changes' : 'Add User',
                  type: ButtonType.primary,
                  size: ButtonSize.medium,
                  isLoading: _isSubmitting,
                  onPressed: _handleSubmit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




