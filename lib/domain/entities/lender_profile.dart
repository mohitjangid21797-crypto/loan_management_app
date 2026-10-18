import 'package:equatable/equatable.dart';

/// The single lender who owns this device's data.
class LenderProfile extends Equatable {
  const LenderProfile({
    required this.id,
    required this.name,
    required this.currencySymbol,
    required this.defaultRatePercent,
    required this.createdAt,
    required this.updatedAt,
    this.photoPath,
  });

  /// Fixed id of the single profile row.
  static const String singleId = 'lender';

  final String id;
  final String name;
  final String? photoPath;
  final String currencySymbol;
  final double defaultRatePercent;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    photoPath,
    currencySymbol,
    defaultRatePercent,
    createdAt,
    updatedAt,
  ];
}
