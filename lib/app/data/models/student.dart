class Student {
  final String id;
  final String name;
  final String email;
  final String hostelName;
  final String roomNumber;
  final String profileImage;
  final DateTime joinDate;
  final bool isApproved;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.hostelName,
    required this.roomNumber,
    this.profileImage = '',
    required this.joinDate,
    this.isApproved = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'hostelName': hostelName,
      'roomNumber': roomNumber,
      'profileImage': profileImage,
      'joinDate': joinDate.toIso8601String(),
      'isApproved': isApproved,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      hostelName: json['hostelName'],
      roomNumber: json['roomNumber'],
      profileImage: json['profileImage'] ?? '',
      joinDate: DateTime.parse(json['joinDate']),
      isApproved: json['isApproved'] ?? true,
    );
  }

  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? hostelName,
    String? roomNumber,
    String? profileImage,
    DateTime? joinDate,
    bool? isApproved,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      hostelName: hostelName ?? this.hostelName,
      roomNumber: roomNumber ?? this.roomNumber,
      profileImage: profileImage ?? this.profileImage,
      joinDate: joinDate ?? this.joinDate,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}



