import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
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

   @override
  List<Object?> get props => [id, name, email, phoneNumber, isEmailVerified];
}
