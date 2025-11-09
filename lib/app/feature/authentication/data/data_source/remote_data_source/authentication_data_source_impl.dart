import '../../../../../core/data/app_urls.dart';
import '../../../../../core/data/network/network_api_services.dart';
import '../../../../../core/error/exceptions.dart';
import '../../model/user_model.dart';
import 'authentication_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.apiService});

  final NetworkApiServices apiService;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiService.postApi(
        url: AppUrls.login,
        data: {'email': email, 'password': password},
      );

      return UserModel.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to login');
    }
  }
}
