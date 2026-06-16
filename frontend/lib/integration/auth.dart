import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:3000";
const storage = FlutterSecureStorage();
Future<String> registerUser({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse("${baseUrl}/auth/createUser"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 201) {
    return 'User Created Successfully';
  }

  throw Exception(response.body);
}

Future<String> loginUser({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse("${baseUrl}/auth/loginUser"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  print("LOGIN RESPONSE: ${response.body}");

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    print("TOKEN FROM API: ${data["token"]}");

    await storage.write(key: "jwt_token", value: data["token"]);

    final savedToken = await storage.read(key: "jwt_token");

    print("SAVED TOKEN: $savedToken");

    return data["message"];
  }

  throw Exception(data["message"]);
}

Future<Map<String, dynamic>> getUser() async {
  final token = await storage.read(key: "jwt_token");

  print("TOKEN => $token");

  if (token == null) {
    throw Exception("No token found");
  }

  final response = await http.get(
    Uri.parse("${baseUrl}/auth/getUser"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  print("STATUS => ${response.statusCode}");
  print("BODY => ${response.body}");

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception("Failed to fetch user data");
}
