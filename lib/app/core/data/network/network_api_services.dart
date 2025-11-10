import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../error/exceptions.dart';
import '../app_urls.dart';
import '../local/local_data.dart';
import 'base_client.dart';

class NetworkApiServices extends BaseClient {
  final LocalData localData;

  NetworkApiServices(this.localData);

  /// 🔹 Configure base options for Dio
  Future<BaseOptions> _getBaseOptions({Map<String, dynamic>? query}) async {
    final token = localData.getAccessToken();

    return BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      queryParameters: query,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": token.isNotEmpty ? "Bearer $token" : null,
      },
      validateStatus: (status) => status != null && status < 550,
    );
  }

  /// 🔹 Create Dio instance (with interceptors)
  Dio _createDio() {
    final dio = Dio();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            log("➡️ [${options.method}] ${options.uri}");
            if (options.data != null) log("🧾 Body: ${options.data}");
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) log("✅ [${response.statusCode}] ${response.data}");
          return handler.next(response);
        },
        onError: (e, handler) {
          if (kDebugMode) log("❌ DioError: ${e.message}");
          return handler.next(e);
        },
      ),
    );

    return dio;
  }

  /// ------------------------
  /// 🔹 GET
  /// ------------------------
  @override
  Future<dynamic> getApi({
    required String url,
    Map<String, dynamic>? data,
    required context,
  }) async {
    try {
      final dio = _createDio();
      dio.options = await _getBaseOptions(query: data);
      final response = await dio.get(url, queryParameters: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// ------------------------
  /// 🔹 POST
  /// ------------------------
  @override
  Future<dynamic> postApi({required String url, data, context}) async {
    try {
      final dio = _createDio();
      dio.options = await _getBaseOptions();
      final response = await dio.post(url, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// ------------------------
  /// 🔹 PUT (Update)
  /// ------------------------
  @override
  Future<dynamic> updateApi({
    required String url,
    data,
    required context,
  }) async {
    try {
      final dio = _createDio();
      dio.options = await _getBaseOptions();
      final response = await dio.put(url, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// ------------------------
  /// 🔹 DELETE
  /// ------------------------
  @override
  Future<dynamic> deleteApi({required String url, required context}) async {
    try {
      final dio = _createDio();
      dio.options = await _getBaseOptions();
      final response = await dio.delete(url);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// ------------------------
  /// 🔹 Handle HTTP responses
  /// ------------------------
  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;

      case 400:
        throw ValidationException(
          message: response.data['message'] ?? 'Bad request',
          code: '400',
        );

      case 401:
        throw AuthenticationException(
          message: response.data['message'] ?? 'Unauthorized',
          code: '401',
        );

      case 403:
        throw UnauthorizedException(
          message: response.data['message'] ?? 'Forbidden',
          code: '403',
        );

      case 404:
        throw NotFoundException(
          message: response.data['message'] ?? 'Not found',
          code: '404',
        );

      case 408:
        throw TimeoutException(message: 'Request timeout', code: '408');

      case 422:
        throw ValidationException(
          message: response.data['message'] ?? 'Validation failed',
          code: '422',
          errors: response.data['errors'] != null
              ? Map<String, String>.from(response.data['errors'])
              : null,
        );

      case 500:
      case 502:
      case 503:
        throw ServerException(
          message: response.data['message'] ?? 'Server error occurred',
          code: '${response.statusCode}',
        );

      default:
        throw ServerException(
          message: 'Unexpected error occurred',
          code: '${response.statusCode}',
        );
    }
  }

  /// ------------------------
  /// 🔹 Map DioError to AppException
  /// ------------------------
  AppException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();

      case DioExceptionType.badResponse:
        final response = e.response;
        if (response != null) {
          return _mapResponseToException(response);
        }
        return ServerException(message: 'Bad response from server');

      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.cancel:
        return NetworkException(message: 'Request was cancelled');

      default:
        return ServerException(message: e.message ?? 'Unknown network error');
    }
  }

  /// ------------------------
  /// 🔹 Convert Response → Exception
  /// ------------------------
  AppException _mapResponseToException(Response response) {
    final statusCode = response.statusCode ?? 500;
    final message = (response.data is Map)
        ? response.data['message'] ?? 'Unexpected error'
        : 'Unexpected error';

    switch (statusCode) {
      case 400:
        return ValidationException(message: message, code: '400');
      case 401:
        return AuthenticationException(message: message, code: '401');
      case 403:
        return UnauthorizedException(message: message, code: '403');
      case 404:
        return NotFoundException(message: message, code: '404');
      case 408:
        return TimeoutException(message: 'Request timeout', code: '408');
      case 422:
        return ValidationException(message: message, code: '422');
      case 500:
      case 502:
      case 503:
        return ServerException(message: message, code: '$statusCode');
      default:
        return ServerException(
          message: 'Unexpected error',
          code: '$statusCode',
        );
    }
  }
}

// class NetworkApiServices extends BaseClient {
//   final LocalData localData;

//   NetworkApiServices(this.localData);

//   int retryCount = 0;
//   static const int maxRetries = 8;

//   Future<BaseOptions> getBaseOptions({
//     Map<String, dynamic>? query,
//   }) async {
//     final token = localData.getAccessToken();

//     BaseOptions options = BaseOptions(
//       connectTimeout: const Duration(minutes: 10),
//       receiveTimeout: const Duration(seconds: 5000),
//       followRedirects: false,
//       validateStatus: (status) {
//         return status! < 550;
//       },
//       queryParameters: query,
//       baseUrl: AppUrls.baseUrl,
//       headers: {
//         "Accept": "application/json",
//         'Content-type': 'application/json',
//         'X-Requested-With': 'XMLHttpRequest',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     return options;
//   }

//   @override
//   Future getApi({url, data, required context}) async {
//     if (kDebugMode) {
//       log('api request url:  $url');
//       log('api request Data:  $data');
//     }
//     Dio dio = Dio(await getBaseOptions(query: data));

//     dynamic responseJson;
//     try {
//       Response response = await dio.get(url, data: data);
//       if (kDebugMode) {
//         print(response.statusCode);
//         log(response.data);
//         print(response);
//       }

//       responseJson = _returnResponse(response: response);
//     } catch (e) {
//       log(e.toString());
//     }

//     return responseJson;
//   }

//   @override
//   Future<dynamic> postApi({url, data, context}) async {
//     if (kDebugMode) {
//       log('api request url:  $url');
//       log('api request data:  $data');
//     }
//     Dio dio = Dio(await getBaseOptions());

//     dynamic responseJson;
//     final response = await dio.post(url, data: data);
//     if (kDebugMode) {
//       print(response.statusCode);
//       log(response.data);
//       print(response);
//     }

//     responseJson = _returnResponse(response: response);

//     return responseJson;
//   }

//   @override
//   Future updateApi({url, data, context}) async {
//     if (kDebugMode) {
//       log('api request url:  $url');
//       log('api request data:  $data');
//     }
//     Dio dio = Dio(await getBaseOptions());

//     dynamic responseJson;
//     try {
//       final response = await dio.put(url, data: data);
//       if (kDebugMode) {
//         print(response);
//       }
//       responseJson = _returnResponse(response: response);
//     } catch (e) {
//       if (kDebugMode) {
//         print('errors');
//       }
//       log(e.toString());
//     }

//     return responseJson;
//   }

//   @override
//   Future deleteApi({url, context}) async {
//     if (kDebugMode) {
//       log('api request url:  $url');
//     }
//     Dio dio = Dio(await getBaseOptions());

//     dynamic responseJson;
//     try {
//       final response = await dio.delete(url);
//       if (kDebugMode) {
//         print(response.statusCode);
//         log(response.data);
//         print(response);
//       }
//       responseJson = _returnResponse(response: response);
//     } catch (e) {
//       log(e.toString());
//       if (kDebugMode) {
//         print('e');
//       }
//     }

//     return responseJson;
//   }

//   dynamic _returnResponse({required Response response}) {
//     switch (response.statusCode) {
//       case 200:
//       case 201:
//         return response.data;

//       case 400:
//         throw ValidationException(
//           message: response.data['message'] ?? 'Bad request',
//           code: '400',
//         );

//       case 401:
//         // Handle token expiration
//         UnauthorizedException();
//         throw AuthenticationException(
//           message: response.data['message'] ?? 'Unauthorized',
//           code: '401',
//         );

//       case 403:
//         throw UnauthorizedException(
//           message: response.data['message'] ?? 'Forbidden',
//           code: '403',
//         );

//       case 404:
//         throw NotFoundException(
//           message: response.data['message'] ?? 'Not found',
//           code: '404',
//         );

//       case 408:
//         throw TimeoutException(message: 'Request timeout', code: '408');

//       case 422:
//         throw ValidationException(
//           message: response.data['message'] ?? 'Validation failed',
//           code: '422',
//           errors: response.data['errors'],
//         );

//       case 500:
//       case 502:
//       case 503:
//         throw ServerException(
//           message: response.data['message'] ?? 'Server error occurred',
//           code: '${response.statusCode}',
//         );

//       default:
//         throw ServerException(
//           message: 'Unexpected error occurred',
//           code: '${response.statusCode}',
//         );
//     }
//   }
// }
