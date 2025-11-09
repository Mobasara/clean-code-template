class UserEntity {
  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.isEmailVerified,
  });

  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final bool isEmailVerified;
}
