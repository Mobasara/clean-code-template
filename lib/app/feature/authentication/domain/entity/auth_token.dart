class AuthToken {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  
  AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });
}