import 'dart:io';
import 'package:dio/dio.dart';
import 'package:todo_app/shared/constans/urls.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(BaseOptions(
        baseUrl: BASEURL,
        receiveDataWhenStatusError: true,
        ));
  }

  static Future<Response> getData(
      {required String url,
       Map<String, dynamic>? qury,
      String lang = 'en',
      dynamic token}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': '${lang}',
      'Authorization': '${token}'
    };
    return await dio!.get(url, queryParameters: qury);
  }

  static Future<Response> postData(
      {required String url,
      Map<String, dynamic>? qury,
      required Map<String, dynamic> data,
      dynamic token,
      String lang = 'en'}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': '${lang}',
      'Authorization': ' ${token}'
    };
    return await dio!.post(
      url,
      queryParameters: qury,
      data: data,
    );
  }
  static Future<Response> putData(
      {required String url,
        Map<String, dynamic>? qury,
         Map<String, dynamic>? data,
        dynamic token,
        String lang = 'en'}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': '${lang}',
      'Authorization': ' ${token}'
    };
    return await dio!.put(
      url,
      queryParameters: qury,
      data: data,
    );
  }


  static Future<Response> DeleteData(
      {required String url,
        Map<String, dynamic>? qury,
         Map<String, dynamic>? data,
        dynamic token,
        String lang = 'en'}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': '${lang}',
      'Authorization': ' ${token}'
    };
    return await dio!.delete(
      url,
      queryParameters: qury,
      data: data,
    );
  }




}
void setupDioForTests() {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        if (options.path == '/login') {
          return handler.resolve(
            Response(
              data: {
                'id': '1',
                'token': 'test_token',
                'refreshToken': 'test_refresh_token',
              },
              statusCode: 200,
              requestOptions: options,
            ),
          );
        } else if (options.path == '/tasks' && options.method == 'POST') {
          return handler.resolve(
            Response(
              data: {
                'id': '2',
                'todo': 'New Task',
                'completed': false,
              },
              statusCode: 200,
              requestOptions: options,
            ),
          );
        } else if (options.path == '/tasks/2' && options.method == 'PUT') {
          return handler.resolve(
            Response(
              data: {
                'id': '2',
                'todo': 'Updated Task',
                'completed': true,
              },
              statusCode: 200,
              requestOptions: options,
            ),
          );
        } else if (options.path == '/tasks/2' && options.method == 'DELETE') {
          return handler.resolve(
            Response(
              statusCode: 200,
              requestOptions: options,
            ),
          );
        }
        return handler.next(options); // استمر في المعالجة الأصلية إذا لم يكن هناك تطابق
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response); // تمرير الاستجابة كما هي
      },
      onError: (DioError error, ErrorInterceptorHandler handler) {
        return handler.next(error); // تمرير الخطأ كما هو
      },
    ),
  );
}

