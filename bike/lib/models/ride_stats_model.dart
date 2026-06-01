import 'rider_model.dart';

class RideRecord {
  final String id;
  final String groupId;
  final String groupName;
  final String riderId;
  final RiderRole rolePlayedDuringRide;
  final DateTime rideDate;
  final double distanceKm;
  final int durationMinutes;

  RideRecord({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.riderId,
    required this.rolePlayedDuringRide,
    required this.rideDate,
    required this.distanceKm,
    required this.durationMinutes,
  });
}

class RideStatistics {
  final String riderId;
  final String riderName;
  final int totalRidesCompleted;
  final double totalDistanceKm;
  final int totalDurationMinutes;
  final Map<String, int> ridesPerGroup; // groupName -> count
  final Map<RiderRole, int> rolesDistribution; // role -> count
  final Map<String, RideStats> statsPerGroup; // groupId -> RideStats

  RideStatistics({
    required this.riderId,
    required this.riderName,
    required this.totalRidesCompleted,
    required this.totalDistanceKm,
    required this.totalDurationMinutes,
    required this.ridesPerGroup,
    required this.rolesDistribution,
    required this.statsPerGroup,
  });

  double get averageDistancePerRide =>
      totalRidesCompleted > 0 ? totalDistanceKm / totalRidesCompleted : 0;

  int get averageDurationPerRide => totalRidesCompleted > 0
      ? (totalDurationMinutes / totalRidesCompleted).toInt()
      : 0;
}

class RideStats {
  final String groupId;
  final String groupName;
  final int ridesCount;
  final double totalDistance;
  final int totalDuration;
  final Map<RiderRole, int> roleDistribution;

  RideStats({
    required this.groupId,
    required this.groupName,
    required this.ridesCount,
    required this.totalDistance,
    required this.totalDuration,
    required this.roleDistribution,
  });

  double get averageDistance => ridesCount > 0 ? totalDistance / ridesCount : 0;
  int get averageDuration =>
      ridesCount > 0 ? (totalDuration / ridesCount).toInt() : 0;
}

class GroupRideLeadership {
  final String groupId;
  final String groupName;
  final int totalRidesLed;
  final int totalRidesCoLed;
  final int totalRidesGuarded;
  final double percentageLed;
  final double percentageCoLed;
  final double percentageGuarded;

  GroupRideLeadership({
    required this.groupId,
    required this.groupName,
    required this.totalRidesLed,
    required this.totalRidesCoLed,
    required this.totalRidesGuarded,
    required this.percentageLed,
    required this.percentageCoLed,
    required this.percentageGuarded,
  });
}
