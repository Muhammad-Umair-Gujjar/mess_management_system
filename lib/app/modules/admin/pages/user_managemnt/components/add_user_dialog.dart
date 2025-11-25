import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/toast_message.dart';
import '../../../../../../core/utils/responsive_helper.dart';
import '../../../../../widgets/common/reusable_button.dart';
import '../../../../../widgets/common/reusable_text_field.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({Key? key}) : super(key: key);

  static void show() {
    Get.dialog(
      AlertDialog(
        title: const Text('Add New User'),
        content: const AddUserDialog(),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ReusableButton(
            text: 'Add User',
            type: ButtonType.primary,
            size: ButtonSize.small,
            onPressed: () {
              Get.back();
              ToastMessage.success('User added successfully');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.getContainerWidthFromConfig(
        context,
        'dialogWidth',
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ReusableTextField(
            label: 'Full Name',
            hintText: 'Enter full name',
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          const ReusableTextField(
            label: 'Email',
            type: TextFieldType.email,
            hintText: 'Enter email address',
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Role',
              border: OutlineInputBorder(),
            ),
            items: ['Student', 'Staff'].map((role) {
              return DropdownMenuItem(value: role, child: Text(role));
            }).toList(),
            onChanged: (value) {},
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          const ReusableTextField(
            label: 'Room Number (for students)',
            hintText: 'e.g., A-201',
          ),
        ],
      ),
    );
  }
}




