import 'package:cute/services/global.dart';
import 'package:cute/services/locator.dart';
import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print(err.message);
    print("object");
    final errorMessage = err.response?.data is List
        ? err.response?.data['message']
        : err.message;
    const message = "Something went wrong";
    locator<GlobalServices>().errorSnackBar(errorMessage ?? message);
    return super.onError(err, handler);
  }
}
