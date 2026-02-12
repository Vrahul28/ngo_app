import 'dart:io';

abstract class BasicApiService {
  Future<dynamic> getAPI(String URL);
  Future<dynamic> getAPIWithToken(String URL);
  Future<dynamic> postAPI(dynamic data, String URL);
  Future<dynamic> putAPI(dynamic data, String URL);
  Future<dynamic> deleteAPI(String URL);
  // New multipart request method
  Future<dynamic> multipartRequest({
    required String url,
    required String token,
    Map<String, String>? fields,
    Map<String, File>? files,
    Map<String, String>? headers,
  });
}
