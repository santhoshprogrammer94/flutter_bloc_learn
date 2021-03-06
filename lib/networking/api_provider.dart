import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:streamchucknorris/networking/custom_exception.dart';

class ApiProvider {
  final String _baseUrl = "http://api.chucknorris.io/";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet Conn');
    }

    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());

      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());

      case 500:

      default:
        throw FetchDataException('Error Communication with Server with Code: ${response.statusCode}');
    }
  }
}
