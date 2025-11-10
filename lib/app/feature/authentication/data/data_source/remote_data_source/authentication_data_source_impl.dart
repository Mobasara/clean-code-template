import '../../../../../core/data/app_urls.dart';
import '../../../../../core/data/network/network_api_services.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_map.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/results.dart' as results;
import '../../model/user_model.dart';
import 'authentication_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.apiService});

  final NetworkApiServices apiService;

  @override
  Future<results.Result<UserModel>> login(String email, String password) async {
    try {
      final response = await apiService.postApi(
        url: AppUrls.login,
        data: {'email': email, 'password': password},
      );

      return results.Success(UserModel.fromJson(response));
    } on AppException catch (e) {
      final failure = FailureMapper.mapExceptionToFailure(e);
      return results.Error(failure);
    } catch (e) {
      return const results.Error(UnexpectedFailure());
    }
  }
}
