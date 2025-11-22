import '../../../../core/data/app_urls.dart';
import '../../../../core/data/network/network_api_services.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_map.dart';
import '../../../../core/error/failures.dart';
import '../model/sign_up_model.dart';
import 'authentication_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.apiService});

  final NetworkApiServices apiService;

  @override
  Future<SignUpModel> signUp({
    required String email,
    required String fullName,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final response = await apiService.postApi(
        url: AppUrls.signin,
        data: {
          'email': email,
          'fullName': fullName,
          'password': password,
          'phoneNumber': phoneNumber,
        },
      );

      return SignUpModel.fromJson(response);
    } on AppException catch (e) {
      throw FailureMapper.mapExceptionToFailure(e);
    } catch (e) {
      throw UnexpectedFailure();
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(Duration(milliseconds: 500));
  }
}
