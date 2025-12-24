import 'package:dio/dio.dart';

import 'api_service.dart';

class PublicService {
  static final Dio _dio = Dio();
  PublicService._();
  static Dio get dio {
    _dio.options.baseUrl = Api.baseUrl;
    return _dio;
  }
}
