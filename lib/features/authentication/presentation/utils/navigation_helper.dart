import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../group/data/datasources/local/dao/group_member_dao.dart';
import '../../../group/data/datasources/local/dao/group_dao.dart';
import '../../domain/entities/user.dart';

class NavigationHelper {
  static Future<void> navigateAfterLogin(
    BuildContext context,
    User user,
  ) async {
    print('🧭 NAVIGATION: ===== NAVIGATION HELPER CALLED =====');
    print(
      '🧭 NAVIGATION: Starting navigation for user ${user.firstName} (ID: ${user.id})',
    );
    print('🧭 NAVIGATION: User phone: ${user.phone}');
    print('🧭 NAVIGATION: User active status: ${user.isActive}');

    try {
      final groupMemberDAO = getIt<GroupMemberDAO>();
      final groupDAO = getIt<GroupDAO>();

      print('🧭 NAVIGATION: Checking user group memberships directly...');

      // Get all group memberships for this user
      final memberships = await groupMemberDAO.getMembersByUserId(
        int.parse(user.id),
      );
      print('🧭 NAVIGATION: Found ${memberships.length} group memberships');

      if (memberships.isEmpty) {
        print(
          '🧭 NAVIGATION: User has no group memberships - navigating to group selection',
        );
        Navigator.of(context).pushReplacementNamed('/group-selection');
        return;
      }

      // Get the group details for all memberships
      final List<dynamic> userGroups = [];
      for (final membership in memberships) {
        try {
          final membershipEntity = membership.toEntity();
          final group = await groupDAO.getGroupById(
            membershipEntity.groupId.toString(),
          );
          if (group != null) {
            userGroups.add(group.toEntity());
          }
        } catch (e) {
          print(
            '🧭 NAVIGATION: Error getting group ${membership.toEntity().groupId}: $e',
          );
        }
      }

      print('🧭 NAVIGATION: User is member of ${userGroups.length} groups');

      if (userGroups.isEmpty) {
        print(
          '🧭 NAVIGATION: No valid groups found - navigating to group selection',
        );
        Navigator.of(context).pushReplacementNamed('/group-selection');
        return;
      }

      // Check if user is admin of any groups
      final adminGroups = userGroups
          .where((group) => group.adminId == int.parse(user.id))
          .toList();

      if (adminGroups.isNotEmpty) {
        print('🧭 NAVIGATION: User is admin of ${adminGroups.length} groups');

        if (adminGroups.length == 1) {
          final group = adminGroups.first;
          print(
            '🧭 NAVIGATION: User has only one admin group - navigating to group detail: ${group.name}',
          );
          Navigator.of(context).pushReplacementNamed(
            '/group-detail',
            arguments: {
              'groupId': group.id.toString(),
              'groupName': group.name,
              'isAdmin': true,
            },
          );
        } else {
          print(
            '🧭 NAVIGATION: User has multiple admin groups - navigating to admin dashboard',
          );
          Navigator.of(context).pushReplacementNamed('/admin-dashboard');
        }
      } else {
        print('🧭 NAVIGATION: User is member but not admin of any groups');

        if (userGroups.length == 1) {
          final group = userGroups.first;
          print(
            '🧭 NAVIGATION: User has only one group - navigating to group detail: ${group.name}',
          );
          Navigator.of(context).pushReplacementNamed(
            '/group-detail',
            arguments: {
              'groupId': group.id.toString(),
              'groupName': group.name,
              'isAdmin': false,
            },
          );
        } else {
          print(
            '🧭 NAVIGATION: User has multiple groups - navigating to member dashboard',
          );
          Navigator.of(
            context,
          ).pushReplacementNamed('/member-dashboard', arguments: user);
        }
      }
    } catch (e) {
      print('🧭 NAVIGATION ERROR: $e - defaulting to group selection');
      Navigator.of(context).pushReplacementNamed('/group-selection');
    }
  }
}
