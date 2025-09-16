import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phone;
  final String? email;
  final String firstName;
  final String lastName;
  final String? profileImage;
  final String? password; // Add password field
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const User({
    required this.id,
    required this.phone,
    this.email,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    this.password, // Add password field
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
    id,
    phone,
    email,
    firstName,
    lastName,
    profileImage,
    password, // Add password field
    createdAt,
    updatedAt,
    isActive,
  ];
}
