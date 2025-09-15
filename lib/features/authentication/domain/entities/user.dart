import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phone;
  final String? email;
  final String firstName;
  final String lastName;
  final String? profileImage;
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
    createdAt,
    updatedAt,
    isActive,
  ];
}
