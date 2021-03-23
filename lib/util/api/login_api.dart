import 'dart:convert';
import 'dart:io';

import 'package:boilerplate_flutter/util/api/endpoints.dart';
import 'package:http/http.dart' as http;

Future login(String email, String password) async {
  Uri url = Uri.parse(EndPoints.login());
  final http.Response response =
      await http.post(url, body: {'email': email, 'password': password});
  final data = jsonDecode(response.body);

  if (response.statusCode == HttpStatus.ok) {
    print(data);
    return data;
  } else
    throw new Exception(
        'Error on request - ${response.statusCode} ${response.reasonPhrase}');
}
