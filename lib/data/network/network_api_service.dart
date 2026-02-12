import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ngo_app/view_models/user_prefernce/user_preference.dart';
import '../../view_models/auth_service/auth_service.dart';
import '../exeception/app_execution.dart';
import 'base_api_service.dart';

class NetworkApiService extends BasicApiService {

  final user= UserPreference();
  final AuthService authService = AuthService();

  Future<bool> refreshTokenSilently() async {
    try {
      await authService.refreshToken();
      return true;
    } catch (_) {
      await user.logout();
      return false;
    }
  }


  @override
  Future getAPI(String url) async {
    dynamic data;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));
      data = returnResponse(response);
    } on SocketException {
      throw InternetException('Check your Internet Connection');
    } on RequestTimeOut {
      throw RequestTimeOut('Request Time out');
    }
    return data;
  }

  @override
  Future<dynamic> getAPIWithToken(String URL) async {
    final token = await user.getToken();
    dynamic data;
    try {
      final response = await http
          .get(Uri.parse(URL),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          })
          .timeout(const Duration(seconds: 30));

      debugPrint("Response code in API: ${response.statusCode.toString()}");

      if (response.statusCode == 401) {
        debugPrint("401 received → refreshing token");
        final refreshed = await authService.refreshToken();

        if (refreshed) {
          debugPrint("Token refreshed → retrying API");
          return await getAPIWithToken(URL); // 🔁 RETRY
        } else {
          throw FetchDataException('Session Expired');
        }
      }
      data = returnResponse(response);
    } on SocketException {
      throw InternetException('Check your Internet Connection');
    } on RequestTimeOut {
      throw RequestTimeOut('Request Time out');
    }
    return data;
  }

  @override
  Future<dynamic> postAPI(data, String URL) async {
    final token = await user.getToken();
    dynamic responseData;
    try {
      final response = await http
          .post(Uri.parse(URL),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(data),
      ).timeout(const Duration(seconds: 30));

      debugPrint("Response code in API: ${response.statusCode.toString()}");

      if (response.statusCode == 401) {
        final refreshed = await authService.refreshToken();

        if (refreshed) {
          return await postAPI(data, URL); // 🔁 retry
        } else {
          throw FetchDataException('Session Expired');
        }
      }

      responseData = returnResponse(response);

    } on SocketException {
      throw InternetException('Check your Internet Connection');
    } on RequestTimeOut {
      throw RequestTimeOut('Request Time out');
    }
    return responseData;
  }

  @override
  Future<dynamic> putAPI(data, String URL) async {
    final token = await user.getToken();
    dynamic responseData;
    try {
      final response = await http
          .put(Uri.parse(URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 401) {
        final refreshed = await authService.refreshToken();

        if (refreshed) {
          return await postAPI(data, URL); // 🔁 retry
        } else {
          throw FetchDataException('Session Expired');
        }
      }

      responseData = returnResponse(response);

    } on SocketException {
      throw InternetException('Check your Internet Connection');
    } on RequestTimeOut {
      throw RequestTimeOut('Request Time out');
    }
    return responseData;
  }

  @override
  Future<dynamic> deleteAPI(String URL) async {
    final token = await user.getToken();
    dynamic responseData;
    try {
      final response = await http
          .delete(Uri.parse(URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 401) {
        final refreshed = await authService.refreshToken();

        if (refreshed) {
          return await deleteAPI(URL); // 🔁 retry
        } else {
          throw FetchDataException('Session Expired');
        }
      }

      responseData = returnResponse(response);

    } on SocketException {
      throw InternetException('Check your Internet Connection');
    } on RequestTimeOut {
      throw RequestTimeOut('Request Time out');
    }
    return responseData;
  }

  Future postMultipartAPI(
      data,
      String URL,
      File file,
      String fieldName,
      String fileName,
      ) async {
    dynamic responseData;
    var uri = Uri.parse(URL);
    try {
      final request = await http.MultipartRequest('POST', uri);
      request.fields.addAll(data);
      request.files.add(
        http.MultipartFile(
          fieldName,
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: fileName,
        ),
      );

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        responseData = await streamedResponse.stream.bytesToString();
        print(responseData);
      } else {
        throw HttpException(
          'Failed to upload. Status code: ${streamedResponse.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('Check your Internet connection');
    } on RequestTimeOut {
      throw RequestTimeOut('Request Time out');
    }

    return responseData;
  }

  dynamic returnResponse(http.Response response) async{
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        debugPrint("Response from API: ${responseJson.toString()}  ${response.statusCode}");
        return responseJson;
      case 401:
        debugPrint("Response from API: ${response.statusCode}");
        await refreshTokenSilently();
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      default:
        throw FetchDataException('Error while fetching data');
    }
  }

  // Multipart Request  to send image in API
  @override
  Future<dynamic> multipartRequest({
    required String url,
    required String token,
    Map<String, String>? fields,
    Map<String, File>? files,
    Map<String, String>? headers,
  }) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add authorization token
      request.headers['Authorization'] = 'Bearer $token';

      // Add additional headers if provided
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Add form fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add files
      if (files != null) {
        for (var entry in files.entries) {
          if (entry.value.existsSync()) {
            request.files.add(
              await http.MultipartFile.fromPath(entry.key, entry.value.path),
            );
          }
        }
      }

      // Send request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      // Handle response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(responseData);
      } else {
        throw HttpException(
          'Request failed with status: ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
    } catch (e) {
      throw HttpException('Multipart request failed: $e', uri: Uri.parse(url));
    }
  }
}