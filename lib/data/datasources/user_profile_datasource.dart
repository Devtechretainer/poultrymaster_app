import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileDataSource {
  final Dio dio;
  final String baseUrl;

  UserProfileDataSource({required this.dio, required this.baseUrl});

  Future<UserProfile> createUserProfile(UserProfile userProfile) async {
    if (kDebugMode) {
      print('Creating user profile with baseUrl: $baseUrl');
    }
    try {
      final response = await dio.post(
        '$baseUrl/api/UserProfile/create',
        data: userProfile.toJson(),
      );
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to create user profile');
      }
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  Future<UserProfile> updateUserProfile(UserProfile userProfile) async {
    if (kDebugMode) {
      print('Updating user profile with baseUrl: $baseUrl');
    }
    
    try {
      final response = await dio.put(
        '$baseUrl/api/UserProfile/update',
        data: userProfile.toJson(),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('UserProfile update successful. Response data: ${response.data}');
        }
        // The backend returns an IdentityResult, not the user profile.
        // On success, we assume the update worked and return the original object
        // that was passed in, which contains the user's edits from the UI.
        return userProfile;
      } else {
        if (kDebugMode) {
          print('Failed to update user profile. Status code: ${response.statusCode}, Response data: ${response.data}');
        }
        throw Exception('Failed to update user profile: Status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException during user profile update: ${e.message}');
        if (e.response != null) {
          print('DioException response status: ${e.response?.statusCode}');
          print('DioException response data: ${e.response?.data}');
        }
      }
      throw Exception('Failed to update user profile: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('Generic exception during user profile update: $e');
      }
      throw Exception('Failed to update user profile: $e');
    }
  }

  Future<void> deleteUserProfile(String id) async {
    if (kDebugMode) {
      print('Deleting user profile with baseUrl: $baseUrl');
    }
    try {
      final response = await dio.delete(
        '$baseUrl/api/UserProfile/$id',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete user profile');
      }
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  Future<UserProfile> findUserProfile(String id) async {
    if (kDebugMode) {
      print('Finding user profile with baseUrl: $baseUrl');
    }
    try {
      final response = await dio.get(
        '$baseUrl/api/UserProfile/find',
        queryParameters: {'id': id},
      );
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to find user profile');
      }
    } catch (e) {
      throw Exception('Failed to find user profile: $e');
    }
  }

  Future<UserProfile> findUserProfileByUsername(String normalizedUserName) async {
    if (kDebugMode) {
      print('Finding user profile by username with baseUrl: $baseUrl');
    }
    try {
      final response = await dio.get(
        '$baseUrl/api/UserProfile/findByUserName',
        queryParameters: {'normalizedUserName': normalizedUserName},
      );
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to find user profile by username');
      }
    } catch (e) {
      throw Exception('Failed to find user profile by username: $e');
    }
  }
}
