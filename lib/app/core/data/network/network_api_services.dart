import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../error/exceptions.dart';
import '../local/local_data.dart';
import '../app_urls.dart';
import 'base_client.dart';

class NetworkApiServices extends BaseClient {
  final LocalData localData;

  NetworkApiServices(this.localData);

  int retryCount = 0;
  static const int maxRetries = 8;

  Future<BaseOptions> getBaseOptions({
    Map<String, dynamic>? query,
  }) async {
    final token = localData.getAccessToken();

    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(minutes: 10),
      receiveTimeout: const Duration(seconds: 5000),
      followRedirects: false,
      validateStatus: (status) {
        return status! < 550;
      },
      queryParameters: query,
      baseUrl: AppUrls.baseUrl,
      headers: {
        "Accept": "application/json",
        'Content-type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer $token',
      },
    );

    return options;
  }

  @override
  Future getApi({url, data, required context}) async {
    if (kDebugMode) {
      log('api request url:  $url');
      log('api request Data:  $data');
    }
    Dio dio = Dio(await getBaseOptions(query: data));

    dynamic responseJson;
    try {
      Response response = await dio.get(url, data: data);
      if (kDebugMode) {
        print(response.statusCode);
        log(response.data);
        print(response);
      }

      responseJson = _returnResponse(response: response);
    } catch (e) {
      log(e.toString());
    }

    return responseJson;
  }

  @override
  Future<dynamic> postApi({url, data, context}) async {
    if (kDebugMode) {
      log('api request url:  $url');
      log('api request data:  $data');
    }
    Dio dio = Dio(await getBaseOptions());

    dynamic responseJson;
    final response = await dio.post(url, data: data);
    if (kDebugMode) {
      print(response.statusCode);
      log(response.data);
      print(response);
    }

    responseJson = _returnResponse(response: response);

    return responseJson;
  }

  @override
  Future updateApi({url, data, context}) async {
    if (kDebugMode) {
      log('api request url:  $url');
      log('api request data:  $data');
    }
    Dio dio = Dio(await getBaseOptions());

    dynamic responseJson;
    try {
      final response = await dio.put(url, data: data);
      if (kDebugMode) {
        print(response);
      }
      responseJson = _returnResponse(response: response);
    } catch (e) {
      if (kDebugMode) {
        print('errors');
      }
      log(e.toString());
    }

    return responseJson;
  }

  @override
  Future deleteApi({url, context}) async {
    if (kDebugMode) {
      log('api request url:  $url');
    }
    Dio dio = Dio(await getBaseOptions());

    dynamic responseJson;
    try {
      final response = await dio.delete(url);
      if (kDebugMode) {
        print(response.statusCode);
        log(response.data);
        print(response);
      }
      responseJson = _returnResponse(response: response);
    } catch (e) {
      log(e.toString());
      if (kDebugMode) {
        print('e');
      }
    }

    return responseJson;
  }

  dynamic _returnResponse({required Response response}) {
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
        // Handle token expiration
        UnauthorizedException();
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
          errors: response.data['errors'],
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
}
