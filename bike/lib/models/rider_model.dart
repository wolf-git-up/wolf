enum RiderRole {
  leader,
  coLeader,
  guard, // after co-leader or before tail
  midRider, // mid
  tail,
}

extension RiderRoleExtension on RiderRole {
  String get displayName {
    switch (this) {
      case RiderRole.leader:
        return 'Leader';
      case RiderRole.coLeader:
        return 'Co-Leader';
      case RiderRole.guard:
        return 'Guard';
      case RiderRole.midRider:
        return 'Mid Rider';
      case RiderRole.tail:
        return 'Tail';
    }
  }

  /// Short position tag shown on formation
  String get positionTag {
    switch (this) {
      case RiderRole.leader:
        return 'TAIL'; // leader rides at tail by co-leader's assignment
      case RiderRole.coLeader:
        return 'LEAD'; // co-leader is at the front
      case RiderRole.guard:
        return 'GUARD';
      case RiderRole.midRider:
        return 'MID';
      case RiderRole.tail:
        return 'TAIL';
    }
  }

  String get emoji {
    switch (this) {
      case RiderRole.leader:
        return '👑';
      case RiderRole.coLeader:
        return '🥈';
      case RiderRole.guard:
        return '🛡️';
      case RiderRole.midRider:
        return '🏍️';
      case RiderRole.tail:
        return '🚩';
    }
  }
}

class Rider {
  final String id;
  final String name;
  final String avatarInitials;
  RiderRole role;
  final bool isCurrentUser;

  Rider({
    required this.id,
    required this.name,
    required this.role,
    this.isCurrentUser = false,
  }) : avatarInitials = name
           .trim()
           .split(' ')
           .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
           .take(2)
           .join();

  Rider copyWith({RiderRole? role}) {
    return Rider(
      id: id,
      name: name,
      role: role ?? this.role,
      isCurrentUser: isCurrentUser,
    );
  }
}

class RiderGroup {
  final String id;
  String name;
  List<Rider> members;
  final String leaderId;

  RiderGroup({
    required this.id,
    required this.name,
    required this.members,
    required this.leaderId,
  });

  Rider? get leader =>
      members.firstWhere((m) => m.id == leaderId, orElse: () => members.first);

  bool isLeader(String riderId) => riderId == leaderId;

  /// Formation order: CoLeader → Guard → MidRiders → Guard → Leader/Tail
  List<Rider> get formationOrder {
    final coLeaders = members
        .where((m) => m.role == RiderRole.coLeader)
        .toList();
    final guards = members.where((m) => m.role == RiderRole.guard).toList();
    final midRiders = members
        .where((m) => m.role == RiderRole.midRider)
        .toList();
    final leaders = members.where((m) => m.role == RiderRole.leader).toList();
    final tails = members.where((m) => m.role == RiderRole.tail).toList();

    // front guard(s) after co-leader, back guard(s) before tail
    final frontGuards = guards.take((guards.length / 2).ceil()).toList();
    final backGuards = guards.skip((guards.length / 2).ceil()).toList();

    return [
      ...coLeaders,
      ...frontGuards,
      ...midRiders,
      ...backGuards,
      ...tails,
      ...leaders,
    ];
  }
}
