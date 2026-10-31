import 'package:uuid/uuid.dart';

class Lender {
  final String id;
  final String name;
  final String mobileNumber;
  final String email;
  final String address;
  final String licenseNumber;
  final String? profileImagePath;
  final DateTime createdAt;

  Lender({
    String? id,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.licenseNumber,
    this.profileImagePath,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobileNumber': mobileNumber,
        'email': email,
        'address': address,
        'licenseNumber': licenseNumber,
        'profileImagePath': profileImagePath,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Lender.fromJson(Map<String, dynamic> json) => Lender(
        id: json['id'],
        name: json['name'],
        mobileNumber: json['mobileNumber'],
        email: json['email'],
        address: json['address'],
        licenseNumber: json['licenseNumber'],
        profileImagePath: json['profileImagePath'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Lender copyWith({
    String? name,
    String? mobileNumber,
    String? email,
    String? address,
    String? licenseNumber,
    String? profileImagePath,
  }) => Lender(
        id: id,
        name: name ?? this.name,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        email: email ?? this.email,
        address: address ?? this.address,
        licenseNumber: licenseNumber ?? this.licenseNumber,
        profileImagePath: profileImagePath ?? this.profileImagePath,
        createdAt: createdAt,
      );
}