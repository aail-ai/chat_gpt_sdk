import 'dart:developer';
import 'dart:io';

import 'package:chat_gpt_sdk/src/utils/token_builder.dart';
import 'package:dio/dio.dart';

import '../../utils/constants.dart';

class InterceptorWrapper extends Interceptor {
  final Dio _dio;

  InterceptorWrapper(this._dio);

  // @override
  // void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  //   options.headers.addAll(
  //     kHeader(
  //       TokenBuilder.build.token,
  //       TokenBuilder.build.orgId,
  //     ),
  //   );
  //
  //   return handler.next(options); // super.onRequest(options, handler);
  // }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //debugPrint('http status code => ${response.statusCode} \nresponse data => ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //debugPrint('have Error [${err.response?.statusCode}] => Data: ${err.response?.data}');
    switch (err.type) {
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 401:
            _handleExpiredToken(err, handler);
            return;
        }
        break;

      default:
        throw err;
    }
    super.onError(err, handler);
  }

  void _handleExpiredToken(
      DioException error, ErrorInterceptorHandler handler) async {
    log('try to handle expired token');

    final String? refreshToken = await TokenBuilder.build.refreshToken;

    if (refreshToken != null && refreshToken.isNotEmpty) {
      /// Check if the last API call was `auth/verify/`. If, then replace the old token
      /// with the new (refreshed) one.
      final requestOptions = error.requestOptions;
      requestOptions.headers['Authorization'] =
          'Bearer $refreshToken';

      log('handle expired token succeed with token ${refreshToken}');

      return handler.resolve(await _retry(requestOptions));
    }
    handler.next(error);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
