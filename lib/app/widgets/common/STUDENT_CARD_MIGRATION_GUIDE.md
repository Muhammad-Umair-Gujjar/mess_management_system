# Student Card Migration Guide

## Overview
This guide shows how to migrate from separate StudentCard components to the unified `UnifiedStudentCard` component that supports multiple card types with consistent styling and behavior.

## UnifiedStudentCard Features

### Card Types
- **`StudentCardType.details`**: Shows detailed student information with "View Details" button
- **`StudentCardType.attendance`**: Shows attendance status with Present/Absent toggle buttons  
- **`StudentCardType.simple`**: Basic student information display only

### Responsive Design
- Automatically adapts spacing and sizing based on card type
- Consistent animations across all variants
- Proper mobile/tablet/desktop responsive behavior

## Migration Examples

### 1. Student Report Card (Details Type)

**Before** (`student_report/components/student_card.dart`):
```dart
return StudentCard(
  student: student,
  index: index,
  controller: controller,
);
```

**After** (using UnifiedStudentCard):
```dart
return UnifiedStudentCard(
  student: student,
  index: index,
  type: StudentCardType.details,
  onViewDetails: () => StudentDetailsDialog.show(context, student),
);
```

### 2. Mark Attendance Card (Attendance Type)

**Before** (`staff_mark_attendance/components/student_card.dart`):
```dart
return StudentCard(
  student: student,
  controller: controller,
  index: index,
  selectedMeal: selectedMeal,
  selectedDay: selectedDay,
);
```

**After** (using UnifiedStudentCard):
```dart
return UnifiedStudentCard(
  student: student,
  index: index,
  type: StudentCardType.attendance,
  isPresent: controller.isStudentPresent(
    student['id'],
    selectedMeal,
    selectedDay,
  ),
  onAttendanceChanged: (isPresent) => controller.markAttendance(
    student['id'],
    selectedMeal,
    selectedDay,
    isPresent,
  ),
);
```

### 3. Simple Student Display

**New** (for basic student lists):
```dart
return UnifiedStudentCard(
  student: student,
  index: index,
  type: StudentCardType.simple,
);
```

## Implementation Steps

### Step 1: Add Import
```dart
import '../../../widgets/common/unified_student_card.dart';
```

### Step 2: Replace StudentCard Usage
Update all StudentCard instances to use UnifiedStudentCard with appropriate type.

### Step 3: Update Grid/List Implementations
The UnifiedStudentCard works seamlessly with both CustomGridView and ListView implementations.

**Grid Example**:
```dart
CustomGridView(
  data: students.map((student) => GridCardData(
    title: student['name'] ?? '',
    value: student['id']?.toString() ?? '',
    icon: FontAwesomeIcons.user,
    color: AppColors.staffRole,
    customContent: UnifiedStudentCard(
      student: student,
      index: students.indexOf(student),
      type: StudentCardType.details,
      onViewDetails: () => _showStudentDetails(student),
    ),
  )).toList(),
  // ... other grid properties
)
```

**List Example**:
```dart
ListView.builder(
  itemBuilder: (context, index) => UnifiedStudentCard(
    student: students[index],
    index: index,
    type: StudentCardType.attendance,
    isPresent: _getAttendanceStatus(students[index]),
    onAttendanceChanged: (isPresent) => _markAttendance(students[index], isPresent),
  ),
)
```

## Benefits of Migration

### 1. Consistency
- ✅ Unified design language across all student card displays
- ✅ Consistent animations and interactions
- ✅ Standardized spacing and typography

### 2. Maintainability
- ✅ Single component to maintain instead of multiple variants
- ✅ Easy to add new features across all card types
- ✅ Centralized styling and behavior updates

### 3. Flexibility
- ✅ Multiple card types for different use cases
- ✅ Customizable styling with optional parameters
- ✅ Easy to extend with new card types

### 4. Responsive Design
- ✅ Proper responsive behavior across all screen sizes
- ✅ Consistent mobile/tablet/desktop adaptations
- ✅ Optimized animations for different card types

## Responsive Grid Configuration

When using with CustomGridView, use these responsive settings:

```dart
CustomGridView(
  crossAxisCount: 4,        // Desktop: 4 columns
  tabletCrossAxisCount: 3,  // Tablet: 3 columns  
  mobileCrossAxisCount: 2,  // Mobile: 2 columns
  childAspectRatio: 1.4,    // Adjust based on card content
  mobileAspectRatio: 1.2,   // Mobile-specific ratio
  tabletAspectRatio: 1.3,   // Tablet-specific ratio
)
```

## Files to Update

### Priority 1: Active Student Management
1. `lib/app/modules/staff/pages/student_report/components/student_card.dart`
2. `lib/app/modules/staff/pages/staff_mark_attendance/components/student_card.dart`

### Priority 2: Grid View Components  
3. `lib/app/modules/staff/pages/student_report/components/students_grid_view.dart`
4. `lib/app/modules/staff/pages/staff_mark_attendance/components/students_list_view.dart`

### Priority 3: List View Components
5. `lib/app/modules/staff/pages/student_report/components/students_list_view.dart`

## Testing Checklist

After migration, verify:
- [ ] Student details dialog opens correctly (details type)
- [ ] Attendance marking works properly (attendance type)  
- [ ] Responsive grid behavior (2/3/4 columns)
- [ ] Card animations and styling
- [ ] Touch interactions and button responses
- [ ] Proper data display (name, ID, room, email)

---

This unified approach will significantly improve code maintainability while ensuring consistent user experience across all student card displays in the application.