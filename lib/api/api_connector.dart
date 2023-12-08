import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class ApiConnector {
  final String baseUrl;
  final Map<String, String> headers = {
    'Cookie':
        'XSRF-TOKEN=eyJpdiI6IjNnSDdpM3ZDMTc5QkRtQ0p2WFEvVlE9PSIsInZhbHVlIjoiWHE0U08vOERxcFN0OGV5WXFRRTAvZ0pnNzNGUDhYdmhDNGpXMldKNkpraElFYTUwUWhwa01IR3RIUHhkZG93TkRFbURzQXM4UUR2MlJhdWc1VnpvUnV0a2R1cm0xTTkvUWpad1I1U0UxRXJuUWNVM0ZTWkdnKzA3aDd4U0lLWCsiLCJtYWMiOiI1OGMzM2M3OGJhMjM1M2Y1YWM0MTgyYWM2MGU2NDQ1MzllZTkzOTFlNGY1NTRjMjU0MjI1MmIxNmQ2OTg0NWMyIiwidGFnIjoiIn0%3D; serdash_session=eyJpdiI6IlJVQUpSNE1FTTJGK2sySmxpbVplQmc9PSIsInZhbHVlIjoiS0V3ckNydmJzQTRhSU1Bd0hyZVNEVkpTWnVyUXdLcFc4Vk8yejN3MkdvQ2lJZUxzS1NmWmNCaUtZVDFIdnZhNlo2TDhSdW1hUWc5bkZZWWsrbll3dzk0TnRSZkZsejFqbmVVTlNnd1kxZm10T0NhKzNpWlRxTWxsVU9mbVJXTkciLCJtYWMiOiJjZGU4ZDg0YjEwOTRlMTc1OWQ1ZDYwNWI2NWY5ODYyNTBkZThlYzNlNzQ5NWUxNTg0NTk0ZTAzMWU1ZTY2OWFhIiwidGFnIjoiIn0%3D',
    'Content-Type': 'application/json'
  };

  /// Initializes the [ApiConnector] with the base URL of the API.
  ApiConnector({required this.baseUrl});

  /// Sends a request to the API endpoint with the specified method and data.
  ///
  /// Returns a [Map] containing the response data.
  Future<Map<String, dynamic>> _sendRequest(String endpoint, String method,
      {Map<String, dynamic>? data}) async {
    final Uri url = Uri.parse('$baseUrl/$endpoint');
    final request = http.Request(method, url);
    request.headers.addAll(headers);
    final http.StreamedResponse response = await request.send();
    final String responseBody = await utf8.decodeStream(response.stream);
    dev.log(responseBody);
    if (response.statusCode == 200) {
      return json.decode(responseBody);
    } else {
      dev.log(response.statusCode.toString());
      return Future.value({'error': responseBody.toString()});
    }
  }

  /// Sends a request to the API to get the list of posts.
  ///
  /// Returns a [Map] containing the response data.
  Future<Map<String, dynamic>> getPosts(id) async {
    final response = await _sendRequest('get_posts?id=$id', 'GET');
    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.value({'error': response.toString()});
    }
  }

  /// Sends a request to the API to get the list of posts.
  ///
  /// Returns a [Map] containing the response data.
  Future<Map<String, dynamic>> getComments() async {
    final response = await _sendRequest('comments', 'GET');
    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.error('Connection Error');
    }
  }

  Future<Map<String, dynamic>> _sendPostRequest(
      String endpoint, Map<String, String> data) async {
    final Uri url = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', url);
    request.fields.addAll(data);
    final response = await request.send();
    final responseBody = await utf8.decodeStream(response.stream);
    if (response.statusCode == 200) {
      return json.decode(responseBody);
    } else {
      return Future.value({'error': response.statusCode});
    }
  }

  /// Sends a sign-in request to the API with the specified email and password.
  ///
  /// Returns a [Map] containing the response data.
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response =
        await _sendRequest('sign_in?email=$email&password=$password', 'GET');

    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.error('Connection Error');
    }
  }

  /// Sends a sign-up request to the API with the specified username and password.
  ///
  /// Returns a [Map] containing the response data.
  Future<Map<String, dynamic>> signUp(
      String username, String password, String email) async {
    final Map<String, String> data = {
      'name': username.toString(),
      'password': password.toString(),
      'email': email.toString(),
    };
    final response = await _sendPostRequest('sign_up', data);

    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.error('Connection Error');
    }
  }

  /// Sends a request to add a comment to a post in the API.
  ///
  /// Returns a [Map] containing the response data.
  ///
  Future<Map<String, dynamic>> addComment(
      String postId, String comment, int userId) async {
    /// Map [data] to be sent in the request
    final Map<String, dynamic> data = {
      'postId': postId,
      'comment': comment,
      'user_id': userId
    };
    final response = await _sendRequest('add_comment', 'POST', data: data);
    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.error('Connection Error');
    }
  }

  /// Sends a request to remove a comment in the API.
  ///
  /// Returns a [Map] containing the response data.
  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    final response = await _sendRequest(
      'delete_comment?id=$commentId',
      'GET',
    );
    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.error('Connection Error');
    }
  }

  /// Sends a request to remove an account in the API.
  ///
  /// Returns a [Map] containing the response data.
  Future<Map<String, dynamic>> deleteAccount(String userId) async {
    final response = await _sendRequest('delete_ccount?id=$userId', 'GET');
    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.error('Connection Error');
    }
  }

  /// Sends a request to post a service in the API.
  ///
  /// Returns a [Map] containing the response data.
  Future<Map<String, dynamic>> addService(
      String serviceName, String description) async {
    final Map<String, dynamic> data = {
      'serviceName': serviceName,
      'description': description
    };
    return await _sendRequest('add_service', 'POST', data: data);
  }

  /// Sends a request to add a post in the API.
  ///
  /// Returns a [Map] containing the response data.
  Future<Map<String, dynamic>> addPost(
      String title, String content, int id) async {
    final Map<String, String> data = {
      'title': title,
      'content': content,
      'id': id.toString()
    };
    final response = await _sendPostRequest('add_post', data);
    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.value({'error': response.toString()});
    }
  }

  Future<Map<String, dynamic>> deletePost(id) async {
    final response = await _sendRequest('delete_post?id=$id', 'GET');

    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.value({'error': response.toString()});
    }
  }

  Future<Map<String, dynamic>> getErrors() async {
    final response = await _sendRequest('get_errors', 'GET');
    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.value({'error': response.toString()});
    }
  }

  Future<Map<String, dynamic>> uploadProfile(int? uid, File? file) async {
    final url = Uri.parse('$baseUrl/update_profile');
    final request = http.MultipartRequest(
      'POST',
      url,
    );
    http.MultipartFile.fromPath(
      'file',
      file!.path,
    ).then((value) {
      request.files.add(value);
    });
    request.fields.addAll({'id': uid.toString()});

    final response = await request.send();
    final responseBody = await utf8.decodeStream(response.stream);
    dev.log(responseBody.toString());

    if (response.statusCode == 200 && responseBody.isNotEmpty) {
      return json.decode(responseBody);
    } else {
      dev.log(response.statusCode.toString());
      return Future.value({'error': response.toString()});
    }
  }

  Future<Map<String, dynamic>> changePassword(
      int? id, String newPassword) async {
    final response = await _sendPostRequest(
        'change_psw',
        {'id': id.toString(), 'password': newPassword});
    if (response.isNotEmpty) {
      return response;
    } else {
      return Future.value({'error': response.toString()});
    }
  }

  Future<Map<String, dynamic>> getPostsOrigin() async {
    final response = await _sendRequest('get_posts_all', 'GET');
    if (response.isNotEmpty) {
      return response;
    }
    else {
      dev.log(response.toString());
      return Future.value({'error': response.toString()});
    }
  }
}
