import 'package:flutter/foundation.dart';
import '../../models/rider_model.dart';
import '../../models/ride_stats_model.dart';

class SquadProvider extends ChangeNotifier {
  List<RiderGroup> _groups = [];
  RiderGroup? _activeGroup;
  List<RideRecord> _rideRecords = [];
  final Map<String, List<SquadChatMessage>> _chatMessagesByGroup = {};

  // Simulate current logged-in user as leader
  final String currentUserId = 'user_001';
  final String currentUserName = 'You (Leader)';

  List<RiderGroup> get groups => _groups;
  RiderGroup? get activeGroup => _activeGroup;
  List<RideRecord> get rideRecords => _rideRecords;

  SquadProvider() {
    _initDemo();
  }

  void _initDemo() {
    final leader = Rider(
      id: currentUserId,
      name: currentUserName,
      role: RiderRole.leader,
      isCurrentUser: true,
    );
    _groups = [
      RiderGroup(
        id: 'grp_001',
        name: 'Thunder Hawks',
        leaderId: currentUserId,
        kind: SquadKind.squad,
        members: [leader],
      ),
    ];
    _activeGroup = _groups.first;
    _chatMessagesByGroup['grp_001'] = [
      SquadChatMessage(
        id: 'msg_001',
        groupId: 'grp_001',
        senderId: currentUserId,
        senderName: currentUserName,
        text: 'Welcome to Thunder Hawks!',
        sentAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
    ];

    // Initialize with sample ride records
    _initSampleRides();
  }

  void _initSampleRides() {
    final now = DateTime.now();
    _rideRecords = [
      RideRecord(
        id: 'ride_001',
        groupId: 'grp_001',
        groupName: 'Thunder Hawks',
        riderId: currentUserId,
        rolePlayedDuringRide: RiderRole.leader,
        rideDate: now.subtract(const Duration(days: 30)),
        distanceKm: 25.5,
        durationMinutes: 120,
      ),
      RideRecord(
        id: 'ride_002',
        groupId: 'grp_001',
        groupName: 'Thunder Hawks',
        riderId: currentUserId,
        rolePlayedDuringRide: RiderRole.leader,
        rideDate: now.subtract(const Duration(days: 20)),
        distanceKm: 18.3,
        durationMinutes: 90,
      ),
      RideRecord(
        id: 'ride_003',
        groupId: 'grp_001',
        groupName: 'Thunder Hawks',
        riderId: currentUserId,
        rolePlayedDuringRide: RiderRole.coLeader,
        rideDate: now.subtract(const Duration(days: 10)),
        distanceKm: 32.0,
        durationMinutes: 150,
      ),
      RideRecord(
        id: 'ride_004',
        groupId: 'grp_001',
        groupName: 'Thunder Hawks',
        riderId: currentUserId,
        rolePlayedDuringRide: RiderRole.leader,
        rideDate: now.subtract(const Duration(days: 5)),
        distanceKm: 22.8,
        durationMinutes: 110,
      ),
    ];
  }

  RiderGroup createGroup(String name, {SquadKind kind = SquadKind.squad}) {
    final group = createConfiguredGroup(name: name, kind: kind);
    return group;
  }

  RiderGroup createConfiguredGroup({
    required String name,
    SquadKind kind = SquadKind.squad,
    List<SquadMemberSetup> members = const [],
  }) {
    final leader = Rider(
      id: currentUserId,
      name: currentUserName,
      role: RiderRole.leader,
      isCurrentUser: true,
    );
    final maxAdditionalMembers = kind.maxAdditionalMembers;
    final limitedMembers = maxAdditionalMembers == null
        ? members
        : members.take(maxAdditionalMembers).toList();
    final group = RiderGroup(
      id: 'grp_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      leaderId: currentUserId,
      kind: kind,
      members: [
        leader,
        ...limitedMembers.map(
          (member) => Rider(
            id: 'rider_${DateTime.now().microsecondsSinceEpoch}_${member.name.hashCode.abs()}',
            name: member.name,
            role: member.role,
          ),
        ),
      ],
    );
    _groups.add(group);
    _activeGroup = group;
    _chatMessagesByGroup[group.id] = [];
    notifyListeners();
    return group;
  }

  void setActiveGroup(RiderGroup group) {
    _activeGroup = group;
    notifyListeners();
  }

  /// Only leader can add members
  bool addMember(String groupId, String name) {
    final group = _getGroup(groupId);
    if (group == null) return false;
    if (!group.isLeader(currentUserId)) return false;

    final rider = Rider(
      id: 'rider_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      role: RiderRole.midRider, // default role
    );
    group.members.add(rider);
    notifyListeners();
    return true;
  }

  void removeMember(String groupId, String riderId) {
    final group = _getGroup(groupId);
    if (group == null) return;
    if (!group.isLeader(currentUserId)) return;
    if (riderId == currentUserId) return; // cannot remove self
    group.members.removeWhere((m) => m.id == riderId);
    notifyListeners();
  }

  /// Only leader can assign roles
  bool assignRole(String groupId, String riderId, RiderRole role) {
    final group = _getGroup(groupId);
    if (group == null) return false;
    if (!group.isLeader(currentUserId)) return false;
    if (riderId == currentUserId && role != RiderRole.leader) {
      return false; // leader stays leader
    }

    final idx = group.members.indexWhere((m) => m.id == riderId);
    if (idx == -1) return false;
    group.members[idx] = group.members[idx].copyWith(role: role);
    notifyListeners();
    return true;
  }

  void renameGroup(String groupId, String newName) {
    final group = _getGroup(groupId);
    if (group == null) return;
    group.name = newName;
    notifyListeners();
  }

  /// Only leader can delete a group
  bool deleteGroup(String groupId) {
    final group = _getGroup(groupId);
    if (group == null) return false;
    if (!group.isLeader(currentUserId)) return false;

    _groups.removeWhere((g) => g.id == groupId);
    _chatMessagesByGroup.remove(groupId);

    // If the deleted group was active, select another group or set to null
    if (_activeGroup?.id == groupId) {
      _activeGroup = _groups.isNotEmpty ? _groups.first : null;
    }

    notifyListeners();
    return true;
  }

  List<SquadChatMessage> getChatMessages(String groupId) {
    return List.unmodifiable(_chatMessagesByGroup[groupId] ?? []);
  }

  bool sendChatMessage(String groupId, String text) {
    final group = _getGroup(groupId);
    final messageText = text.trim();
    if (group == null || messageText.isEmpty) return false;
    if (!group.members.any((member) => member.id == currentUserId)) {
      return false;
    }

    final message = SquadChatMessage(
      id: 'msg_${DateTime.now().microsecondsSinceEpoch}',
      groupId: groupId,
      senderId: currentUserId,
      senderName: currentUserName,
      text: messageText,
      sentAt: DateTime.now(),
    );
    _chatMessagesByGroup.putIfAbsent(groupId, () => []).add(message);
    notifyListeners();
    return true;
  }

  RiderGroup? _getGroup(String id) {
    try {
      return _groups.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  /// RIDE STATISTICS FUNCTIONS
  /// Function 1: Record a new ride
  void recordRide({
    required String groupId,
    required String groupName,
    required RiderRole rolePlayedDuringRide,
    required double distanceKm,
    required int durationMinutes,
  }) {
    final rideRecord = RideRecord(
      id: 'ride_${DateTime.now().millisecondsSinceEpoch}',
      groupId: groupId,
      groupName: groupName,
      riderId: currentUserId,
      rolePlayedDuringRide: rolePlayedDuringRide,
      rideDate: DateTime.now(),
      distanceKm: distanceKm,
      durationMinutes: durationMinutes,
    );
    _rideRecords.add(rideRecord);
    notifyListeners();
  }

  /// Function 2: Get overall ride statistics for current user
  RideStatistics getRideStatisticsForUser() {
    final userRides = _rideRecords
        .where((r) => r.riderId == currentUserId)
        .toList();

    if (userRides.isEmpty) {
      return RideStatistics(
        riderId: currentUserId,
        riderName: currentUserName,
        totalRidesCompleted: 0,
        totalDistanceKm: 0,
        totalDurationMinutes: 0,
        ridesPerGroup: {},
        rolesDistribution: {},
        statsPerGroup: {},
      );
    }

    // Calculate totals
    final totalDistance = userRides.fold<double>(
      0,
      (sum, ride) => sum + ride.distanceKm,
    );
    final totalDuration = userRides.fold<int>(
      0,
      (sum, ride) => sum + ride.durationMinutes,
    );

    // Count rides per group
    final ridesPerGroup = <String, int>{};
    for (var ride in userRides) {
      ridesPerGroup[ride.groupName] = (ridesPerGroup[ride.groupName] ?? 0) + 1;
    }

    // Count role distribution
    final rolesDistribution = <RiderRole, int>{};
    for (var ride in userRides) {
      rolesDistribution[ride.rolePlayedDuringRide] =
          (rolesDistribution[ride.rolePlayedDuringRide] ?? 0) + 1;
    }

    // Calculate stats per group
    final statsPerGroup = <String, RideStats>{};
    for (var group in _groups) {
      final groupRides = userRides.where((r) => r.groupId == group.id).toList();
      if (groupRides.isNotEmpty) {
        final groupDistance = groupRides.fold<double>(
          0,
          (sum, ride) => sum + ride.distanceKm,
        );
        final groupDuration = groupRides.fold<int>(
          0,
          (sum, ride) => sum + ride.durationMinutes,
        );

        // Role distribution in this group
        final groupRolesDistribution = <RiderRole, int>{};
        for (var ride in groupRides) {
          groupRolesDistribution[ride.rolePlayedDuringRide] =
              (groupRolesDistribution[ride.rolePlayedDuringRide] ?? 0) + 1;
        }

        statsPerGroup[group.id] = RideStats(
          groupId: group.id,
          groupName: group.name,
          ridesCount: groupRides.length,
          totalDistance: groupDistance,
          totalDuration: groupDuration,
          roleDistribution: groupRolesDistribution,
        );
      }
    }

    return RideStatistics(
      riderId: currentUserId,
      riderName: currentUserName,
      totalRidesCompleted: userRides.length,
      totalDistanceKm: totalDistance,
      totalDurationMinutes: totalDuration,
      ridesPerGroup: ridesPerGroup,
      rolesDistribution: rolesDistribution,
      statsPerGroup: statsPerGroup,
    );
  }

  /// Function 3: Get detailed ride statistics per group
  List<RideStats> getRideStatisticsPerGroup() {
    final stats = <RideStats>[];

    for (var group in _groups) {
      final groupRides = _rideRecords
          .where((r) => r.groupId == group.id)
          .toList();

      if (groupRides.isNotEmpty) {
        final totalDistance = groupRides.fold<double>(
          0,
          (sum, ride) => sum + ride.distanceKm,
        );
        final totalDuration = groupRides.fold<int>(
          0,
          (sum, ride) => sum + ride.durationMinutes,
        );

        // Count role distribution in this group
        final roleDistribution = <RiderRole, int>{};
        for (var ride in groupRides) {
          roleDistribution[ride.rolePlayedDuringRide] =
              (roleDistribution[ride.rolePlayedDuringRide] ?? 0) + 1;
        }

        stats.add(
          RideStats(
            groupId: group.id,
            groupName: group.name,
            ridesCount: groupRides.length,
            totalDistance: totalDistance,
            totalDuration: totalDuration,
            roleDistribution: roleDistribution,
          ),
        );
      }
    }

    return stats;
  }

  /// Function 4: Get group ride leadership statistics
  List<GroupRideLeadership> getGroupRideLeadership() {
    final leadership = <GroupRideLeadership>[];

    for (var group in _groups) {
      final groupRides = _rideRecords
          .where((r) => r.groupId == group.id)
          .toList();

      if (groupRides.isNotEmpty) {
        final leaderRides = groupRides
            .where((r) => r.rolePlayedDuringRide == RiderRole.leader)
            .length;
        final coLeaderRides = groupRides
            .where((r) => r.rolePlayedDuringRide == RiderRole.coLeader)
            .length;
        final guardRides = groupRides
            .where((r) => r.rolePlayedDuringRide == RiderRole.guard)
            .length;

        final total = groupRides.length.toDouble();
        final percentageLed = (leaderRides / total * 100);
        final percentageCoLed = (coLeaderRides / total * 100);
        final percentageGuarded = (guardRides / total * 100);

        leadership.add(
          GroupRideLeadership(
            groupId: group.id,
            groupName: group.name,
            totalRidesLed: leaderRides,
            totalRidesCoLed: coLeaderRides,
            totalRidesGuarded: guardRides,
            percentageLed: percentageLed,
            percentageCoLed: percentageCoLed,
            percentageGuarded: percentageGuarded,
          ),
        );
      }
    }

    return leadership;
  }
}
