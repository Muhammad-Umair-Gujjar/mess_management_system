import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_decorations.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../student_controller.dart';
import 'components/menu_page_header.dart';
import 'components/week_navigator.dart';
import 'components/menu_content_card.dart';
import 'components/nutritional_info_card.dart';

class StudentMenuPage extends StatefulWidget {
  const StudentMenuPage({super.key});

  @override
  State<StudentMenuPage> createState() => _StudentMenuPageState();
}

class _StudentMenuPageState extends State<StudentMenuPage> {
  int selectedDay = DateTime.now().weekday - 1; // Monday is 0
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();

    return Container(
      decoration: AppDecorations.backgroundGradient(),
      child: ResponsiveHelper.buildResponsiveLayout(
        context: context,
        mobile: _buildMobileLayout(controller),
        desktop: _buildDesktopLayout(controller),
      ),
    );
  }

  Widget _buildMobileLayout(StudentController controller) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuPageHeader(controller: controller),
          WeekNavigator(
            selectedDay: selectedDay,
            onDaySelected: (index) {
              setState(() {
                selectedDay = index;
              });
            },
          ),
          MenuContentCard(
            controller: controller,
            selectedTabIndex: selectedTabIndex,
            selectedDay: selectedDay,
            onTabChanged: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(StudentController controller) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: ResponsiveHelper.getResponsivePadding(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MenuPageHeader(controller: controller),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context, 'large'),
                    ),
                    WeekNavigator(
                      selectedDay: selectedDay,
                      onDaySelected: (index) {
                        setState(() {
                          selectedDay = index;
                        });
                      },
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context, 'large'),
                    ),
                    NutritionalInfoCard(controller: controller),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: ResponsiveHelper.getResponsivePadding(context),
                child: MenuContentCard(
                  controller: controller,
                  selectedTabIndex: selectedTabIndex,
                  selectedDay: selectedDay,
                  onTabChanged: (index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




