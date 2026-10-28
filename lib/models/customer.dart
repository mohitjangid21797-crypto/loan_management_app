import 'package:uuid/uuid.dart';

class Customer {
  final String id;
  final String name;
  final String mobileNumber;
  final String email;
  final String location;
  final DateTime createdAt;

  Customer({
    String? id,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.location,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobileNumber': mobileNumber,
        'email': email,
        'location': location,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        name: json['name'],
        mobileNumber: json['mobileNumber'],
        email: json['email'],
        location: json['location'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Customer copyWith({
    String? name,
    String? mobileNumber,
    String? email,
    String? location,
  }) => Customer(
        id: id,
        name: name ?? this.name,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        email: email ?? this.email,
        location: location ?? this.location,
        createdAt: createdAt,
      );
}