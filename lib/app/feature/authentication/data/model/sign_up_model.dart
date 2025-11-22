import '../../domain/entity/sign_up_entity.dart';

class SignUpModel extends SignUpEntity {
  const SignUpModel({
    required super.email,
    required super.fullName,
    required super.password,
    required super.phoneNumber,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      email: json['email'],
      fullName: json['fullName'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }

  SignUpEntity toEntity() {
    return SignUpEntity(
      email: email,
      fullName: fullName,
      password: password,
      phoneNumber: phoneNumber,
    );
  }
}
