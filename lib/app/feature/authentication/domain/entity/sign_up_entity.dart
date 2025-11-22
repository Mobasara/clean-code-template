import 'package:equatable/equatable.dart';

class SignUpEntity extends Equatable {
  const SignUpEntity({
    required this.email,
    required this.fullName,
    required this.password,
    required this.phoneNumber,
  });

  final String email;
  final String fullName;
  final String password;
  final String phoneNumber;

  @override
  List<Object?> get props => [email, fullName, password, phoneNumber];
}