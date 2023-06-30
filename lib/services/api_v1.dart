import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:cute/services/const.dart';
import 'package:cute/services/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class ApiV1Service {
  static final Dio _dio = Dio(
    BaseOptions(
      contentType: 'application/json',
      baseUrl: Const.apiV1Url,
      connectTimeout: Duration(milliseconds: 10000),
      receiveTimeout: Duration(milliseconds: 50000),
    ),
  );
  const ApiV1Service();

  ///
  Future<PersistCookieJar> initCookiesManager() async {
    // Cookie files will be saved in files in "./cookies"
    _dio.interceptors.clear();
    final cj = await getCookieJar();
    _dio.interceptors.add(CookieManager(cj));
    _dio.interceptors.add(CustomInterceptor());
    return cj;
  }

  static Future<PersistCookieJar> getCookieJar() async {
    Directory tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    return PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(tempPath),
    );
  }

  ///
  static Future<Response> postRequest(String url,
      {Map<String, dynamic>? data, FormData? formData, String? token}) async {
    // print(_dio.options.baseUrl + url);
    return await _dio.post(url,
        data: data,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));
  }

  ///
  static Future<Response> getRequest(String url,
      {Map<String, dynamic>? queryParameters, String? token}) async {
    print(_dio.options.baseUrl + url);
    return await _dio.get(url,
        queryParameters: queryParameters,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));
  }

  ///
  static Future<Response> putRequest(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
  }) async {
    return await _dio.put(url, data: formData ?? data);
  }

  ///
  static Future<Response> deleteRequest(String url,
      {Map<String, dynamic>? data}) async {
    return await _dio.delete(url);
  }

  ///
  static Future<Response> patchRequest(String url,
      {Map<String, dynamic>? data, FormData? formData, String? token}) async {
    print(_dio.options.baseUrl + url);

    if (data == null) {
      print('data is null');
      return await _dio.patch(url,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
    } else {
      print('data is not null ${data.toString()}');
      return await _dio.patch(url,
          data: data,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
    }
  }
}
