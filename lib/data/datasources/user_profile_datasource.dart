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
      print('Update payload: ${userProfile.toJson()}');
    }

    try {
      final response = await dio.post(
        '$baseUrl/api/UserProfile/update',
        data: userProfile.toJson(),
      );

      if (kDebugMode) {
        print('Update response status code: ${response.statusCode}');
        print('Update response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        final result = response.data;
        if (result['succeeded'] == true) {
          // The backend returns an IdentityResult, not the user profile.
          // On success, we refetch the user profile to ensure the data is fresh.
          return await findUserProfile(userProfile.id!);
        } else {
          final errors = result['errors'] as List<dynamic>;
          final errorMessage = errors.isNotEmpty
              ? errors[0]['description']
              : 'Failed to update user profile.';
          throw Exception(errorMessage);
        }
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
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
      print('Finding user profile with baseUrl: $baseUrl and id: $id');
    }
    try {
      final response = await dio.get(
        '$baseUrl/api/UserProfile/find',
        queryParameters: {'id': id},
      );
      if (kDebugMode) {
        print('Find user profile response status code: ${response.statusCode}');
        print('Find user profile response data: ${response.data}');
      }
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
