/// User roles in the system
enum UserRole { guard, parent, admin }

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.guard:
        return 'Guard';
      case UserRole.parent:
        return 'Parent';
      case UserRole.admin:
        return 'Admin';
    }
  }
}
