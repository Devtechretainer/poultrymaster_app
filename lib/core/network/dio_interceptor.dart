import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart';


class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    const _currentUserKey = 'current_user';
    final userJson = prefs.getString(_currentUserKey);

    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap).toEntity();
        if (user.token != null) {
          options.headers['Authorization'] = 'Bearer ${user.token}';
        }
      } catch (e) {
        // Ignore errors, and just continue without the header.
      }
    }
    super.onRequest(options, handler);
  }
}
