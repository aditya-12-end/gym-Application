import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class WorkoutService {
  static const baseUrl = "http://10.0.2.2:3000";

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    final all = await storage.readAll();
    print("STORAGE CONTENTS: $all");

    final token = await storage.read(key: "jwt_token");
    print("TOKEN READ: $token");

    return token;
  }

  Future<String> createWorkout({
    required String workoutName,
    required String targetedMuscle,
    required List<Map<String, dynamic>> exercises,
  }) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }
    if (workoutName.isEmpty || targetedMuscle.isEmpty || exercises.isEmpty) {
      throw Exception("Enter the data first");
    }
    final response = await http.post(
      Uri.parse("$baseUrl/workout/createWorkout"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "workoutName": workoutName,
        "targetedMuscle": targetedMuscle,
        "exercises": exercises,
      }),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201) {
      return jsonDecode(response.body)["message"];
    }

    throw Exception(response.body);
  }

  Future<List<dynamic>> getMyWorkouts() async {
    final token = await _getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/workout/myWorkouts"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(response.body);
  }

  Future<Map<String, dynamic>> getWorkout(int workoutId) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/workout/workout/$workoutId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(response.body);
  }

  Future<String> deleteWorkout(int workoutId) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.delete(
      Uri.parse("$baseUrl/workout/workout/$workoutId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["message"];
    }

    throw Exception(response.body);
  }

  Future<void> deleteExercise(int exerciseId) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.delete(
      Uri.parse("$baseUrl/workout/exercise/$exerciseId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}
