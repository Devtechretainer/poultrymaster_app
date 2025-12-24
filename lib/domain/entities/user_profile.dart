import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String? id;
  final String? userName;
  final String? normalizedUserName;
  final String? email;
  final String? normalizedEmail;
  final bool? emailConfirmed;
  final String? passwordHash;
  final String? securityStamp;
  final String? concurrencyStamp;
  final String? phoneNumber;
  final bool? phoneNumberConfirmed;
  final bool? twoFactorEnabled;
  final DateTime? lockoutEnd;
  final bool? lockoutEnabled;
  final int? accessFailedCount;
  final String? farmId;
  final String? farmName;
  final bool? isStaff;
  final bool? isSubscriber;
  final String? refreshToken;
  final DateTime? refreshTokenExpiry;
  final String? firstName;
  final String? lastName;
  final String? customerId;
  final DateTime? lastLoginTime;

  const UserProfile({
    this.id,
    this.userName,
    this.normalizedUserName,
    this.email,
    this.normalizedEmail,
    this.emailConfirmed,
    this.passwordHash,
    this.securityStamp,
    this.concurrencyStamp,
    this.phoneNumber,
    this.phoneNumberConfirmed,
    this.twoFactorEnabled,
    this.lockoutEnd,
    this.lockoutEnabled,
    this.accessFailedCount,
    this.farmId,
    this.farmName,
    this.isStaff,
    this.isSubscriber,
    this.refreshToken,
    this.refreshTokenExpiry,
    this.firstName,
    this.lastName,
    this.customerId,
    this.lastLoginTime,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userName: json['userName'],
      normalizedUserName: json['normalizedUserName'],
      email: json['email'],
      normalizedEmail: json['normalizedEmail'],
      emailConfirmed: json['emailConfirmed'],
      passwordHash: json['passwordHash'],
      securityStamp: json['securityStamp'],
      concurrencyStamp: json['concurrencyStamp'],
      phoneNumber: json['phoneNumber'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
      twoFactorEnabled: json['twoFactorEnabled'],
      lockoutEnd: json['lockoutEnd'] != null ? DateTime.parse(json['lockoutEnd']) : null,
      lockoutEnabled: json['lockoutEnabled'],
      accessFailedCount: json['accessFailedCount'],
      farmId: json['farmId'],
      farmName: json['farmName'],
      isStaff: json['isStaff'],
      isSubscriber: json['isSubscriber'],
      refreshToken: json['refreshToken'],
      refreshTokenExpiry: json['refreshTokenExpiry'] != null ? DateTime.parse(json['refreshTokenExpiry']) : null,
      firstName: json['firstName'],
      lastName: json['lastName'],
      customerId: json['customerId'],
      lastLoginTime: json['lastLoginTime'] != null ? DateTime.parse(json['lastLoginTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'normalizedUserName': normalizedUserName,
      'email': email,
      'normalizedEmail': normalizedEmail,
      'emailConfirmed': emailConfirmed,
      'passwordHash': passwordHash,
      'securityStamp': securityStamp,
      'concurrencyStamp': concurrencyStamp,
      'phoneNumber': phoneNumber,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'twoFactorEnabled': twoFactorEnabled,
      'lockoutEnd': lockoutEnd?.toIso8601String(),
      'lockoutEnabled': lockoutEnabled,
      'accessFailedCount': accessFailedCount,
      'farmId': farmId,
      'farmName': farmName,
      'isStaff': isStaff,
      'isSubscriber': isSubscriber,
      'refreshToken': refreshToken,
      'refreshTokenExpiry': refreshTokenExpiry?.toIso8601String(),
      'firstName': firstName,
      'lastName': lastName,
      'customerId': customerId,
      'lastLoginTime': lastLoginTime?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userName,
        normalizedUserName,
        email,
        normalizedEmail,
        emailConfirmed,
        passwordHash,
        securityStamp,
        concurrencyStamp,
        phoneNumber,
        phoneNumberConfirmed,
        twoFactorEnabled,
        lockoutEnd,
        lockoutEnabled,
        accessFailedCount,
        farmId,
        farmName,
        isStaff,
        isSubscriber,
        refreshToken,
        refreshTokenExpiry,
        firstName,
        lastName,
        customerId,
        lastLoginTime,
      ];
}
