class Contact {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String company;
  final DateTime createdAt;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.company,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'company': company,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      company: map['company'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String get fullName => '$firstName $lastName';
  
  Contact copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? company,
    DateTime? createdAt,
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}