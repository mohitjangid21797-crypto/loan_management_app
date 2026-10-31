import 'package:flutter_test/flutter_test.dart';
import 'package:loan_management_app/models/lender.dart';

void main() {
  test('profile image path survives lender serialization', () {
    final lender = Lender(
      id: 'lender-1',
      name: 'Test Lender',
      mobileNumber: '9876543210',
      email: 'lender@example.com',
      address: 'Office',
      licenseNumber: 'LIC-1',
      profileImagePath: '/documents/profile_photos/profile_lender-1.jpg',
      createdAt: DateTime(2026, 1, 1),
    );

    final restored = Lender.fromJson(lender.toJson());

    expect(restored.profileImagePath, lender.profileImagePath);
    expect(restored.name, lender.name);
  });

  test('older lender records without a profile image remain compatible', () {
    final lender = Lender.fromJson({
      'id': 'lender-1',
      'name': 'Test Lender',
      'mobileNumber': '9876543210',
      'email': 'lender@example.com',
      'address': 'Office',
      'licenseNumber': 'LIC-1',
      'createdAt': DateTime(2026, 1, 1).toIso8601String(),
    });

    expect(lender.profileImagePath, isNull);
  });
}
